FROM httpd

COPY html/ /usr/local/apache2/htdocs/

COPY apache-config/httpd.conf /usr/local/apache2/conf/httpd.conf
