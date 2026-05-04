---
name: obita-html-publisher
description: 用于从指定 Lark 文件夹同步最新 HTML、注入访问登录（用户名 tony / 密码 tototony）、并发布到 geminiuniq/toooooooony 仓库。适用于维护 Obita 业务梳理页面的自动化更新流程。
---

# Obita HTML Publisher

## 适用场景
当用户要求以下任一任务时使用本 Skill：
- 从 Lark Drive 文件夹同步最新 `.html` 文件
- 上传最新 HTML 后自动处理登录并发布
- 发布处理后的页面文件到 GitHub 仓库 `geminiuniq/toooooooony`

Lark 文件夹：
`https://obitaxyz.sg.larksuite.com/drive/folder/VnNVfkStNlqdS7dOlXNlnRaRgEb`

## 工作流
1. 让用户只执行一个动作：上传最新 `.html` 文件到仓库目录。
2. 在仓库根目录运行：
   `bash skills/obita-html-publisher/scripts/publish_latest_html.sh`
3. 脚本会自动：
   - 选择当前目录下最新修改的 `.html` 文件
   - 同步覆盖 `index.html`
   - 若页面缺失登录门禁，则自动注入用户名/密码登录（`tony` / `tototony`）
   - 自动执行 `git add index.html`、`git commit`、`git push`

## 重要说明
- 使用者不需要处理用户名密码配置；门禁逻辑自动注入并固定为 `tony` / `tototony`。
- Lark 文件夹的“直接下载最新 HTML”通常依赖登录态/Cookie；脚本默认从**本地已拉取文件**中选“最新 HTML”并发布处理后的 `index.html`。
- 若需要真正从 Lark 自动下载，先在本机配置可用 Cookie，再扩展脚本下载步骤。
- 这个登录是前端门禁，不是后端强鉴权；用于轻量访问控制。
