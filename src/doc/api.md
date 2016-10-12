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

* 入力された文字列に対応したサンプルを返す
    * サンプルの上限はn_limitで指定する
    * サンプルは上限以内に関係性の強い順に返す
    * 各サンプルはオブジェクトで返され次の値を持つ
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

*  入力された文字列に対応した単語・微生物を環境トピックについて返す
    * トピックの上限はn_topic_limitで指定する
    * トピック毎の要素の上限はn_element_limitで指定する
    * トピック, 要素は上限以内に関係性の強い順に返す
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
                    + soil (string)
                    + dog (string)
                    + wood (string)
                    + forest (string)
                    + leaf (string)
                + taxonomy (array, required)
                    + enterococcus (string)
                    + streptococcus (string)
                    + betabactor (string)
                    + proteobacteria (string)
                    + actinobacteria (string)
            + (object)
                + word (array, required)
                    + sediment (string)
                    + rock (string)
                    + cow (string)
                    + foot (string)
                    + shoes (string)
                + taxonomy (array, required)
                    + chloroflexi (string)
                    + tenericutes (string)
                    + deinococcus-Thermus (string)
                    + proteobacteria (string)
                    + firmicutes (string)

## 単語から意味的トピックを取得 [/string/{searched_string}/topics/semantic{?n_topic_limit,n_element_limit}]

### 意味的トピック取得API [GET]

#### 処理概要

*  入力された文字列に対応した単語・微生物を意味的トピックについて返す
    * トピックの上限はn_topic_limitで指定する
    * トピック毎の要素の上限はn_element_limitで指定する
    * トピック, 要素は上限以内に関係性の強い順に返す
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
                    + soil (string)
                    + dog (string)
                    + wood (string)
                    + forest (string)
                    + leaf (string)
                + taxonomy (array, required)
                    + enterococcus (string)
                    + streptococcus (string)
                    + betabactor (string)
                    + proteobacteria (string)
                    + actinobacteria (string)
            + (object)
                + word (array, required)
                    + sediment (string)
                    + rock (string)
                    + cow (string)
                    + foot (string)
                    + shoes (string)
                + taxonomy (array, required)
                    + chloroflexi (string)
                    + tenericutes (string)
                    + deinococcus-Thermus (string)
                    + proteobacteria (string)
                    + firmicutes (string)

## サンプルの位置を返す [/sample/location]

### 位置取得API [GET]

#### 処理概要

* サンプルの位置を返す

+ Response 200 (application/json)

    + Attributes
        + sample_list(array, required)
            + (object)
                + x : 23.4 (number, required)
                + y : 235.2 (number, required)
                + sample_id : DRS000009 (string, required)
                
## サンプルIDから系統組成取得 [/sample/{sample_id}/taxonomies/{taxon_rank}]

### 系統組成取得API [GET]

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

### 系統組成取得API [GET]

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

### メタデータ取得API [GET]

#### 処理概要

* 入力されたサンプルのメタデータを返す
* sample_idは必要。無かった場合はBadRequestを返す。
* 入力されたsample_idが存在しなかった場合Not Foundを返す

+ Parameters
    + sample_id: DRS000009(string, required)

+ Response 200 (application/json)

    + Attributes
        + metadata(required)
            + sample_name: hot spring sample(string, required)


## トピックIDから単語組成取得 [/topic/words/{topic_id}]

### 単語組成取得API [GET]

#### 処理概要

* 入力されたトピックIDの単語組成を返す
* トピックidは必要。無かった場合BadRequestを返す。
+ 入力されたトピックIDが無かった場合はNot Foundを返す。

+ Parameters
    + topic_id: 4(number, required)
    
+ Response 200 (application/json)
    
    + Attributes
        + word_list(array, required)
            + (object)
                + word: dog(string, required)
                + value: 0.34 (number, required)
            + (object)
                + word: foot(string, required)
                + value: 0.21 (number, required)

## トピックIDから系統組成取得 [/topic/taxonomies/{topic_id}]

### 系統組成取得API [GET]

#### 処理概要

* 入力されたトピックIDの系統組成を返す
* トピックidは必要。無かった場合BadRequestを返す。
+ 入力されたトピックIDが無かった場合はNot Foundを返す。

+ Parameters
    + topic_id: 4(number, required)
    
+ Response 200 (application/json)
    
    + Attributes
        + taxonomy_list(array, required)
            + (object)
                + taxonomy_name: firmicutes(string, required)
                + value: 0.34 (number, required)
            + (object)
                + taxonomy_name: proteobacteria(string, required)
                + value: 0.25 (number, required)
