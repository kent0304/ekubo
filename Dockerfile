# build environment
FROM node:13.12.0-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
COPY tsconfig.json ./
RUN yarn install --silent
RUN yarn global add react-scripts@3.4.1 --silent
COPY . ./
RUN yarn run build

# production environment
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
# COPY ./nginx.conf /etc/nginx/nginx.conf
RUN ls /etc/nginx
RUN cat /etc/nginx/conf.d/default.conf
RUN cat /etc/nginx/fastcgi.conf
RUN cat /etc/nginx/nginx.conf
# COPY ./default.conf /etc/nginx/conf.d/default.conf

# ディレクトリオーナーを変更
RUN touch /var/run/nginx.pid && \
  chown -R nginx:nginx /var/run/nginx.pid && \
  chown -R nginx:nginx /var/cache/nginx

# EXPOSE 1337:8080

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]