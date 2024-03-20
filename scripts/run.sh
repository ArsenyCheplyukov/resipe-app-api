#!/bin/sh

# if any command next fails it fails the whole script
set -e

# wait until database starts befor starting application
python manage.py wait_for_db
# form static file in one common folder
python manage.py collectstatic --noinput
# apply all created migrations
python manage.py migrate

# run uwsgi on port 9000 with 4 parallel processes on application wsgi.py file
uwsgi --socket :9000 --workers 4 --master --enable-threads --module app.wsgi