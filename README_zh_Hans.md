<!--
注意：此 README 由 <https://github.com/YunoHost/apps/tree/master/tools/readme_generator> 自动生成
请勿手动编辑。
-->

# YunoHost 上的 Veloren server

[![集成程度](https://dash.yunohost.org/integration/veloren.svg)](https://dash.yunohost.org/appci/app/veloren) ![工作状态](https://ci-apps.yunohost.org/ci/badges/veloren.status.svg) ![维护状态](https://ci-apps.yunohost.org/ci/badges/veloren.maintain.svg)

[![使用 YunoHost 安装 Veloren server](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=veloren)

*[阅读此 README 的其它语言版本。](./ALL_README.md)*

> *通过此软件包，您可以在 YunoHost 服务器上快速、简单地安装 Veloren server。*  
> *如果您还没有 YunoHost，请参阅[指南](https://yunohost.org/install)了解如何安装它。*

## 概况



**分发版本：** 0.10.0~ynh1

**演示：** <server.veloren.net:14004>

## 截图

![Veloren server 的截图](./doc/screenshots/veloren.png)

## 免责声明 / 重要信息

Veloren is in pre-alpha, il y aura des bugs.

This package provides the last "release" version of Veloren, which is older than that of the official server. You will need to download the corresponding version of the client:
 * [Windows x64](https://gitlab.com/veloren/veloren/-/jobs/artifacts/v0.10.0/download?job=windows)
 * [Linux x64](https://gitlab.com/veloren/veloren/-/jobs/artifacts/v0.10.0/download?job=linux)
 * [MacOS x64](https://gitlab.com/veloren/veloren/-/jobs/artifacts/v0.10.0/download?job=macos)

## 文档与资源

- 官方应用网站： <https://veloren.net/>
- 官方用户文档： <https://book.veloren.net/players/>
- 官方管理文档： <https://book.veloren.net/players/hosting-a-server.html>
- 上游应用代码库： <https://gitlab.com/veloren/veloren>
- YunoHost 商店： <https://apps.yunohost.org/app/veloren>
- 报告 bug： <https://github.com/YunoHost-Apps/veloren_ynh/issues>

## 开发者信息

请向 [`testing` 分支](https://github.com/YunoHost-Apps/veloren_ynh/tree/testing) 发送拉取请求。

如要尝试 `testing` 分支，请这样操作：

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/veloren_ynh/tree/testing --debug
或
sudo yunohost app upgrade veloren -u https://github.com/YunoHost-Apps/veloren_ynh/tree/testing --debug
```

**有关应用打包的更多信息：** <https://yunohost.org/packaging_apps>
