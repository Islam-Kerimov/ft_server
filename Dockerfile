FROM debian:buster

#installation plushki
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y wget
RUN apt-get install -y vim

#installation nginx, mysql, php
RUN apt-get install -y nginx
RUN apt-get install -y mariadb-server
RUN apt-get install -y php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring

#customization nginx
COPY ./srcs/nginx.conf /etc/nginx/sites-available/nginx.conf
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled
RUN rm -f /etc/nginx/sites-enabled/default

#installation phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english /var/www/html/phpmyadmin

#installation ssl
RUN openssl req -x509 -nodes -days 365 -subj "/C=KR/ST=Korea/L=Seoul/O=innoaca/OU=42seoul/CN=forhjy" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

#installation wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz
RUN mv wordpress /var/www/html/wordpress

#customization phpmyadmin and wordpress
COPY ./srcs/wp-config.php /var/www/html/wordpress/wp-config.php
COPY ./srcs/config.inc.php /var/www/html/phpmyadmin/config.inc.php

RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*
COPY ./srcs/init.sh ./

EXPOSE 80 443

CMD bash init.sh
