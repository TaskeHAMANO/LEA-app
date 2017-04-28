## LEA-app

### About
Application for Latent Environment Allocation written by ECMA Script 2015.

### Requirement
* Node.js
* npm
* bower

### How to use

#### 初回の利用

```
git clone git@github.com:TaskeHAMANO/LEA-app.git
cd LEA-app
npm install
bower install
npm run full_build
open dist/index.html
```

#### コマンド
##### npm run build
* *.tagファイルのビルドを行う
* ビルド後にフロントエンドで利用するライブラリとJavascriptファイルを結合
* 結合したファイルを圧縮
* LESSファイルをコンパイルして圧縮
* htmlファイルを圧縮

##### npm run full_build
* ```npm run build``` に加えて、画像データの圧縮を行う


### Contants

```
.
├── README.md
├── bower.json
├── bower_components
├── dist
│   ├── _bundle.min.css
│   ├── data
│   │   ├── ...
│   ├── index.html
│   ├── library.min.js
│   └── main.min.js
├── gulpfile.js
├── gulptask.js
├── node_modules
│   ├── ...
├── package.json
├── pbcopy
└── src
    ├── babel
    │   ├── Action
    │   │   ├── MouseOnStoreAction.js
    │   │   ├── SampleListStoreAction.js
    │   │   ├── SelectInfoStoreAction.js
    │   │   ├── TabStoreAction.js
    │   │   └── UserSampleListStoreAction.js
    │   ├── Constant
    │   │   ├── MouseOnActionTypes.js
    │   │   ├── SampleListActionTypes.js
    │   │   ├── SelectInfoActionTypes.js
    │   │   ├── TabActionTypes.js
    │   │   └── UserSampleListActionTypes.js
    │   └── Store
    │       ├── MouseOnStore.js
    │       ├── SampleListStore.js
    │       ├── SelectInfoStore.js
    │       ├── TabStore.js
    │       └── UserSampleListStore.js
    ├── data
    │   ├── ...
    ├── doc
    │   ├── api.html
    │   └── api.md
    ├── index.html
    ├── index.js
    └── riot
        ├── my-app.tag
        ├── my-bar.tag
        ├── my-data.tag
        ├── my-info.tag
        ├── my-map.tag
        ├── my-panel.tag
        └── my-search.tag
```

#### README.md
* このファイルです

#### bower.json
* bowerで管理している、フロントエンド側のライブラリが記述されたJSONです

#### bower_components
* bower.jsonで管理されているフロントエンドライブラリの本体が入っています
* gulptask.jsでこのディレクトリの中を見て、必要なプログラムを利用しています

#### dist
* gulpでビルドされたデプロイ用のファイルが配置されるディレクトリです

#### gulpfile.js, gulptask.js
* gulpでビルドする際の手順が記述されたファイルです

#### node_modeles
* package.jsonで管理されている、サーバーサイドライブラリの本体が入っています
* Javascriptはここにあるファイルをrequire/importすることで利用しています

#### package.json
* npmで管理している、サーバーサイドのライブラリが記述されたjsonです
* build用のnpm scriptsもここに記述されています
* 他、LEA-app全体のメタデータもここに記述されています

#### src
* LEA-appの本体となるプログラムが配置されるディレクトリです

##### babel
* Fluxパターンで構築されたLEA-appにおいて利用しているStoreの挙動が配置されています

##### data
* LEA-appで利用している画像データが配置されるディレクトリです
* ここに配置された画像データは、```npm run full_build```を実行した際に、圧縮されて/dist/dataへコピーされます

##### doc
* LEA-APIの定義をしている仕様書が置かれています
* api.mdはAPI Blueprintで書かれており、aglioを利用してapi.htmlへ変換しています

##### index.html
* LEA-appの中心となるhtmlファイルです。
* このファイルからindex.jsやriot以下に置かれているファイルを利用します

##### index.js
* LEA-appのJavascriptのハブとなるJavascriptのファイルです
* このファイル自体はRiot.jsのモジュールを呼び出しているだけです

##### riot

###### my-app.tag
* Riot.jsのコンポーネントのハブとなるファイルです
* LEA-appの全てのViewはこのファイルのサブセットとなります

###### my-bar.tag
* 棒グラフの描画を行うコンポーネントです
* my-infoから呼び出されています

###### my-data.tag
* Dataタブの描画を行うコンポーネントです
* my-panelから呼び出されています

###### my-info.tag
* informationタブの描画を行うコンポーネントです
* my-panelから呼び出されています

###### my-map.tag
* 地図部分の描画を行うコンポーネントです
* my-appから呼び出されています

###### my-panel.tag
* パネル部分の描画を行うコンポーネントです
* my-appから呼び出されています

###### my-search.tag
* Searchタブの描画を行うコンポーネントです
* my-panelから呼び出されています
