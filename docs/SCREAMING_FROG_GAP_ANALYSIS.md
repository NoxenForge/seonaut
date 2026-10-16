# 本机 Screaming Frog 与当前 SEOnaut 的能力差距

检查日期：2026-10-16。

[返回文档目录](README.md) · [运行架构与容量建议](ARCHITECTURE_AND_CAPACITY.md)

## 比较对象与证据范围

- 本机应用：`/Applications/Screaming Frog SEO Spider.app`，版本 **19.3.0**。实际窗口显示 `Screaming Frog SEO Spider 19.3 (Licensed)`。
- 当前项目：`/Users/dawson/workspace/seonaut`，HEAD 为 `a67387fe63a291be2ba49dd02399f20e453eb8b5`。
- 方法：使用 **REA** 检查、清点并解包本机应用的主 JAR，核对英文界面资源、相关类文件及实际应用界面；同时检查 SEOnaut 的抓取客户端、解析器、项目配置、报告模型、问题规则、历史数据处理、路由与导出实现。
- “缺少”表示在本次检查的当前源码与产品入口中未发现相应实现；“部分支持”表示已有基础能力，但缺少对应高级配置或工作流。
- 本报告是安装包、界面与源码层面的能力审计。**没有逐项实际抓站，没有连接第三方 API，也没有验证这些旧版 API 集成在今天是否仍可用。** 不把更新版本的 Screaming Frog 功能计入本机 19.3。

## 能力清单

以下共列出 **23 项差距：19 项缺少，4 项部分支持**。拆项是为了便于后续分模块评估，不能据此量化两个产品的整体完成度。

