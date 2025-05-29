# 🌐 My Blog

> Powered by [Jekyll](https://jekyllrb.com/) + [Chirpy Theme](https://github.com/cotes2020/jekyll-theme-chirpy)

这是我基于 Jekyll + Chirpy 主题搭建的个人技术博客，主要记录学习笔记、开发经验与技术文章。

## 🚀 项目预览

本地运行博客：

```bash
# 安装依赖
bundle install

# 启动本地服务器预览
bundle exec jekyll serve
```

默认会启动在 `http://127.0.0.1:4000`，可在浏览器中访问查看效果。

## 🔧 环境要求

- Ruby >= 3.0
- Bundler >= 2.0
- Jekyll >= 4.0

建议使用 Ruby 官方推荐的方式安装：[https://www.ruby-lang.org/](https://www.ruby-lang.org/)

## 📁 项目结构简述

```
.
├── _posts/             # 博文文件
├── _config.yml         # 站点配置文件
├── Gemfile             # Ruby 依赖配置
├── assets/             # 资源文件（图片、样式等）
└── _site/              # 构建输出目录（自动生成）
```

## 📦 安装依赖

```bash
bundle install
```

## 🛠️ 构建博客

```bash
bundle exec jekyll build
```

## 🌍 部署

你可以将 `_site/` 中生成的静态文件部署到 GitHub Pages、Vercel、Netlify 或其他静态托管平台。

### GitHub Pages 自动部署（示例）

1. 确保你的仓库名为：`your-username.github.io`
2. 在仓库设置中启用 GitHub Pages 并选择 `/ (root)` 或 `/docs` 目录
3. 每次提交都会自动构建并部署

> 或参考 Chirpy 的部署指南：[https://chirpy.cotes.page/posts/getting-started/](https://chirpy.cotes.page/posts/getting-started/)

## ✅ 主题说明

本博客使用 [Chirpy](https://github.com/cotes2020/jekyll-theme-chirpy) 主题，适配良好，支持：

- 响应式布局
- 分类 / 标签 / 归档
- 代码高亮与数学公式
- 支持 GitHub Pages 自动部署

## 📄 License

本项目基于 MIT 许可证开源，欢迎自由修改、引用与使用。

---

🧊 *Enjoy writing, stay curious.* ✨
