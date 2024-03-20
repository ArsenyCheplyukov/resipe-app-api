# cntainer that runs nginx like unroot user
FROM nginxinc/nginx-unprivileged:1.25.1-alpine3.18
# define creator
LABEL maintainer="ArsenyCheplyukov"

# copy config file parameters for server
COPY ./default.conf.tpl /etc/nginx/default.conf.tpl
# copy config parameters for uwsgi settings
COPY ./uwsgi_params /etc/nginx/uwsgi_params
# copy bash script to run server
COPY ./run.sh /run.sh

# port where application is listen to
ENV LISTEN_PORT=8000
# host what we are using for the server
ENV APP_HOST=app
# port where uwsgi is running
ENV APP_PORT=9000

# need to switch to root user to set up image
USER root

# create a new folder static in vol folder to serve static files
RUN mkdir -p /vol/static && \
    # set permissions to rad contents of static files
    chmod 755 /vol/static && \
    # create only empty conf file
    touch /etc/nginx/conf.d/default.conf && \
    # change owner of newly created file
    chown nginx:nginx /etc/nginx/conf.d/default.conf && \
    # add executre permission to run script
    chmod +x run.sh

# enable storing in static folder
VOLUME /vol/static

# switch to default nginx user
USER nginx

# run bash script file
CMD ["/run.sh"]