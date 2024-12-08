# Dockerfile
FROM httpd:2.4

# העתקת קבצי האתר
COPY html/ /usr/local/apache2/htdocs/

# העתקת קובץ הקונפיגורציה
COPY apache-config/httpd.conf /usr/local/apache2/conf/httpd.conf
