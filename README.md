# SimpleMemo · 简记

课程备忘录应用，共六个独立页面：登录、列表、新建、详情、编辑、设置。

演示登录：admin / 123456。数据保存在应用私有目录。仅供课程演示。

## 已完成的构建

2026-10-15 北京时间 16:43，GitHub Actions 已完成 ArkTS 编译和 HAP 打包。

- 构建提交：`1b04288648f719b7ac5055ce2d37e8ccfbf6875f`
- [构建记录](https://github.com/w0549859-byte/super-duper-octo-tribble/actions/runs/38707404171)
- 编译日志：`CompileArkTS`、`PackageHap`、`assembleHap` 完成，`BUILD SUCCESSFUL`。
- 产物：`entry-default-unsigned.hap`，248,880 字节。
- HAP SHA256：`0757b88e223e41209a77795e30bcae6b14020322840314b7aff842e8494f9c98`
- 已检查压缩包完整性、编译后的 `ets/modules.abc` 及六个页面注册信息。
- GitHub 构建产物 ZIP 的 SHA256 与下载文件一致。

## 页面及交互

| 页面 | 已实现的交互 |
| --- | --- |
| 登录 Index | 用户名与密码输入、错误提示、登录成功跳转 |
| 列表 Home | 搜索标题/内容、进入新建页、点选记录进入详情、进入设置 |
| 新建 Add | 输入标题和内容、选择分类、校验标题、保存并返回列表 |
| 详情 Detail | 查看记录、进入编辑页、确认后删除、返回 |
| 编辑 Edit | 回填原记录、修改标题/内容/分类、保存并返回 |
| 设置 Settings | 使用说明、返回、确认退出后跳转登录页 |

记录通过文件写入应用私有目录。写入临时文件并校验后再替换已有数据。

以上交互已在源码中核对，且相关页面已通过编译；目前尚未完成设备上的点击、安装和运行验证。

## 构建方法

已实际跑通的工作流是 `.github/workflows/build-hap-prebuilt.yml`：
使用预构建 HarmonyOS CLI 容器，安装依赖并调用 `hvigorw assembleHap`，
上传 `SimpleMemo-unsigned-HAP`。工作流支持手动触发，并会在相关源码改动后运行。

另一个 `build-hap.yml` 是需要提供官方 CLI 下载地址和校验值的备用工作流，
不代表它已单独验证。

当前 SDK 配置：

- compileSdkVersion：26.0.0.105（来自已生成 HAP）
- targetSdkVersion：26.0.0 / API 26
- compatibleSdkVersion：6.1.1 / API 24
- runtimeOS：HarmonyOS

也可使用匹配 SDK 的 DevEco Studio 打开本工程、同步依赖并构建 HAP。
单纯编译不需要启动模拟器或开启 Hyper-V。

## 签名与真机运行：尚未完成

当前产物是**未签名调试包**，不可视为已通过真机安装运行验证。

完成调试签名还需要：

1. 确定目标鸿蒙设备及其系统版本、UDID。
2. 获取与本项目密钥匹配的华为调试证书（.cer）。
3. 获取包含本应用包名 `com.wangyanxin.simplememo`、证书和目标设备的调试 Profile（.p7b）。
4. 签名后通过开发工具安装，并验证登录、新建、搜索、编辑、删除及重启后数据保留。

密钥库、密码、签名 Profile 等私密资料不应放入公开仓库。
