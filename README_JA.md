# simple_jwt_manager

## 注意
現在このパッケージは開発中です。
開発完了までは利用できませんので注意してください。

## 概要
これは、JPEG画像のExif情報を読み取ったり、変更するためのパッケージです。  
このパッケージはFlutter Webでも動作するように調整されています。  

このパッケージでは、Exif 2.3規格のうち、必須のもの、または利用頻度が高いものについて実装しています。  
なお、PNGなどの他のフォーマットの付加情報については、Exif規格ではないためこのパッケージでは扱いません。

## 使い方
pub.devのExampleタブをチェックしてください。

このパッケージでは、ExifのデータはExifTagクラスとして読み取られ、
適切なExifTagクラスでのExifデータの上書きもサポートされます。

```dart

```

また、Exifのデータをまとめて消去することもできます。

```dart

```

## サポート
基本的にサポートはありません。
もし問題がある場合はGithubのissueを開いてください。
このパッケージは優先度が低いですが、修正される可能性があります。

## バージョン管理について
それぞれ、Cの部分が変更されます。  
ただし、バージョン1.0.0未満は以下のルールに関係無くファイル構造が変化する場合があります。  
- 変数の追加など、以前のファイルの読み込み時に問題が起こったり、ファイルの構造が変わるような変更
  - C.X.X
- メソッドの追加など
  - X.C.X
- 軽微な変更やバグ修正
  - X.X.C

## ライセンス
このソフトウェアはApache-2.0ライセンスの元配布されます。LICENSEファイルの内容をご覧ください。

Copyright 2024 Masahide Mori

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## 著作権表示
The “Dart” name and “Flutter” name are trademarks of Google LLC.  
*The developer of this package is not Google LLC.