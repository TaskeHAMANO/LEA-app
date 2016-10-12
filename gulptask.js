import bower              from "main-bower-files"
import del                from "del"
import gulp               from "gulp"
import gulpHtmlmin        from "gulp-htmlmin"
import gulpRename         from "gulp-rename"
import gulpConcat         from "gulp-concat"
import gulpRiot           from "gulp-riot"
import gulpBabel          from "gulp-babel"
import gulpUglify         from "gulp-uglify"
import gulpFilter         from "gulp-filter"
import gulpMinifyCss      from "gulp-minify-css"
import gulpLess           from "gulp-less"
import gulpImagemin       from "gulp-imagemin"
import pngquant           from "imagemin-pngquant"
import {rollup}           from "rollup"
import rollupResolve      from "rollup-plugin-node-resolve"
import rollupCommonjs     from "rollup-plugin-commonjs"
import rollupBabel        from "rollup-plugin-babel"
import rollupIncludePaths from "rollup-plugin-includepaths"

const gulpClean = (...args)=> function clean(){ return del(...args); };

gulp.task("build:html", () => gulp
    .src(["src/index.html"])
    .pipe(gulpHtmlmin({ collapseWhitespace: true }))
    .pipe(gulp.dest("dist"))
);

gulp.task("select:css", () =>{
  const cssFilter = gulpFilter("**/*.css", {restore:true});
  const lessFilter = gulpFilter("**/*.less", {restore:true});
  return gulp
    .src(bower({
      paths: {
        bowerJson:'./bower.json'
      }
    }))
    .pipe(cssFilter)
    .pipe(gulpRename({
      prefix:"_",
      extname:".css"
    }))
    .pipe(gulp.dest("temp/css"))
    .pipe(cssFilter.restore)
    .pipe(lessFilter)
    .pipe(gulpLess())
    .pipe(gulpRename({
      prefix:"_",
      extname:".css"
    }))
    .pipe(gulp.dest("./temp/css"))
    .pipe(lessFilter.restore)
});

gulp.task("concat:css", () => gulp
      .src("temp/css/" + "_*.css")
      .pipe(gulpConcat({"path":"_bundle.css"}))
      .pipe(gulp.dest("temp/css"))
      .pipe(gulpMinifyCss())
      .pipe(gulpRename({
        extname:".min.css"
      }))
      .pipe(gulp.dest("dist"))
);

gulp.task("build:js", gulp.series(
    gulp.parallel(
        ()=> gulp
            .src(["src/riot/**/*.tag"])
            .pipe(gulpRiot({
                compact: true,
                type: "babel",
                parserOptions: {
                    js: {
                        babelrc: false,
                        presets: ["es2015-riot", ["latest-node6", { "es2015": false}]],
                        plugins: ["add-module-exports", "transform-runtime"],
                    },
                },
            }))
            .pipe(gulp.dest("temp/riot")),
        ()=> gulp
            .src(["src/babel/**/*.js"])
            .pipe(gulpBabel())
            .pipe(gulp.dest("temp/babel")),
        ()=> gulp
            .src(["src/index.js"])
            .pipe(gulpBabel())
            .pipe(gulp.dest("temp")),
    ),
    async ()=> {
        const bundle = await rollup({
            entry: "temp/index.js",
            plugins: [
                rollupIncludePaths({
                    include: {},
                    paths: ["temp/babel"],
                }),
                rollupResolve({ jsnext: true }),
                rollupCommonjs(),
                rollupBabel({
                    babelrc: false,
                    presets: [["es2015", { "modules": false }]],
                    plugins: ["external-helpers"],
                }),
            ],
        });

        return bundle.write({
            format: "iife",
            dest: "temp/rollup/main.js",
            moduleName: "main"
        });
    },
    ()=> gulp
        .src(["temp/rollup/main.js"])
        .pipe(gulpUglify())
        .pipe(gulpRename({ extname: ".min.js" }))
        .pipe(gulp.dest("temp/dist")),
    async ()=> {
      const jsFilter = await gulpFilter("**/*.js", {restore:true});
      return gulp
        .src(bower({
          paths:{
            bowerJson:"./bower.json"
          }
        }))
        .pipe(jsFilter)
        .pipe(gulpUglify())
        .pipe(gulpRename({ extname: ".min.js"}))
        .pipe(gulp.dest("./temp/dist"))
    },
    ()=> gulp
        .src(["src/bundle/**/*.min.js", "temp/dist/*.min.js"])
        .pipe(gulpConcat({ path: "index.js" }))
        .pipe(gulp.dest("dist")),
));

gulp.task("move_data", () => {
    const pngFilter = gulpFilter("**/*.png", {restore:true})
    const csvFilter = gulpFilter("**/*.csv", {restore:true})
    return gulp
        .src(["src/data/*"], {base:"src/data"})
        .pipe(pngFilter)
        .pipe(gulpImagemin({
          use:[pngquant()]
        }))
        .pipe(gulp.dest("dist/data"))
        .pipe(pngFilter.restore)
        .pipe(csvFilter)
        .pipe(gulp.dest("dist/data"))
        .pipe(csvFilter.restore)
});

gulp.task("build", gulp.series(
    gulpClean(["temp", "dist"]),
    gulp.parallel(
        gulp.task("build:js"),
        gulp.task("build:html"),
        gulp.task("move_data"),
    ),
    gulp.task("select:css"),
    gulp.task("concat:css"),
    gulpClean(["temp"]),
));