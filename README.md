# Alpine Linux Python Flask Server

This is an example of building a [python flask web
server](https://flask.palletsprojects.com/en/2.0.x/) running on
[Alpine Linux](https://alpinelinux.org) in a docker container.

The docker image is just under 50 MB in size.


# To Run

## From the command line

### Create a test environment

Use the python3 venv module to setup a virtual test environment.

#### Create the venv directory
This is a one time setup
```
$ python3 -m venv test-venv
```
#### Activate
This is needed each time a new shell is started for testing
```
$ source test-venv/bin/activate
```

#### Install
One time setup again

```
$ pip install -r requirements.txt
Collecting flask
  Downloading Flask-2.0.1-py3-none-any.whl (94 kB)
     |████████████████████████████████| 94 kB 1.6 MB/s
Collecting itsdangerous>=2.0
  Downloading itsdangerous-2.0.1-py3-none-any.whl (18 kB)
Collecting Jinja2>=3.0
  Downloading Jinja2-3.0.1-py3-none-any.whl (133 kB)
     |████████████████████████████████| 133 kB 7.9 MB/s
Collecting click>=7.1.2
  Downloading click-8.0.1-py3-none-any.whl (97 kB)
     |████████████████████████████████| 97 kB 9.3 MB/s
Collecting Werkzeug>=2.0
  Downloading Werkzeug-2.0.1-py3-none-any.whl (288 kB)
     |████████████████████████████████| 288 kB 62.4 MB/s
Collecting MarkupSafe>=2.0
  Downloading MarkupSafe-2.0.1-cp39-cp39-macosx_10_9_x86_64.whl (13 kB)
Installing collected packages: MarkupSafe, Werkzeug, Jinja2, itsdangerous, click, flask
Successfully installed Jinja2-3.0.1 MarkupSafe-2.0.1 Werkzeug-2.0.1 click-8.0.1 flask-2.0.1 itsdangerous-2.0.1
WARNING: You are using pip version 21.1.1; however, version 21.1.2 is available.
You should consider upgrading via the '/Users/lrm/Documents/Computer/examples/terraform/alpine-flask/squeaker-venv/bin/python3.9 -m pip install --upgrade pip' command.

```

### In the activated test environment

```
(test-venv) [lrm@lrmz-iMac-2017 ALPFS (main)]$ python3 alpfs.py
 * Serving Flask app 'alpfs' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
[2021-05-31 07:40:37,558 WARNING _internal.py 225]  * Running on all addresses.
   WARNING: This is a development server. Do not use it in a production deployment.
[2021-05-31 07:40:37,558 INFO _internal.py 225]  * Running on http://192.168.4.26:80/ (Press CTRL+C to quit)
[2021-05-31 07:41:37,582 INFO _internal.py 225] 127.0.0.1 - - [31/May/2021 07:41:37] "GET / HTTP/1.1" 200 -
[2021-05-31 07:41:37,591 INFO _internal.py 225] 127.0.0.1 - - [31/May/2021 07:41:37] "GET /static/style.css HTTP/1.1" 200 -


^C

```

The web page should now be available on http://localhost


### Python Test

test_alpfs.py has an example of a flask unit test.

```
(test-venv) [lrm@lrmz-iMac-2017 ALPFS (main)]$ python3 test_alpfs.py
.
----------------------------------------------------------------------
Ran 1 test in 0.016s

OK


```



## In a container

### To build

```
  docker build -f Dockerfile -t alpfs .
```
### To run


```
  docker run --name alpfs00 -d -p 80:80 alpfs
```

The web page should now be available on http://localhost


With port 8080 on the outside mapped to port 80 on the inside

```
  docker run --name alpfs00 -d -p 8080:80 alpfs
```

The web page should now be available on http://localhost:8080

### Logs

```
(test-venv) [lrm@lrmz-iMac-2017 ALPFS (rename2alpfs)]$ docker logs alpfs00
 * Serving Flask app 'alpfs' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
[2021-05-31 14:49:25,951 WARNING _internal.py 225]  * Running on all addresses.
   WARNING: This is a development server. Do not use it in a production deployment.
[2021-05-31 14:49:25,952 INFO _internal.py 225]  * Running on http://172.17.0.2:80/ (Press CTRL+C to quit)
[2021-05-31 14:49:37,880 INFO _internal.py 225] 172.17.0.1 - - [31/May/2021 14:49:37] "GET / HTTP/1.1" 200 -
[2021-05-31 14:49:37,885 INFO _internal.py 225] 172.17.0.1 - - [31/May/2021 14:49:37] "GET /static/style.css HTTP/1.1" 200 -
```


### To test

http://localhost:8080



### To shell
```
  docker exec -it alpfs00 sh
```


### To stop

```
(test-venv) [lrm@lrmz-iMac-2017 ALPFS (rename2alpfs)]$ docker stop alpfs00
alpfs00

(test-venv) [lrm@lrmz-iMac-2017 ALPFS (rename2alpfs)]$ docker ps -a
CONTAINER ID   IMAGE     COMMAND             CREATED              STATUS                       PORTS     NAMES
4599c0076e3a   alpfs     "python alpfs.py"   About a minute ago   Exited (137) 6 seconds ago             alpfs00

(test-venv) [lrm@lrmz-iMac-2017 ALPFS (rename2alpfs)]$ docker rm alpfs00
alpfs00


```
