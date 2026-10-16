#!/bin/sh
set -eu

cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

if command -v podman >/dev/null 2>&1; then
    engine=podman
elif command -v docker >/dev/null 2>&1; then
    engine=docker
else
    echo "请先安装并启动 Podman 或 Docker。" >&2
    exit 1
fi

compose() {
    "$engine" compose -p seonaut-dev -f compose.dev.yaml "$@"
}

init() {
    if [ ! -f .env ]; then
        umask 077
        db_password=$(od -An -N24 -tx1 /dev/urandom | tr -d ' \n')
        root_password=$(od -An -N24 -tx1 /dev/urandom | tr -d ' \n')
        cat > .env <<EOF
SEONAUT_DEV_PORT=9001
SEONAUT_DEV_DB_PORT=13306
SEONAUT_DEV_DB_PASSWORD=$db_password
SEONAUT_DEV_ROOT_PASSWORD=$root_password
EOF
    fi
    if [ ! -f config.local ]; then
        db_password=$(sed -n 's/^SEONAUT_DEV_DB_PASSWORD=//p' .env)
        app_port=$(sed -n 's/^SEONAUT_DEV_PORT=//p' .env)
        if [ -z "$db_password" ] || [ -z "$app_port" ]; then
            echo ".env 缺少数据库密码或应用端口，请检查。" >&2
            exit 1
        fi
        umask 077
        sed -e "s|http://localhost:9000|http://localhost:$app_port|" \
            -e "s|password = \"seonaut\"|password = \"$db_password\"|" \
            config > config.local
    fi
    echo "本地配置已就绪：.env、config.local（均不纳入 Git）。"
}

action=${1:-help}
if [ "$#" -gt 0 ]; then shift; fi

case "$action" in
    init) init ;;
    up)
        init
        compose build app
        compose up -d --force-recreate
        ;;
    down) compose down ;;
    stop) compose stop ;;
    restart) compose restart app ;;
    logs) compose logs -f --tail=80 app assets ;;
    ps) compose ps ;;
    build)
        compose run --rm --no-deps -T app sh -c \
            'make front && mkdir -p build/release && CGO_ENABLED=0 go build -o build/release/seonaut ./cmd/server'
        ;;
    test) compose run --rm --no-deps -T app go test -race ./internal/... "$@" ;;
    front) compose exec assets make front ;;
    go) compose exec -T app go "$@" ;;
    shell) compose exec app sh ;;
    db) compose exec db sh -c 'MYSQL_PWD="$MYSQL_PASSWORD" exec mysql -u"$MYSQL_USER" "$MYSQL_DATABASE"' ;;
    *)
        cat <<'EOF'
用法：./dev.sh <命令>
  init     生成本地配置和随机数据库密码
  up       构建开发镜像并启动数据库、后端和 CSS 监听
  stop     停止容器，保留容器和数据
  down     移除开发容器，保留数据库及 Go 缓存卷
  restart  重启后端
  logs     查看后端和 CSS 构建日志（Ctrl+C 退出日志）
  ps       查看容器状态
  build    构建 CSS 和 Linux 后端到 build/release/seonaut
  test     在容器中执行 Go 测试（开启 race 检测）
  front    手动构建 CSS
  go ...   在运行中的开发容器执行 Go 命令
  shell    进入开发容器
  db       进入开发数据库命令行
EOF
        ;;
esac
