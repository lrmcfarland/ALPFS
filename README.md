# Alpine Flask server

This is an example of building a [python flask web server](https://flask.palletsprojects.com/en/2.0.x/) running on Alpine Linux in a docker container.

# Virtual environment

Use the python3 venv module to setup a test environment.

## Create the venv directory
This is a one time setup
```
$ python3 -m venv test-venv
```
## Activate
This is needed each time a new shell is started for testing
```
$ source test-venv/bin/activate
```

## Install
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

# To Run

## From the command line

```

$ python3 alpine_flask.py 
 * Serving Flask app 'squeaker' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
[2021-05-30 13:53:14,960 WARNING _internal.py 225]  * Running on all addresses.
   WARNING: This is a development server. Do not use it in a production deployment.
[2021-05-30 13:53:14,960 INFO _internal.py 225]  * Running on http://192.168.4.26:80/ (Press CTRL+C to quit)


```

The web page should now be available on http://localhost


# In a container

## To build

```
  docker build -f Dockerfile -t alpineflask .
```
## To run
```
  docker run --name the_alpineflask -d -p 8080:8080 alpineflask
```

## To test

http://localhost:8080

TODO error if on port 80

```
$ docker logs the_alpineflask
SyntaxError: Non-UTF-8 code starting with '\x84' in file /bin/sh on line 2, but no encoding declared; see http://python.org/dev/peps/pep-0263/ for details

```

## to shell
```
  docker exec -it the_alpineflask sh
```




