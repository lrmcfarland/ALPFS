#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""alpine python baised flask server for testing

To setup a test virtual environment

$ python3 -m venv test-venv
$ source test-venv/bin/activate
$ pip install -r requirements.txt

To run


$ python3 alpine_flask.py 
 * Serving Flask app 'squeaker' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
[2021-05-30 13:53:14,960 WARNING _internal.py 225]  * Running on all addresses.
   WARNING: This is a development server. Do not use it in a production deployment.
[2021-05-30 13:53:14,960 INFO _internal.py 225]  * Running on http://192.168.4.26:80/ (Press CTRL+C to quit)




"""


import argparse
import logging
import os
import time

import flask

# -------------------
# ----- globals -----
# -------------------

ISO8601 = '%Y-%m-%dT%H:%M:%S%z'

home_page = flask.Blueprint('home_blueprint', __name__, template_folder='templates')


def factory(config_flnm=None):
    """Creates squaker

    Args:
        config_flnm (str): flask configuration filename
    """

    app = flask.Flask(__name__)

    if config_flnm is not None:
        app.config.from_pyfile(config_flnm)

    app.register_blueprint(home_page)

    return app



@home_page.route('/')
def index():
    """Home page"""
    logging.info('index called')

    response = dict()
    response['timestamp'] = time.strftime(ISO8601)

    return flask.render_template('home.html', **response)







# ================
# ===== main =====
# ================

if __name__ == '__main__':

    loglevels = {'debug': logging.DEBUG,
                 'info': logging.INFO,
                 'warn': logging.WARN,
                 'error': logging.ERROR}

    defaults = {'host':'0.0.0.0',
                'loglevel': 'warn',
                'port': 80,
                'debug': False}

    parser = argparse.ArgumentParser(description='simple flask server for testing')

    parser.add_argument('-f', '--config', type=str, dest='config', default=None,
                        metavar='config',
                        help='flask config filename (default: %(default)s)')

    parser.add_argument('-d', '--debug', action='store_true',
                        dest='debug', default=defaults['debug'],
                        help='debug (default: %(default)s)')

    parser.add_argument('--host', type=str, dest='host', default=defaults['host'],
                        metavar='host',
                        help='fqdn or IP of host (default: %(default)s)')

    parser.add_argument('-l', '--loglevel', choices=list(loglevels.keys()),
                        dest='loglevel', default=defaults['loglevel'],
                        metavar='LEVEL',
                        help='logging level choice: %(keys)s (default: %(default)s)' % {
                            'keys':', '.join(list(loglevels.keys())), 'default':'%(default)s'})

    parser.add_argument('-p', '--port', type=int, dest='port', default=defaults['port'],
                        help='port (default: %(default)s)')

    args = parser.parse_args()


    # ----- set up default logging -----

    log_handler = logging.StreamHandler()
    log_handler.setFormatter(
        logging.Formatter(
            '[%(asctime)s %(levelname)s %(filename)s %(lineno)s] %(message)s'))

    logging.getLogger().addHandler(log_handler)
    logging.getLogger().setLevel(loglevels[args.loglevel])


    # -------------------
    # ----- run app -----
    # -------------------

    app = factory(args.config)

    app.run(host=args.host, port=int(os.getenv('SQUEAKER_PORT', args.port)), debug=args.debug, threaded=True)
