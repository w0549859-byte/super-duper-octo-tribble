# SimpleMemo · 简记

六个独立页面的本地鸿蒙备忘录：登录、列表、新建、详情、编辑、设置。

演示登录：admin / 123456。数据保存在应用私有目录。仅供课程演示。

## 当前交付状态

- 已根据用户上传的完整 DevEco 工程整理源码与资源。
- 保留 targetSdkVersion 26.0.0、compatibleSdkVersion 6.1.1(24)、modelVersion 26.0.0。
- 已移除无对应证书的 default 签名引用，按未签名构建准备。
- 已排除本机路径、IDE 状态、依赖与构建缓存。
- 已准备 GitHub Actions 手动构建模板，但未在 Actions 执行验证。
- 尚未生成 HAP，也未完成鸿蒙编译或真机验证。

## 云端构建前置条件

1. GitHub 集成需要对该仓库具有实际 Contents 写入权限；提交工作流还需要对应的 Workflows 权限。
2. 从华为官方下载页获取与本项目 26.0.0 配套的 Linux x64 Command Line Tools ZIP 下载地址及 SHA256。
   https://developer.huawei.com/consumer/cn/download/command-line-tools-for-hmos
3. 工作流只支持手动触发，以免在工具链未配置时重复运行。输入 cli_url 和 cli_sha256 后执行。
4. scripts/setup-ci.sh 尝试识别工具包内的 Node、Java、ohpm、hvigorw 与 SDK。
   如果工具包目录结构不同或不含上述组件，脚本会明确停止，需要根据实际工具包调整。
5. 成功后从 Actions 下载 SimpleMemo-unsigned-HAP。未签名 HAP 不能直接作为真机可安装包。

## 本地构建

使用匹配 SDK 的 DevEco Studio 打开本目录，完成依赖同步，执行构建 HAP。
编译不需要启动模拟器或开启 Hyper-V；安装运行另需适当签名和设备。

## 检查范围

当前完成工程结构、页面注册、相对代码引用与配置静态检查。
核心逻辑曾通过 Node 环境测试，但不能代替华为 ArkTS 编译器检查。
