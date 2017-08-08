upstream <%= params.module %>_dev {
  server unix:/home/<%= params.user %>/projects/map-tools-<%= params.module %>/shared/sockets/node.dev.sock;
}

upstream <%= params.module %>_static_dev {
  server unix:/home/<%= params.user %>/projects/map-tools-<%= params.module %>/shared/sockets/webpack.sock;
}

server {
  listen <%= params.port %>;

  server_name <%= params.server_name %>;

  charset utf-8;

  location /<%= params.module %> {
    proxy_pass http://<%= params.module %>_dev;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;
  }

  location ^~ /static {
    proxy_pass http://<%= params.module %>_static_dev;
  }

  location /cable {
   proxy_pass http://<%= params.module %>_dev;
   proxy_http_version 1.1;
   proxy_set_header Upgrade $http_upgrade;
   proxy_set_header Connection "upgrade";
  }

  location ^~ /sockjs-node/ {
   proxy_pass http://<%= params.module %>_static_dev;
   proxy_http_version 1.1;
   proxy_set_header Upgrade $http_upgrade;
   proxy_set_header Connection "upgrade";
  }

  location ^~ /webpack/ {
   proxy_pass http://<%= params.module %>_static_dev;
   proxy_http_version 1.1;
   proxy_set_header Upgrade $http_upgrade;
   proxy_set_header Connection "upgrade";
  }

}