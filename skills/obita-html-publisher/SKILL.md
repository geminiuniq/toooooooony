---
name: obita-html-publisher
description: 用于从指定 Lark 文件夹同步最新 HTML、注入访问登录（用户名 tony / 密码 tototony）、并发布到 geminiuniq/toooooooony 仓库。适用于维护 Obita 业务梳理页面的自动化更新流程。
---

# Obita HTML Publisher

## 适用场景
当用户要求以下任一任务时使用本 Skill：
- 从 Lark Drive 文件夹同步最新 `.html` 文件
- 给 HTML 页面加访问登录（固定凭证：`tony` / `tototony`）
- 发布到 GitHub 仓库 `geminiuniq/toooooooony`

Lark 文件夹：
`https://obitaxyz.sg.larksuite.com/drive/folder/VnNVfkStNlqdS7dOlXNlnRaRgEb`

## 工作流
1. 在仓库根目录运行：
   `bash skills/obita-html-publisher/scripts/sync_latest_html.sh`
2. 脚本会：
   - 选择当前目录下最新修改的 `.html` 文件
   - 确保页面包含登录门禁（用户名 `tony`，密码 `tototony`）
   - 同步覆盖 `index.html`
3. 检查差异：
   `git status` 和 `git diff -- index.html`
4. 提交并发布：
   - `git add index.html`
   - `git commit -m "Update latest html with auth gate"`
   - `git push`

## 重要说明
- Lark 文件夹的“直接下载最新 HTML”通常依赖登录态/Cookie；脚本默认从**本地已拉取文件**中选“最新 HTML”。
- 若需要真正从 Lark 自动下载，先在本机配置可用 Cookie，再扩展脚本下载步骤。
- 这个登录是前端门禁，不是后端强鉴权；用于轻量访问控制。
