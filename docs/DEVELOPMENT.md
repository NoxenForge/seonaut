# 容器开发环境

[返回文档目录](README.md) · [运行架构与容量建议](ARCHITECTURE_AND_CAPACITY.md)

源码在本机编辑，Go、Air、Node.js、esbuild 和 MySQL 均运行在容器中。
支持 Podman Compose 或 Docker Compose，本机无需安装这些语言工具和数据库。

## 启动

在仓库根目录运行：

```sh
./dev.sh up
./dev.sh logs
```

`up` 会使用新镜像重建开发容器，数据库和缓存卷保留；已有抓取会中断。
默认访问 http://localhost:9001/signup 创建账号。首次构建需要下载工具和 Go 依赖，
看到 `Starting server` 后即可访问。`Ctrl+C` 只退出日志，不会停止服务。

独立的 Compose 项目名为 `seonaut-dev`，不会使用已有的 `seonaut-local` 容器和数据卷。

## 修改代码

- 修改 Go、HTML 模板、翻译 YAML 或 `config.local`：Air 每秒检查文件变化，自动重新编译和启动。
- 修改 CSS：esbuild 自动重新构建，刷新浏览器查看结果。
- 修改工具版本或 `dev/Containerfile`：重新执行 `./dev.sh up`。
- 模板和 CSS 更新后需要刷新页面，不会自动刷新浏览器。
- Go 重启会中断正在进行的抓取，开发时请等待构建完成后再开始抓取。

## 常用命令

```sh
./dev.sh build          # 构建 CSS 和 Linux 可执行文件 build/release/seonaut
./dev.sh test           # 运行现有 Go 测试，带 race 检测
./dev.sh go version     # 查看容器中的 Go 版本
./dev.sh restart        # 手动重新启动后端
./dev.sh ps             # 查看状态
./dev.sh stop           # 停止服务
./dev.sh down           # 移除容器，保留数据库和构建缓存
```

构建出的可执行文件用于 Linux 容器，不能直接在 macOS 中执行。

## 数据库和配置

- 容器内连接：`db:3306`，数据库和用户名均为 `seonaut`。
- 本机数据库客户端连接：`127.0.0.1:13306`。
- 随机生成的数据库密码保存在 `.env` 的 `SEONAUT_DEV_DB_PASSWORD` 中。
- 应用连接配置保存在 `config.local`，初始化时与 `.env` 同步生成。
- `.env` 和 `config.local` 已被仓库忽略，不要提交其中的密码。
- 数据保存在命名卷中，常规停止和 `down` 都保留数据。不要使用 `down -v`，否则会删除开发数据库。
- 修改 `.env` 中的端口时，同时调整 `config.local` 的应用 URL；应用容器内部端口仍为 `9000`。
- 数据库初始化后的密码保存在数据库中，不能只修改 `.env`；如需改密，应同时修改数据库账户和本地配置。

`./dev.sh db` 可以直接进入容器内的 MySQL 命令行。
