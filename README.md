# KanjiToHiragana-iOS

### 環境
~~~
$ xcodebuild -version
Xcode 10.3
Build version 10G8

$ swiftlint version
0.34.0
~~~

### ビルドの前に
keys.plistを作ってkey:goo_idに対してgooで取得したYOUR_APPLICATION_IDを設定してください。
~~~
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>goo_id</key>
	<string>YOUR_APPLICATION_ID</string>
</dict>
</plist>
~~~