#!/bin/sh
# sudo gem install jazzy
version=1.1.2
sudo gem install jazzy
jazzy \
      --clean \
      --author ApolloZhu \
      --author_url https://apollozhu.github.io \
      --github_url https://github.com/ApolloZhu/swift_qrcodejs \
      --github-file-prefix https://github.com/ApolloZhu/swift_qrcodejs/tree/${version} \
      --module-version ${version} \
      --xcodebuild-arguments -target,swift_qrcodejs \
      --module swift_qrcodejs \
      --root-url https://apollozhu.github.io/swift_qrcodejs/ \
      --dash_url https://apollozhu.github.io/swift_qrcodejs/docsets/Srt2BilibiliKit.xml
