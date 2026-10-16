# 项目文档

## 当前项目结论（2026-10-16）

- [尖叫蛙与 SEOnaut 能力差距](SCREAMING_FROG_GAP_ANALYSIS.md)：基于本机 Screaming Frog 19.3 的 REA 检查及当前源码审计，记录 23 项差距、已有功能、证据和二次开发建议。
- [运行架构、拆分方案与容量建议](ARCHITECTURE_AND_CAPACITY.md)：记录 Go 服务端渲染模式、本机两套容器环境、前后端及 Worker 拆分方式、2 核 2GB 的保守并发建议和压测边界。
- [容器开发指南](DEVELOPMENT.md)：本机编辑源码，容器内运行 Go、Air、esbuild 和 MySQL；包含启动、构建、测试、配置及数据卷说明。

能力结论对应文档中的版本和源码基线；容量建议尚未经过 2 核 2GB 实机压测。文档中的未来改造项不代表已经实现。

## 其他文档

- [安装与部署](INSTALL.md)
- [参与贡献](CONTRIBUTING.md)
- [翻译指南](TRANSLATIONS.md)
- [行为准则](CODE_OF_CONDUCT.md)
