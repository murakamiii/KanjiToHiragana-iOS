# KanjiToHiragana-iOS
![](https://github.com/murakamiii/KanjiToHiragana-iOS/workflows/CI/badge.svg)

### 環境
~~~
$ swift --version
Apple Swift version 5.0.1 (swiftlang-1001.0.82.4 clang-1001.0.46.5)
Target: x86_64-apple-darwin18.7.0

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

$ goo=YOUR_GOO_API_KEY envsubst < plist-template.txt > StringToHiraganaiOS/key.plist

$ cat StringToHiraganaiOS/key.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>goo_api</key>
        <string>YOUR_GOO_API_KEY</string>
</dict>
</plist>
~~~

Carthage/Buildsは入っていますが、Swift5.0.1でのBuildなので適宜carthage updateしてください
