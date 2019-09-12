# KanjiToHiragana-iOS

### 環境
~~~
$ xcodebuild -version
Xcode 10.3
Build version 10G8

$ swiftlint version
0.34.0

$ carthage version
0.33.0
~~~

### ビルド
key.plistにGooAPIのAPIkeyが入っていますがgitignoreしているので、手動で作成するか以下のコマンドでYOUR_GOO_API_KEYをセットしてください
~~~
# envsubstがないって言われる場合は事前に以下のコマンドでlinkしておいてください
# brew link --force gettext

goo=YOUR_GOO_API_KEY envsubst < plist-template.txt > StringToHiraganaiOS/key.plist
~~~
