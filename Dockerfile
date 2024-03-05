# use cutted python 3.12 cutted version 
FROM python:3.12.2-alpine3.19

# User of this package:
LABEL maintainer="ArsenyCheplyukov"

# Don't buffer any output and just dump any in the output
ENV PYTHONBUFFERED 1

# copy requirements files for dev and prod versions
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# copy app files
COPY ./app /app

# switch to this folder
WORKDIR /app

# open this container at 8000 port
EXPOSE 8000

# by default we don't run container in development mode
ARG DEV=false

# install venv via script
RUN python -m venv /py && \
    # useful commands: updating and install requirements
    /py/bin/pip install --upgrade pip && \
    # install postgresql adapter dependances that we are actually
    # need for proper work of the psycopg adapter for postgres
    apk add --update --no-cache postgresql-client && \
    # install virtual dependancy that needed only for installation
    apk add --update --no-cache --virtual .tmp-build-deps \
        # build dependances
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    # check if development mode is enabled
    if [ $DEV = "true" ]; \
        # if so install dev dependences
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    # else nothing to install
    fi && \
    # delete all temporary files
    rm -rf /tmp && \
    # also delete cache from 'virtual' cache
    apk del .tmp-build-deps && \
    # add new user to operational system in a face of container
    adduser \
        # --disable-password is used for actually disabling password
        --disabled-password \
        # --no-create-home is used for avoiding creation of home directory for the user
        --no-create-home \
        django-user

# interesting thing is that spaces are used for appplying one command where less spaces

# extend path with files located in /py/bin
ENV PATH="/py/bin:$PATH"

# start container from user that we define earlier
USER django-user


# THE MAIN QUESTION: IS THIS NEEDED TO USE VENV IN DOCKER? aCTUALLY NO, BUT NEXT LEVEL OF ISOLATION MAY BE BETTER IN SOME CASES
