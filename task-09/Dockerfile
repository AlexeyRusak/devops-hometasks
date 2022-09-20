FROM debian:latest
RUN apt update -y && \
    apt install -y apache2 php && \
    apt clean
ADD https://raw.githubusercontent.com/AlexeyRusak/devops-hometasks/master/task-09/index.php /var/www/html/
RUN chmod 755 /var/www/html/index.php && \
    rm -f /var/www/html/index.html
CMD ["apachectl", "-D", "FOREGROUND"]