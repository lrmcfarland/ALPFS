The purpose of this project is to demonstrate how to use terraform to
create an EC2 instance on AWS and deploy an [Alpine
Linux](https://alpinelinux.org) [Python Flask
server](https://flask.palletsprojects.com/en/2.0.x/) (ALPFS) in a
docker container there.
In this example I build the container from this repo and pull it from my DockerHub account.

This follows from
[DDoS-attack-detection-using-HTTP-packet-clustering-pattern](https://github.com/gurpreet0610/DDoS-attack-detection-using-HTTP-packet-clustering-pattern)
and thanks to gurpreet0610 for sharing that and [In terraform, how can
I pull a Docker image on the
target?](https://stackoverflow.com/questions/64809479/in-terraform-how-can-i-pull-a-docker-image-on-the-target)
for suggeting it.




# Python Flask Server

From the command line

## Create a test environment

Use the python3 venv module to setup a virtual test environment.

### Create the venv directory

This is a one time setup

```
python3 -m venv venv-alpfs
```

### Activate

This is needed each time a new shell is started for testing

```
source venv-alpfs/bin/activate
```

### Install

One time setup again

```
pip install -r requirements.txt

```

## In the activated test environment

```
./alpfs.py -l debug
```

```
 * Serving Flask app 'alpfs' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
[2021-05-31 07:40:37,558 WARNING _internal.py 225]  * Running on all addresses.
   WARNING: This is a development server. Do not use it in a production deployment.
[2021-05-31 07:40:37,558 INFO _internal.py 225]  * Running on http://192.168.4.26:80/ (Press CTRL+C to quit)


^C

```


## To test

### With a browser

The web page should now be available on http://localhost


### With client.py

[client.py](https://github.com/lrmcfarland/ALPFS/blob/main/client.py)
is a python script that uses the python requests module to access the
API.


```
./client.py -l debug
```

```
[2021-06-06 07:04:08,525 DEBUG client.py 57] GET http://localhost:80/api/v0/whoami headers: None, params: {'foo': 'bar', 'baz': 42}
[2021-06-06 07:04:08,536 DEBUG connectionpool.py 227] Starting new HTTP connection (1): localhost:80
[2021-06-06 07:04:08,538 DEBUG connectionpool.py 452] http://localhost:80 "GET /api/v0/whoami?foo=bar&baz=42 HTTP/1.1" 200 73
<Response [200]>
[2021-06-06 07:04:08,539 DEBUG client.py 76] POST http://localhost:80/api/v0/whoareyou headers: None, JSON:{'foo': 'bar', 'baz': 42},  files:None
[2021-06-06 07:04:08,540 DEBUG connectionpool.py 227] Starting new HTTP connection (1): localhost:80
[2021-06-06 07:04:08,542 DEBUG connectionpool.py 452] http://localhost:80 "POST /api/v0/whoareyou HTTP/1.1" 200 71
<Response [200]>

```

### With client.js

[client.js](https://github.com/lrmcfarland/ALPFS/blob/main/client.js)
is a node.js sketch of a script that uses the axios module to access the
API. You will need to run npm install.

```
node client.js -u whoami
```

```
action response { args: {}, timestamp: '2021-06-06T09:02:51-0700' }
```


### With Python unittest

[test_alpfs.py](https://github.com/lrmcfarland/ALPFS/blob/main/test_alpfs.py)
is an example using the built in python unittest module with flask's
built in test client and does not need to have the server running in
another process.


```
python3 test_alpfs.py -v
```

```
test_get_whoami (__main__.AlpfsTests)
Test GET whoami API ... ok
test_get_whoareyou (__main__.AlpfsTests)
Test GET whoareyou API fails ... ok
test_home_page (__main__.AlpfsTests)
Test home page ... ok
test_post_whoami (__main__.AlpfsTests)
Test POST whoami API fails ... ok
test_post_whoareyou (__main__.AlpfsTests)
Test POST whoareyou API ... ok
test_starbug_link (__main__.AlpfsTests)
Test home page has starbug.com link ... ok

----------------------------------------------------------------------
Ran 6 tests in 0.034s

OK

```



# Alpine Linux container


## To build

```
docker build -f Dockerfile -t alpfs .
```

## To run


```
docker run --name alpfs00 -d -p 80:80 alpfs
```

The web page should now be available on http://localhost


With port 8080 on the outside mapped to port 80 on the inside

```
docker run --name alpfs00 -d -p 8080:80 alpfs
```

The web page should now be available on http://localhost:8080

## Logs

```
docker logs alpfs00
```

```
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


## Shell

Use docker exec to open a shell in the container

```
docker exec -it alpfs00 sh
```


## To stop

```
docker stop alpfs00
```

```
docker ps -a
```

```
CONTAINER ID   IMAGE     COMMAND             CREATED              STATUS                       PORTS     NAMES
4599c0076e3a   alpfs     "python alpfs.py"   About a minute ago   Exited (137) 6 seconds ago             alpfs00
```


## Tag and push to DockerHub

```
docker tag alpfs lrmcfarland/alpfs
docker push lrmcfarland/alpfs

```

## To remove

```
docker rm alpfs00
docker rmi alpfs
```


# Terraform

see [README.md](terraform/README.md)
