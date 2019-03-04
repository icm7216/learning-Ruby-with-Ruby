# learning-Ruby-with-Ruby

Make a EPUB for the "Rubyで学ぶRuby" with Pandoc.

# Description

このスクリプトは、遠藤侑介 さんによる [ASCII.jp](https://ascii.jp/) の「プログラミング＋」コーナーの連載「[Rubyで学ぶRuby](https://ascii.jp/elem/000/001/230/1230449/)」からEPUBを作成します。

Web連載のコンテンツを、さらにわかりやすく紙版の書籍として再編纂された書籍「[Rubyで学ぶRuby（紙書籍）](https://www.lambdanote.com/collections/ruby-ruby)」が[技術書出版ラムダノート株式会社](https://www.lambdanote.com/)より出版されています。


# Usage

EPUB ファイルを作成するために [Pandoc](https://pandoc.org/) を使用しています。あらかじめインストールしておいてください。

```
ruby learning-Ruby-with-Ruby.rb
```

*   スクリプトを実行すると EPUB ファイル`learning-Ruby-with-Ruby.epub`が作成されます。
*   ファイルを閲覧するには EPUB リーダーを使用します。
    *   [EPUBReader – Firefox用の EPUB リーダーアドオン](https://addons.mozilla.org/ja/firefox/addon/epubreader/)

# My environment

Windows 10 64bit, Ruby 2.5.3, pandoc 2.2.1, mechanize (2.7.6)

## Note
Windows環境では、machineizeでnet-http-persistent-3.0.0を使用すると「uninitialized constant Process::RLIMIT_NOFILE (NameError)」エラーが発生しました。
いまのところ（Mar 4, 2019）このパッチ
*   [Sets a default pool size for Windows as Process::RLIMIT_NOFILE is not supported #90](https://github.com/drbrain/net-http-persistent/pull/90/files)

を使用して解決できています。



# License

MIT

# Caution

「Rubyで学ぶRuby」のコンテンツの著作権は、株式会社角川アスキー総合研究所またはコンテンツの著作権者が保有しています。作成した EPUB ファイルの取り扱いは十分に注意してください。

参考： [ASCII.jp サイトポリシー](https://ascii.jp/info/site_policy.html)