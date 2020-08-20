FROM mono:latest

LABEL maintainer="崔海亮 <cuihailiang@gmail.com>"

COPY sources.list .
RUN cat /etc/apt/sources.list >> sources.list && mv sources.list /etc/apt/sources.list

RUN apt-get update \
  && apt-get install -y \
      iproute2 supervisor ca-certificates-mono fsharp mono-vbnc nuget \
      referenceassemblies-pcl mono-fastcgi-server4 nginx nginx-extras \
  && rm -rf /var/lib/apt/lists/* /tmp/* \
  && echo "daemon off;" | cat - /etc/nginx/nginx.conf > temp && mv temp /etc/nginx/nginx.conf \
  && sed -i -e 's/www-data/root/g' /etc/nginx/nginx.conf

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

COPY nginx/ /etc/nginx/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
 
EXPOSE 80

ENTRYPOINT [ "/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf" ]
