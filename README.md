# The-Earthquake-Early-Warning-EEW-System
This is the project of the **Interface Design Methodology** course. Here we will develop a EEW system by flutter, in order to run in Android phones.

## 日常使用：

在桌面打开cmd，运行终端（运行完不要关闭，会自动跳出模拟器）：

```
flutter emulators --launch Pixel8Pro
```

cd至project文件所在处，在终端中打开，运行下面的命令行：

```
flutter run
```

即可。

如果要更改依赖，refer to "pubspec.yaml"文件中的dependencies，添加或删去依赖，并运行下面的命令：

```
flutter clean
flutter pub get
flutter run
```

Here are some official reminders:

### Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev/), which offers tutorials.



## For 第一次安装：

注意：仅针对打算全程在vscode上运行的人群。

### Some Explanation:

The environment is based on Flutter (with Dart), the whole process is finished in VS Code. Because I don't want to download an extra "Android Studio". If you want to implement it more conveniently, please refer to online guidelines to install **Android Studio**.

There are two things in need if we only want to use VS Code to run this program. First is we have to set proper **Flutter ** environment. The second is that we have to run an Android Simulator to display the results.

#### 1. Flutter Environment

Refer to online guidelines, first download the Flutter packages, edit the system environment variables. In all, you need to install the Flutter.

Run:

```
flutter --version
```

or

```
flutter doctor
```

to see if all dependencies are ready.

有些红色报错可以不必理会，因为那些功能可能用不上。主要需要的功能就三个，一个是Java环境，一个是Flutter，一个是Simulator。

Normally, you will have to install Java JDK, refer to https://www.oracle.com/java/technologies/downloads, install and add the jdk file to the system environment variables:

```
JAVA_HOME = C:\Program Files\Java\jdk-11.x.x
add `%JAVA_HOME%\bin` to `Path`
```

Then, run：

```
java -version
```

to check the Java environment.

**注意：**Java JDK版本如果过于新的话可能与flutter不能兼容，这个时候需要重装更旧版本的java jdk。



#### 2. Android Simulator

Refer to [下载 Android Studio 和应用工具 - Android 开发者  | Android Developers](https://developer.android.google.cn/studio?hl=zh-cn#downloads)

在页面下方找到 `Command line tools only`，下载适合你系统的版本（Windows ZIP）

假设你放在 `D:\Android\` 目录下：

```
D:\Android\cmdline-tools\latest\
                                ├── bin
                                ├── lib
                                └── ...
```

注意：必须重命名为 `latest`，结构要像上面那样。

在系统环境变量中添加以下项：

| 变量名         | 值                                                   |
| -------------- | ---------------------------------------------------- |
| `ANDROID_HOME` | `D:\Android`                                         |
| `Path` 添加    | `D:\Android\cmdline-tools\latest\bin`                |
| `Path` 添加    | `D:\Android\platform-tools`（后面安装完 SDK 后会有） |

打开 PowerShell，执行以下命令（请先 `cd` 到 `latest\bin` 路径下）：

```
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2" "cmdline-tools;latest"
```

之后运行：

```
flutter doctor --android-licenses
```

全都输入 `y` 接受即可。

---



然后需要把 `emulator` 命令加入环境变量，否则它会找不到 Android 模拟器的启动程序。你需要找到 Android SDK 路径，打开 CMD 或 PowerShell，输入：

```
echo %ANDROID_HOME%
```

或者手动去找：

```
C:\Users\你的用户名\AppData\Local\Android\Sdk
```

复制 emulator 文件夹路径，比如：

```
C:\Users\Administrator\AppData\Local\Android\Sdk\emulator
```

添加到环境变量：在“系统变量”下，找到 `Path`，点击“编辑”，新增一行，把刚才复制的 `emulator` 路径粘贴进去，点击“确定”保存。

---



接着进入之前下载的 `cmdline-tools` 目录并运行以下命令来确保你有正确的工具

```
cd %ANDROID_HOME%\cmdline-tools\latest\bin
```

安装并更新模拟器和系统映像：

```
sdkmanager --update
sdkmanager "system-images;android-33;google_apis;x86_64"
sdkmanager "platform-tools" "emulator" "build-tools;33.0.0"
```

列出可用的设备模板：进入 `cmdline-tools` 目录并运行以下命令，它会列出你可以选择的设备模板，选择一个你喜欢的设备：

```
cd %ANDROID_HOME%\cmdline-tools\latest\bin
avdmanager list device
```

使用下面的命令来创建一个新的虚拟设备。

创建 Pixel 8 Pro 虚拟机： 首先，你需要确保已经下载了适合 `Pixel 8 Pro` 的系统镜像。

使用 `android-33` 来创建虚拟设备，这个命令会创建一个名为 `Pixel8Pro` 的模拟器。：（最新为android-34）

```
avdmanager create avd -n Pixel8Pro -k "system-images;android-33;google_apis;x86_64" -d pixel_8_pro
```

使用以下 `emulator` 命令启动模拟器`Pixel8Pro`：

```
emulator -avd Pixel8Pro
```

这会启动你刚刚创建的 `Pixel8Pro` 模拟器。注意，如果是比较老旧的机型，可以删除设备，安装更新的机型以提高屏幕大小和分辨率。比如删除 Pixel 4的命令：

```
avdmanager delete avd -n Pixel4
```

---

如果你使用 Flutter 来启动模拟器：

```
flutter emulators --launch Pixel8Pro
```

输入：

```
flutter devices
```

以查看现在可用的设备列表。

你应该会看到一个类似这样的输出：

```
2 connected devices:
emulator-5554 • Pixel_4_API_33 • android-x86 • Android 13 (API 33)
```



#### 3. 在 VS Code 中运行 Flutter 项目

去到Flutter 项目的目录，在该目录里打开终端，并运行下面的命令行：

```
flutter clean
flutter pub get
flutter run
```

注意可能有以下提示：

> **Please enable Developer Mode in your system settings.**
>  Run
>  `start ms-settings:developers`
>  to open settings.

这是因为在 Windows 上启用 symlink（符号链接）支持，Flutter 构建需要 **启用开发者模式（Developer Mode）**。

1. Win + R 打开运行窗口
2. 输入：`ms-settings:developers`，回车
3. 勾选或切换到：**"开发者模式（Developer Mode）"

> ⚠️ Windows 会弹出提示说“启用开发者模式可能会带来安全风险”，点击“是”或“启用”就行。

最后在项目目录里再次运行：

```
flutter run
```

即可。

注意：在运行flutter之前，应该先将安卓模拟器打开到手机显示主界面，稍后运行了``flutter run``，program就会自动出现在手机上。

如有其他未知的报错，please refer to ChatGPT or DeepSeek for more help!!

当然，如果直接使用Android Studio，可能会更简单一些，但是对于不想额外下载的人，这个教程也不算复杂。





By Tyke, 2025.04.25

Updated 2025.04.30
