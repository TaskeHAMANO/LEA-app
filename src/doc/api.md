FORMAT: 1A
HOST: http://polls.apiblueprint.org/

# Latent Environment Allocation

Latent Environment Allocation(LEA)のために使われるAPI群

## ドキュメント化
なおこの文章自体は[apiary](https://apiary.io/)で書かれました。

aglioを使用したhtml化は次のとおり
```
brew install npm
npm install -g aglio
# 一回出力したい場合
aglio -i api.md -o api.html
# サーバーを立てて扱いたい場合(更新なども対応できる)
aglio -i api.md --server
```


## 単語からサンプルID取得 [/string/{searched_string}/samples{?n_limit}]

### サンプルID取得API [GET]

#### 処理概要

* 入力された文字列に対応したsampleを返す
    * sampleの上限はn_limitで指定する
    * sampleは上限以内に関係性の強い順に返す
    * 各sampleはオブジェクトで返され次の値を持つ
        * value: 関係性の強さ
        * sample_id: サンプルID
* n_limitのデフォルト値は10とする
* stringは必要。指定がない場合Bad requestを返す
* 結果が何もヒットしない場合、空の配列を返す

+ Parameters
    + searched_string: hot spring (string, required) - 検索される文字列
    + n_limit: 10 (number, optional) - 表示するサンプル数の上限

+ Response 200 (application/json)

    + Attributes
        + sample_list(array, required)
            + (object)
                + sample_id: DRS000009 (string, required)
                + value: 0.05 (number, required)
            + (object)
                + sample_id: ERS123456 (string, required)
                + value: 0.045 (number, required)
                

## 単語から生態トピックを取得 [/string/{searched_string}/topics/ecological{?n_topic_limit,n_element_limit}]

### 生態トピック取得API [GET]

#### 処理概要

*  入力された文字列に対応した単語・微生物を環境topicについて返す
    * topicの上限はn_topic_limitで指定する
    * topic毎の要素の上限はn_element_limitで指定する
    * topic, 要素は上限以内に関係性の強い順に返す
* n_topic_limitのデフォルト値は3とする
* n_element_limitのデフォルト値は5とする
* stringは必要。指定がない場合Bad requestを返す
* 結果が何もヒットしない場合、空の配列を返す

+ Parameters
    + searched_string: hot spring (string, required) - 検索される文字列
    + n_topic_limit: 3 (number, optional) - トピック数の上限
    + n_element_limit : 5 (number, optional) - トピック毎の要素数の上限

+ Response 200 (application/json)

    + Attributes
        + topic_list(array, required)
            + (object)
                + word (array, required)
                    + (object)
                        + word: soil (string)
                        + value: 0.43 (number)
                    + (object)
                        + word: dog (string)
                        + value: 0.22 (number)
                    + (object)
                        + word: wood (string)
                        + value: 0.11 (number)
                    + (object)
                        + word: forest (string)
                        + value: 0.06 (number)
                    + (object)
                        + word: leaf (string)
                        + value: 0.01 (number)
                + taxonomy (array, required)
                    + (object)
                        + taxon: enterococcus (string)
                        + value: 0.83 (number)
                    + (object)
                        + taxon: streptococcus (string)
                        + value: 0.55 (number)
                    + (object)
                        + taxon: betabactor (string)
                        + value: 0.40 (number)
                    + (object)
                        + taxon: proteobacteria (string)
                        + value: 0.30 (number)
                    + (object)
                        + taxon: actinobacteria (string)
                        + value: 0.23 (number)

## 単語から意味的トピックを取得 [/string/{searched_string}/topics/semantic{?n_topic_limit,n_element_limit}]

### 意味的トピック取得API [GET]

#### 処理概要

*  入力された文字列に対応した単語・微生物を意味的topicについて返す
    * topicの上限はn_topic_limitで指定する
    * topic毎のobjectの上限はn_element_limitで指定する
    * topic, topic内のobjectは上限以内にvalueの大きい順に返す
* n_topic_limitのデフォルト値は3とする
* n_element_limitのデフォルト値は5とする
* stringは必要。指定がない場合Bad requestを返す
* 結果が何もヒットしない場合、空の配列を返す

+ Parameters
    + searched_string: hot spring (string, required) - 検索される文字列
    + n_topic_limit: 10 (number, optional) - トピック数の上限
    + n_element_limit: 10 (number, optional) - トピック毎の要素数の上限

+ Response 200 (application/json)

    + Attributes
        + topic_list(array, required)
            + (object)
                + word (array, required)
                    + (object)
                        + word: soil (string)
                        + value: 0.87 (number)
                    + (object)
                        + word: dog (string)
                        + value: 0.60 (number)
                    + (object)
                        + word: wood (string)
                        + value: 0.55 (number)
                    + (object)
                        + word: forest (string)
                        + value: 0.43 (number)
                    + (object)
                        + word: leaf (string)
                        + value: 0.23 (number)
                + taxonomy (array, required)
                    + (object)
                        + taxon: enterococcus (string)
                        + value: 0.95 (number)
                    + (object)
                        + taxon: streptococcus (string)
                        + value: 0.44 (number)
                    + (object)
                        + taxon: betabactor (string)
                        + value: 0.39 (number)
                    + (object)
                        + taxon: proteobacteria (string)
                        + value: 0.20 (number)
                    + (object)
                        + taxon: actinobacteria (string)
                        + value: 0.02 (number)

## サンプルの位置を返す [/sample/location]

### サンプル位置取得API [GET]

#### 処理概要

* sampleの位置を返す

+ Response 200 (application/json)

    + Attributes
        + sample_list(array, required)
            + (object)
                + x : 23.4 (number, required)
                + y : 235.2 (number, required)
                + color: "#9428ff" (string, required)
                + sample_id : DRS000009 (string, required)
                
## サンプルIDから系統組成取得 [/sample/{sample_id}/taxonomies/{taxon_rank}]

### サンプル系統組成取得API [GET]

#### 処理概要

* 入力されたsample_idの系統組成を返す
* sample_id, taxon_rankは必要。無かった場合はBadRequestを返す。
* 入力されたsample_idが存在しなかった場合Not Foundを返す
* 入力されたtaxon_rankが存在しなかった場合BadRequstを返す

+ Parameters
    + sample_id: DRS000009(string, required)
    + taxon_rank: genus(string, required)

+ Response 200 (application/json)

    + Attributes
        + taxonomy_list(array, required)
            + (object)
                + taxonomy_name: firmicutes (string, required)
                + value: 0.34 (number, required)
            + (object)
                + taxonomy_name: proteobacteria (string, required)
                + value: 0.22 (number, required)

## サンプルIDからトピック組成取得 [/sample/{sample_id}/topics]

### サンプルトピック組成取得API [GET]

#### 処理概要

* 入力されたsample_idのトピック組成を返す
* sample_idは必要。無かった場合はBadRequestを返す。
* 入力されたsample_idが存在しなかった場合Not Foundを返す

+ Parameters
    + sample_id: DRS000009(string, required)

+ Response 200 (application/json)

    + Attributes
        + taxonomy_list(array, required)
            + (object)
                + topic_id: 4 (number, required)
                + value: 0.34 (number, required)
            + (object)
                + topic_id: 42 (number, required)
                + value: 0.29 (number, required)

## サンプルIDからメタデータ取得 [/sample/{sample_id}/metadata]

### サンプルメタデータ取得API [GET]

#### 処理概要

* 入力されたsample_idのメタデータを返す
* sample_idは必要。無かった場合はBadRequestを返す。
* 入力されたsample_idが存在しなかった場合Not Foundを返す

+ Parameters
    + sample_id: DRS000009(string, required)

+ Response 200 (application/json)

    + Attributes
        + metadata(required)
            + sample_name: hot spring sample(string, required)

## クラスターファイルからユーザーサンプルを登録 [/new_sample]

### クラスターファイルアップロードAPI [POST]

#### 処理概要

* ファイルをアップロードして、そのファイルに対応した座標と名前を返す
* 送信できるファイルはcluster拡張子のテキストファイルか、それが圧縮されたtar.gzファイルのどちらか

+ Request (multipart/form-data; boundary=BOUNDARY)

    + Headers
    
            Accept-Type: application-json

    + Body

            #cluster_fileの際には次
            --BOUNDARY
            
            Content-Disposition: form-data; name="cluster_file"
            Content-Type: application/octet-stream
            
            $FILE_DATA
            BOUNDARY--
            
            #clusters_targz_fileの際には次
            --BOUNDARY
            
            Content-Disposition: form-data; name="clusters_targz_file"
            Content-Type: application/x-tar
            
            $FILE_DATA
            BOUNDARY--

+ Response 201 (application/json)
    
    + Attributes
        + sample_list(array, required)
            + (object)
                + x : 23.4 (number, required)
                + y : 235.2 (number, required)
                + sample_id : 20161112181319fb26722033ff0e5d7f78a5ef55a5d58a (string, required)
                + project_id : 20161112181319fb26722033ff0e5d7f78a5ef55a5d58a (string, required)


## ユーザーサンプルIDから系統組成取得 [/new_sample/{project_id}/{sample_id}/taxonomies/{taxon_rank}]

### ユーザーサンプル系統組成取得API [GET]

#### 処理概要

* POSTされたクラスターファイルから偉えるsample_idの系統組成を返す
* sample_id, project_id, taxon_rankは必要。無かった場合はBadRequestを返す
* 入力されたproject_id, sample_idが存在しなかった場合Not Foundを返す
* 入力されたtaxon_rankが存在しなかった場合BadRequestを返す

+ Parameters
    + project_id: 20161112181319fb26722033ff0e5d7f78a5ef55a5d58a (string, required)
    + sample_id: 20161112181319fb26722033ff0e5d7f78a5ef55a5d58a (string, required)
    + taxon_rank: genus (string, required)


+ Response 200 (application/json)
    
    + Attributes
        + taxonomy_list(array, required)
            + (object)
                + taxonomy_name: firmicutes (string, required)
                + value: 0.34 (number, required)
            + (object)
                + taxonomy_name: proteobacteria (string, required)
                + value: 0.22 (number, required)

## ユーザーサンプルIDからトピック組成取得 [/new_sample/{project_id}/{sample_id}/topics]

### ユーザーサンプルトピック組成取得API [GET]

#### 処理概要

* POSTされたクラスターファイルから偉えるsample_idのトピック組成を返す
* sample_id, project_id。無かった場合はBadRequestを返す
* 入力されたproject_id, sample_idが存在しなかった場合Not Foundを返す


+ Parameters
    + project_id: 20161112181319fb26722033ff0e5d7f78a5ef55a5d58a (string, required)
    + sample_id: 20161112181319fb26722033ff0e5d7f78a5ef55a5d58a (string, required)

+ Response 200 (application/json)

    + Attributes
        + taxonomy_list(array, required)
            + (object)
                + topic_id: 4 (number, required)
                + value: 0.34 (number, required)
            + (object)
                + topic_id: 42 (number, required)
                + value: 0.29 (number, required)


## トピックの位置を返す [/topic/location]

### トピック位置取得API [GET]

#### 処理概要

* topicの位置を返す

+ Response 200 (application/json)

    + Attributes
        + topic_list(array, required)
            + (object)
                + x : 23.4 (number, required)
                + y : 235.2 (number, required)
                + topic_id : 5 (number, required)

## トピックIDから単語組成取得 [/topic/{topic_id}/words{?n_word_limit}]

### トピック単語組成取得API [GET]

#### 処理概要

* 入力されたtopic_idの単語組成を返す
* topic_idは必要。無かった場合BadRequestを返す。
* 入力されたtopic_idが無かった場合はNot Foundを返す。
* 単語はvalueの大きい順に返す
* 単語の上限数はn_word_limitで指定する。デフォルト値は5とする。


+ Parameters
    + topic_id: 4(number, required)
    + n_word_limit: 10(number)
    
+ Response 200 (application/json)
    
    + Attributes
        + word_list(array, required)
            + (object)
                + word: dog(string, required)
                + value: 0.34 (number, required)
            + (object)
                + word: foot(string, required)
                + value: 0.21 (number, required)

## トピックIDから系統組成取得 [/topic/{topic_id}/taxonomies/{taxon_rank}]

### トピック系統組成取得API [GET]

#### 処理概要

* 入力されたtopic_idの系統組成を返す
* topic_id, taxon_rankは必要。無かった場合BadRequestを返す。
* 入力されたtopic_idが無かった場合はNot Foundを返す。
* 入力されたtaxon_rankが存在しなかった場合はBadRequestを返す

+ Parameters
    + topic_id: 4(number, required)
    + taxon_rank: genus(string, required)
    
+ Response 200 (application/json)
    
    + Attributes
        + taxonomy_list(array, required)
            + (object)
                + taxonomy_name: firmicutes(string, required)
                + value: 0.34 (number, required)
            + (object)
                + taxonomy_name: proteobacteria(string, required)
                + value: 0.25 (number, required)
                
## トピックIDからメタデータ取得 [/topic/{topic_id}/metadata]

### トピックメタデータ取得API [GET]

#### 処理概要

* 入力されたtopic_idのメタデータを返す
* topic_idは必要。無かった場合BadRequestを返す。
* 入力されたtopic_idが無かった場合はNot Foundを返す。


+ Parameters
    + topic_id: 4(number, required)
    
+ Response 200 (application/json)
    
    + Attributes
        + metadata(required)
            + attribution(string, required)
            + source_url(string, required)
            + lisence(string, required)
