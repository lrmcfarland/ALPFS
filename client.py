#!/usr/bin/env python3

"""Python requests for ALPFS testing

To run:

./client.py

"""

import argparse
import logging
import requests


class ALPFSClient(object):

    def __init__(self, a_host, a_port=80, a_schema='http', an_api_version='api/v0/', use_verify=True):
        """Construct a ALPFS client

        Args:
            a_host (str): FQDN or IP address of director
            a_port (int): ssh port
            a_schema (str): http or https
            use_verify (bool): use certificate verification (usually False)
        """

        self.host = a_host
        self.port = a_port
        self.schema = a_schema
        self.api_version = an_api_version
        self.verify = use_verify

        self.headers = dict()
        self.headers['content-type'] = 'application/json'
        self.headers['cache-control'] = 'no-cache'

        return

    def compose_api_url(self, a_url):
        """Build API URL from parts"""
        return '{}://{}:{}/{}/{}'.format(self.schema, self.host, self.port, self.api_version, a_url)


    def get(self, a_url, params=None, headers=None):
        """GET action


        Args:
            a_url (str): url
            params (dict): GET parameters
            headers(dict): request headers

        Returns: request.get()
        """
        an_endpoint = self.compose_api_url(a_url)
        logging.debug('GET %s headers: %s, params: %s', an_endpoint, headers, params)
        return requests.get(an_endpoint, params=params, headers=headers, verify=self.verify)


    def post(self, a_url, headers=None, json=None, files=None):
        """POST action

        TODO data arg vs. json?

        Args:
            a_url (str): url
            json (json): json data to post
            files (dict): files = {'file': open('somefile.csv', 'rb')}
            headers(dict): request headers

        Returns: request.post()

        """
        an_endpoint = self.compose_api_url(a_url)
        logging.debug('POST %s headers: %s, JSON:%s,  files:%s', an_endpoint, headers, json, files)
        return requests.post(an_endpoint, headers=headers, json=json, files=files, verify=self.verify)



# ================
# ===== main =====
# ================


if __name__ == '__main__':


    loglevels = {'debug': logging.DEBUG,
                 'info': logging.INFO,
                 'warn': logging.WARN,
                 'error': logging.ERROR}

    defaults = {'host':'localhost',
                'loglevel': 'warn',
                'schema': 'http',
                'port': 80,
                'use_verify': False}

    parser = argparse.ArgumentParser(description='alpine linux python flask server')

    parser.add_argument('--host', type=str, dest='host', default=defaults['host'],
                        metavar='host',
                        help='FQDN or IP of host (default: %(default)s)')

    parser.add_argument('-l', '--loglevel', choices=list(loglevels.keys()),
                        dest='loglevel', default=defaults['loglevel'],
                        metavar='LEVEL',
                        help='logging level choice: %(keys)s (default: %(default)s)' % {
                            'keys':', '.join(list(loglevels.keys())), 'default':'%(default)s'})

    parser.add_argument('-p', '--port', type=int, dest='port', default=defaults['port'],
                        help='port (default: %(default)s)')

    parser.add_argument('--schema', type=str, dest='schema', default=defaults['schema'],
                        metavar='schema',
                        help='schema (default: %(default)s)')

    parser.add_argument('--use_verify', action='store_true',
                        dest='use_verify', default=defaults['use_verify'],
                        help='use_verify (default: %(default)s)')


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


    a_client = ALPFSClient(args.host, args.port, a_schema=args.schema, use_verify=args.use_verify)


    foo = a_client.get('whoami')

    print(foo)


    foo = a_client.post('whoareyou')

    print(foo)
