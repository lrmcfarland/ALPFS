# This creates an alpine linux python flask server

# to build:
# docker build -f Dockerfile -t alpfs .

# to run:
# docker run --name alpfs00 -d -p 8080:80 alpfs

# to test:
# http://localhost

# to shell:
# docker exec -it alpfs00 sh


FROM python:3-alpine


LABEL maintainer "lrm@starbug.com"
LABEL service "alpfs"


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

WORKDIR ${USER_HOME}/alpfs

COPY requirements.txt .
RUN pip install -r requirements.txt

ADD alpfs.py .
ADD templates templates
ADD static static

# run app

EXPOSE 8080

ENTRYPOINT ["python"]
CMD [ "alpfs.py", "-p", "8080" ]