| # | 能力 | 本机 Screaming Frog 19.3 的证据 | 当前 SEOnaut 的差距 | 状态 |
|---|---|---|---|---|
| 1 | JavaScript 渲染抓取 | Rendering 配置明确使用 headless Chrome，支持 React、Vue 等依赖 JS 的页面 | 使用普通 HTTP 请求并直接解析响应 HTML，无法获得浏览器执行 JS 后才出现的正文和链接 | 缺少 |
| 2 | 渲染前后 SEO 信息比较 | 有渲染后的标题、描述、H1、Canonical 等字段及差异规则 | 没有原始 HTML 与渲染后 DOM 两套结果，难以发现 JS 改写 SEO 标签的问题 | 缺少 |
| 3 | 页面截图与 JS 控制台诊断 | 有 Rendered Page 截图、JavaScript Error Reporting、Chrome Console Log | 没有截图及页面 JS 错误、警告日志 | 缺少 |
| 4 | 用户自定义字段提取 | Custom Extraction 支持 XPath、CSS Path、正则 | XPath 仅用于内置字段解析，用户不能配置规则提取价格、作者、产品 ID 等业务字段 | 缺少 |
| 5 | 全站自定义内容搜索 | Custom Search 可搜索 HTML 源码、正文、Head、Body，也支持正则等条件 | URL Explorer 搜索针对 URL 字段，没有全站正文或源码的自定义匹配功能 | 缺少 |
| 6 | 结构化数据及富结果校验 | Structured Data、结构化数据验证类、Google Rich Results 报告 | 没有 JSON-LD、Microdata、RDFa 的专用提取和 Schema 校验链路 | 缺少 |
| 7 | 近似重复内容分析 | 有相似度阈值、Closest Similarity Match、No. Near Duplicates | 只有整段 HTML 的 SHA256 精确重复检查，不能识别内容略有不同的近似页面 | 缺少 |
| 8 | 拼写和语法检查 | 有 Spelling & Grammar Details、错误数量及导出 | 没有对应内容质量规则；不同语言的效果需另行验证 | 缺少 |
| 9 | 文本可读性评分 | 有 Flesch Reading Ease Score、Readability 配置和列 | 没有专门的可读性评分；该类英文指标对中文的适用性需单独设计 | 缺少 |
| 10 | GA4 / Search Console 数据结合 | 有 GA4、GSC 集成及 URL Inspection 富结果字段 | 无对应配置、数据模型及同步流程，不能将流量、搜索表现和索引检查结果与扫描页面关联 | 缺少 |
| 11 | PageSpeed 性能诊断 | 有 PageSpeed API 及 LCP、CLS、TBT 等指标类 | 已记录 TTFB，但没有 PageSpeed 接入及完整页面性能诊断 | 缺少 |
| 12 | 第三方链接指标 | 有 Ahrefs、Majestic、Mozscape API 配置与 Link Metrics | 无对应集成，不能直接给抓取 URL 补充这些外部链接指标 | 缺少 |
| 13 | 两轮扫描逐 URL 对比 | Compare 模式 | 已有最近 5 次扫描的汇总趋势，但上一轮页面、链接和问题明细会被删除，没有逐 URL 的新增、删除、状态或标签变化对比 | 缺少 |
| 14 | 内置定时扫描 | File → Scheduling，且认证配置可供计划任务使用 | 目前由 Web 页面触发抓取，没有内置周期任务、任务计划及执行记录工作流 | 缺少 |
| 15 | 无界面 CLI 扫描与自动导出 | CLI 支持 headless、列表扫描、保存扫描、批量导出和报告 | 命令入口用于启动 Web 服务；没有对应的抓取 CLI 和抓完自动导出工作流 | 缺少 |
| 16 | 暂停续扫与保存扫描会话 | 有 Pause / Resume、加载及保存 crawl；资源说明支持加载后续扫 | 有停止功能和数据库报告，但队列在内存中，启动时清理未完成任务，不能暂停后继续或重启恢复队列 | 缺少 |
| 17 | 任意 URL 列表批量扫描 | List 模式及 CLI crawl-list | 项目以一个起始 URL 建立，没有任意 URL 清单上传入口；已有 Sitemap 发现不等同于列表扫描 | 缺少 |
| 18 | 站点链接关系图 | 力导向图、抓取树、目录树及 3D 视图 | 有入链/出链明细、深度等汇总图，没有以 URL 为节点的站点关系图 | 缺少 |
| 19 | 站内链接权重评分 | 有 Link Score 字段 | 有链接明细，没有站内相对权重评分 | 缺少 |
| 20 | 精细抓取范围配置 | 有抓取深度、每层 URL 数、目录深度、查询参数数等限制；支持自定义 robots | 已有子域、robots、nofollow、noindex、Sitemap 等开关；缺少 Include/Exclude 正则、自定义 robots 内容及可配置深度截断 | 部分支持 |
| 21 | 用户配置扫描资源限制 | 有总 URL 数、重定向次数等限制选项及抓取配置 | 并发数 2、随机延时上限 1500ms、总时长 2h、页面报告上限 20000、HTTP 超时 10s 均在代码中固定，缺少项目级配置入口 | 部分支持 |
| 22 | 登录态及请求环境配置 | 有 Basic/Digest、表单登录、Cookie 存储、自定义请求头及代理配置 | 已有 BasicAuth 和自定义 UA；缺少目标站表单登录、Cookie 注入/保持、任意请求头和项目级代理配置 | 部分支持 |
| 23 | 更多导出及协作格式 | 有 Excel 格式、Google Sheets 导出入口、图片 Sitemap | 已有丰富 CSV、普通 Sitemap 和 WACZ；缺少原生 XLSX、Google Sheets 集成及图片 Sitemap | 部分支持 |

### 容易误判的几个点

- **精确重复检查已经存在。** 差距是近似重复检测；当前整段 HTML 哈希也不等同于正文语义去重。
- **历史汇总趋势已经存在。** 差距是保留多轮 URL 明细并做变化对比。
- **BasicAuth 和 User-Agent 配置已经存在。** 差距主要在表单登录、Cookie、请求头等。项目使用 Go 默认 HTTP Transport，环境变量代理可能生效，因此不能说“完全不支持代理”；本次未测试代理行为。
- **CSV 导出已经比较丰富。** 包括内外链、图片、脚本、CSS、iframe、音视频、hreflang、问题等，不能笼统说“报告无法导出”。CSV 可由 Excel 打开，但不等于原生 XLSX。
- **停止扫描、MySQL 报告和 WACZ 存档已经存在。** 这些不等同于保存可恢复的待抓队列或暂停续扫。
- **标题、描述、Canonical、hreflang、孤立页、内外链、重定向、robots、noindex/nofollow 等基础审计已经存在。** 不应重复列为缺失。
- 本机资源证明存在 CLI，不据此推断 Screaming Frog 有可对外调用的 HTTP API；也没有把未核实的通知功能列进差距。

