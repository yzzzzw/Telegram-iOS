# Fork Telegram-iOS项目，基于Telegram-iOS做二次开发 Telegram address: https://github.com/TelegramMessenger/Telegram-iOS

# Compilation Guide

1. Install Xcode (directly from https://developer.apple.com/download/more or using the App Store).
2. Clone the project from GitHub:

```
git clone --recursive -j8 https://github.com/yzzzzw/Telegram-iOS.git
```

3. Download Bazel 4.0.0

```
mkdir -p $HOME/bazel-dist
cd $HOME/bazel-dist
curl -O -L https://github.com/bazelbuild/bazel/releases/download/4.0.0/bazel-4.0.0-darwin-x86_64
mv bazel-* bazel
```

Verify that it's working

```
chmod +x bazel
./bazel --version
```

4. Adjust configuration parameters 这是将build-system/example-configuration/拷贝到$HOME/telegram-configuration/下，-R表示拷贝包括文件夹，如果python指令地址是build-system/example-configuration/则忽略下面的命令

```
mkdir -p $HOME/telegram-configuration
cp -R build-system/example-configuration/* $HOME/telegram-configuration/
```

- Modify the values in `variables.bzl`
- Replace the provisioning profiles in `provisioning` with valid files

5. (Optional) Create a build cache directory to speed up rebuilds

```
mkdir -p "$HOME/telegram-bazel-cache"
```

5. Build the app 编译

```
python3 build-system/Make/Make.py \
    --bazel="$HOME/bazel-dist/bazel" \
    --cacheDir="$HOME/telegram-bazel-cache" \
    build \
    --configurationPath="$HOME/telegram-configuration" \
    --buildNumber=100001 \
    --configuration=release_universal
```

6. (Optional) Generate an Xcode project 创建xcodeproject文件，一般只执行这个创建工程项目，之后直接打开

```
python3 build-system/Make/Make.py \
    --bazel="$HOME/bazel-dist/bazel" \
    --cacheDir="$HOME/telegram-bazel-cache" \
    generateProject \
    --configurationPath="$HOME/telegram-configuration" \
    --disableExtensions
    
python3 build-system/Make/Make.py \
    --bazel="$HOME/bazel-dist/bazel" \
    --cacheDir="$HOME/telegram-bazel-cache" \
    generateProject \
    --configurationPath="build-system/example-configuration" \
    --disableExtensions
```

It is possible to generate a project that does not require any codesigning certificates to be installed: add `--disableProvisioningProfiles` flag:
```
python3 build-system/Make/Make.py \
    --bazel="$HOME/bazel-dist/bazel" \
    --cacheDir="$HOME/telegram-bazel-cache" \
    generateProject \
    --configurationPath="$HOME/telegram-configuration" \
    --disableExtensions \
    --disableProvisioningProfiles
```


Tip: use `--disableExtensions` when developing to speed up development by not building application extensions and the WatchOS app.


# Tips

Bazel is used to build the app. To simplify the development setup a helper script is provided (`build-system/Make/Make.py`). See help:

```
python3 build-system/Make/Make.py --help
python3 build-system/Make/Make.py build --help
python3 build-system/Make/Make.py generateProject --help
```

Each release is built using specific Xcode and Bazel versions (see `versions.json`). The helper script checks the versions of installed software and reports an error if they don't match the ones specified in `versions.json`. There are flags that allow to bypass these checks:

```
python3 build-system/Make/Make.py --overrideBazelVersion build ... # Don't check the version of Bazel
python3 build-system/Make/Make.py --overrideXcodeVersion build ... # Don't check the version of Xcode
```
