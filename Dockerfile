# 第一步：用官方 Jekyll 镜像构建 Chirpy 静态站点
FROM jekyll/jekyll:latest as builder

# 设置容器内的工作目录为 /site，后续命令都会在该目录下执行
WORKDIR /site

# 复制所有博客源文件（包括 Gemfile 等）
# 第一个.：指的是 Docker 构建上下文（build context） 中的当前目录（执行 docker build 时所在的本地目录）。
# 第二个.：指的是容器内部当前工作目录（也就是 WORKDIR 指定的目录，比如 /site）。
COPY . .

# 安装依赖（从 Gemfile）并构建网站到 _site/
RUN bundle install
RUN JEKYLL_ENV=production bundle exec jekyll build

# 第二步：用 nginx 运行构建好的静态站点
FROM nginx:alpine

# 将构建好的 _site 内容复制到 nginx 的根目录
COPY --from=builder /site/_site /usr/share/nginx/html

# 暴露 9527 端口
EXPOSE 9527

# 默认启动 nginx 前台服务
CMD ["nginx", "-g", "daemon off;"]