## 二次开发建议

如果目标是把 SEOnaut 做成可长期部署的 SEO 巡检服务，建议按以下顺序推进，而不是一次性对齐全部桌面功能。

1. **先补扫描控制与历史数据基础。** 将并发、延时、数量、深度和 Include/Exclude 做成项目配置；调整上一轮明细删除策略。否则后续定时扫描和变化对比缺少稳定的数据基础。
2. **再补定时任务、历史对比和列表扫描。** 形成“按计划扫描 → 保存多轮结果 → 标出新增/修复问题”的服务流程。扫描自动导出可放在这一阶段。
3. **按目标站技术选型补 JS 渲染。** 若主要扫描 React/Vue 客户端渲染站点，应提前到第一阶段；可用独立 Chromium 容器提供渲染，但需设计并发、超时、资源占用及登录态传递。
4. **补自定义提取、结构化数据和近似重复。** 这几项能明显扩大业务适用范围；自定义字段可用于商品、文章等专项巡检。
5. **最后补外部 API、图形化和协作导出。** GA4/GSC/PageSpeed 要考虑授权和配额；Ahrefs/Majestic/Moz 通常还涉及账户与 API 权限。关系图、Link Score、XLSX 和 Sheets 可按实际需求安排。

上述为开发排序建议，未修改业务代码，也未进行工期估算。

## SEOnaut 源码依据

以下位置均相对于仓库根目录，来自本次核对时的工作区；后续代码变化可能导致行号移动。

| 对应条目 | 源码位置与判断依据 |
|---|---|
| 1–3 | `internal/crawler/basic_client.go:44` 普通 HTTP 请求；`internal/services/html_parser.go:47` 解析响应体；`internal/services/parser.go:42` HTML 解析选项。存档回放脚本不构成浏览器渲染抓取。 |
| 4–5 | `internal/services/parser.go:123`、`:136` 内置 XPath；`internal/repository/pagereport.go:853` URL 字段全文搜索。 |
| 6、8–9 | `internal/models/pagereport.go:7` 页面报告字段；`internal/services/html_parser.go:79` 内置解析流程；`internal/issues/page/reporters.go:6` 页面规则注册。检查范围内无对应专用解析、模型和规则。 |
| 7 | `internal/services/html_parser.go:116`、`:169` HTML 哈希；`internal/issues/multipage/body.go:10` 根据 body_hash 分组。 |
| 10–12 | `internal/models/project.go:7` 项目配置；`internal/config/config.go:38` 服务配置；`internal/routes/app.go:23` 路由；`internal/crawler/basic_client.go:88` 已有 TTFB。 |
| 13 | `internal/services/crawler.go:19`、`:143` 最近 5 次汇总；`:88`、`:98` 获取并在任务退出时清理上一轮明细；`internal/repository/crawl.go:186` 起删除各明细表数据；`web/templates/charts/crawls_timeline.html:45` 汇总趋势。 |
| 14–15 | `cmd/server/main.go:11` 服务入口；`internal/routes/app.go:32`、`:47` Web 抓取及导出路由。没有发现内置调度或独立抓取 CLI。 |
| 16 | `internal/services/crawler.go:154` StopCrawler；`internal/crawler/crawler.go:226` 取消上下文；`internal/crawler/queue.go:38` 内存队列；`internal/services/container.go:112` 清理未完成任务；`internal/repository/crawl.go:230` 起清理实现；`internal/services/archive.go:34` 已有存档。 |
| 17 | `web/templates/project_add.html:20` 单起始 URL；`internal/models/project.go:7`；`internal/services/crawler.go:115` 起始请求入队。 |
| 18–19 | `internal/services/report.go:56` 入链/出链；`internal/services/dashboard.go:62` 汇总图表。 |
| 20–21 | `internal/models/project.go:11` 已有开关；`internal/crawler/robots_checker.go:74` 目标 robots；`internal/crawler/crawler.go:21` 起固定限制、`:183` 入队判断；`internal/services/crawler.go:18`、`:178` 页数及超时常量；`internal/services/crawler_handler.go:67` 记录深度。 |
| 22 | `internal/crawler/basic_client.go:23` 请求配置、`:54` BasicAuth；`internal/routes/crawl.go:165`；`web/templates/project_edit.html:174`；`internal/services/crawler.go:189` HTTP 客户端没有设置 CookieJar 或项目代理。 |
| 23 | `internal/routes/app.go:49` 导出路由；`internal/routes/export.go:122` 普通 Sitemap、`:156` 起 CSV 导出选项。 |

