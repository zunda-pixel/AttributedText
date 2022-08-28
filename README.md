# AttributedText

`AttributedText` is Custom Action `AttributedString`

`AttributedText` use `URL Scheme`

<img width="250" src="https://user-images.githubusercontent.com/47569369/187081320-e41ac170-5842-462c-8c9e-b78c50780a0a.gif">

## Issue

- 動きは問題ないのですが、URL Schemeを登録しないといけないめんどくささがあります。
  - AttributedStringをピュアに使うためには仕方ないのですが 
- `url` `@mention` `#hashtag`以外のカスタム文字列に対応させるためにはAttributedText側のコードを触らないと実装ができません。(例 `*swift`)([issues/1](https://github.com/zunda-pixel/AttributedText/issues/1))
  - 実装自体は簡単なのですが、冗長になってしまいます。


