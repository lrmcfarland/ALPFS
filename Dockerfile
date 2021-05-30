# This creates the simple flask server on alpine linux

# to build:
# docker build -f Dockerfile -t alpineflask .

# to run:
# docker run --name the_alpineflask -d -p 8080:8080 alpineflask

# to test:
# http://localhost

# to shell:
# docker exec -it the_alpineflask sh


FROM python:3-alpine


LABEL maintainer "lrm@starbug.com"
LABEL service "alpineflask"


# add app user

ENV APP_USER="lrm" \
    APP_GROUP="lrm" \
    USER_HOME="/home/lrm"

RUN addgroup -S ${APP_GROUP} \
    && adduser -g ${APP_GROUP} -S ${APP_USER}

# install as user

USER ${APP_USER}:${APP_GROUP}


ENV PATH ${PATH}:${USER_HOME}/.local/bin


RUN pip install --upgrade pip

WORKDIR ${HOME}/alpineflask

COPY requirements.txt .
RUN pip install -r requirements.txt

ADD alpine_flask.py .
ADD templates templates
ADD static static

# run app

ENTRYPOINT ["python"]
CMD [ "alpine_flask.py" ]
