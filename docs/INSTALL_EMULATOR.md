# Windows 鸿蒙模拟器：最省事的安装路线

本项目已经通过 GitHub Actions 构建出 `entry-default-unsigned.hap`。若目标是学校作业中的“可以运行和演示”，推荐先使用 **DevEco Studio 的 HarmonyOS 手机模拟器**，不依赖鸿蒙真机签名证书，也不需要把私钥放到 GitHub。

## 安装

1. 在 Windows 10/11 电脑安装华为官方 **DevEco Studio**，在 `Tools > Device Manager` 中下载/创建并启动 HarmonyOS 手机模拟器。
2. 下载 GitHub Actions 最新成功运行中的 `SimpleMemo-unsigned-HAP` 产物，解压后取 `entry-default-unsigned.hap`。
3. 将 HAP 与 `scripts/install-emulator.ps1` 放在同一文件夹；在此文件夹打开 PowerShell，运行：
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File .\install-emulator.ps1
   ```
   脚本会寻找本机 `hdc.exe`，检查模拟器连接，尝试安装 HAP 和启动 `com.wangyanxin.simplememo` 的 `EntryAbility`。
4. 使用演示账号 `admin` / `123456`。验证六个页面：登录、列表、新建、详情、编辑、设置，以及保存、搜索、删除和重启后数据保留。

注意：**模拟器安装不等于真机签名完成**。现有 HAP 未签名，不能保证安装到 HarmonyOS 真机，也无法安装在普通 Android 手机上。实机签名仍需要华为合法调试证书与包含目标设备的 Profile，并且需要相应的设备/账号授权。当前尚未执行真实模拟器安装操作。

参考：[鸿蒙开发入门](https://developer.huawei.com/consumer/cn/develop-novice-guide/) · [创建模拟器](https://developer.huawei.com/consumer/cn/doc/HarmonyOS-Guides/ide-emulator-create)。
