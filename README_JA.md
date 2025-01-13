# simple_exif

## 概要
これは、JPEG画像のExif情報を読み取るためのパッケージです。  
このパッケージはFlutter Webでも動作するように調整されています。  

このパッケージでは、Exif 2.3規格のうち、必須のもの、または利用頻度が高いものについて実装しています。  
なお、PNGなどの他のフォーマットの付加情報については、Exif規格ではないためこのパッケージでは扱いません。  

現在の実装状況は以下の通りです。  
IFDの書き換えについても開発中で、今後サポートされる可能性があります。

- [x] 0th IFDの内容(TIFF)の読み取り
- [x] 0th IFDの内容(Exif)の読み取り
- [x] 0th IFDの内容(Interoperability)の読み取り
- [x] 0th IFDの内容(GPS)の読み取り
- [ ] 0th IFDの内容(TIFF)の書き換え、追加、削除
- [ ] 0th IFDの内容(Exif)の書き換え、追加、削除
- [ ] 0th IFDの内容(Interoperability)の書き換え、追加、削除
- [ ] 0th IFDの内容(GPS)の書き換え、追加、削除
- [ ] Exif情報の一括削除

## 使い方
pub.devのExampleタブをチェックしてください。

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

Copyright 2025 Masahide Mori

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