负面结论综合检查了 `internal/`、`cmd/`、`web/templates/`、`migrations/`、`docs/`、`config`、`README.md`、`go.mod`，并非仅依据某个关键词没有命中。

## Screaming Frog 安装包依据

主 JAR：`/Applications/Screaming Frog SEO Spider.app/Contents/Java/ScreamingFrogSEOSpider.jar`。

SHA256：`15d5b55df8a16524b4868efea6c85371d0a0bb570e6de5dcaaeb31c522405a58`。

REA 清点：3438 个 JAR 条目。下表行号来自解包后的 `translations/SeoSpider_en.properties`，不是官网最新版本文档。

| 条目 | 资源位置 / 标识 |
|---|---|
| 1–3 | 1810–1839：Rendering、headless Chrome、JavaScript、截图、JS 日志；798–804 / 1502–1512：渲染后 SEO 字段；4585–4587：渲染前后 Canonical 差异。 |
| 4–5 | 2239–2264：Custom Search；2268–2270：XPath、CSS Path、regex Extraction。 |
| 6 | 517–521：Structured Data / Google Rich Results 报告；1101：Structured Data 页签；`structured/data/validation/StructuredDataValidationFeature.class`。 |
| 7–9 | 897–903、1414–1417：近似重复和拼写语法；2008：相似度阈值；1348–1349、1715–1716：可读性。 |
| 10–12 | 87–93：第三方 API CLI 配置；1468–1471：URL Inspection 富结果字段；PageSpeed JSON 模型含 LCP、CLS、TBT。 |
| 13–15 | 243–246：Compare / List 模式；220、2753 起：Scheduling；75、83、116–132：列表抓取、加载、保存、自动导出、headless。 |
| 16–19 | 397：加载后恢复说明；1573–1574：Pause/Resume；569–576：关系图；648 / 1408：Link Score。 |
| 20–22 | 1789–1804：抓取限制；2084–2085：自定义 robots；2225：自定义请求头；1874–1880：Cookie 存储；2678–2702：Basic/Digest、表单登录与认证配置；3015–3017：代理。 |
| 23 | 253–255：Excel 格式；559、130：图片 Sitemap；实际导出入口说明可导出到磁盘或 Google Sheets。 |

相关类文件还包括 `SpiderCustomExtractionConfig.class`、`SpiderStructuredDataConfig.class`、`SpiderPageSpeedConfig.class`、`PageRenderer.class`、`scheduler/Schedule.class` 和 `scheduler/history/ScheduleRun.class`。这些用于交叉印证安装包能力，不代表逐项执行测试。

### REA Evidence 标识

- 安装包检查：`ev_10117b349847a02f61f95cf69719a2bfecc95aef5b326d4441dd601f13cc65f2`
- 清点子证据：`ev_caebc9bd4ea29910de6649330d0006b415a7b828c660261a740a2e7e72511322`
- 解包：`ev_3a73f1b8a9b2d249d6debf0505c4510a4852bc954dd05eee3131c14677cbb9c5`
- Info.plist 版本及入口：`ev_65e61ba1fb01b0752f9a740a0b7752334508d274a2d4dd85197af2910ce4dbc6`
- 清点 manifest：`agm_1aba10435cc11f002e8edbcb181b7cb9632862fab949ae9208b15b3ceb4f514f`

完整 REA 证据包保存在本次聊天工作目录的 `work/research/rea-screaming-frog-evidence.json`。完整证据包未纳入仓库；本报告保留版本、关键资源行号和 Evidence 标识以便核查。本次仅补充项目文档，未修改应用实现，也没有 commit 或 push。
