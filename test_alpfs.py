#!/usr/bin/env python3

"""alpine python baised flask server for testing

To setup a test virtual environment

$ python3 -m venv test-venv
$ source test-venv/bin/activate
$ pip install -r requirements.txt

To run

(test-venv) [lrm@lrmz-iMac-2017 ALPFS (main)]$ python3 test_alpfs.py
.
----------------------------------------------------------------------
Ran 1 test in 0.019s

OK


"""

import argparse
import logging
import unittest

import alpfs


class AlpfsTests(unittest.TestCase):

    def setUp(self):
        """Set up test servers"""

        self.alpfs = alpfs.factory()
        self.client = self.alpfs.test_client()
        self.alpfs.testing = True

        return


    def test_home_page(self):
        """Test home page"""

        a_response = self.client.get('/')

        self.assertEqual('200 OK', a_response.status)

        return


    def test_starbug_link(self):
        """Test home page has starbug.com link"""

        a_response = self.client.get('/')
        self.assertIn(b'by <a href="https://www.starbug.com">starbug.com', a_response.data)

        return


    def test_get_whoami(self):
        """Test GET whoami API"""

        a_response = self.client.get('/api/v0/whoami', query_string={'foo':'bar', 'baz':42})

        self.assertEqual(200, a_response.status_code)

        self.assertIn('timestamp', a_response.json)
        self.assertIn('args', a_response.json)

        self.assertEqual('bar', a_response.json['args']['foo'])
        self.assertEqual(str(42), a_response.json['args']['baz']) # TODO as int?


        return


    def test_post_whoami(self):
        """Test POST whoami API fails"""

        a_response = self.client.post('/api/v0/whoami')

        self.assertEqual(405, a_response.status_code)

        return


    def test_get_whoareyou(self):
        """Test GET whoareyou API fails"""

        a_response = self.client.get('/api/v0/whoareyou')

        self.assertEqual(405, a_response.status_code)

        return


    def test_post_whoareyou(self):
        """Test POST whoareyou API"""

        a_response = self.client.post('/api/v0/whoareyou', json={'foo':'bar', 'baz':42})

        self.assertEqual(200, a_response.status_code)

        self.assertIn('timestamp', a_response.json)

        self.assertIn('args', a_response.json)

        self.assertEqual('bar', a_response.json['args']['foo'])
        self.assertEqual(42, a_response.json['args']['baz']) # TODO is int!

        return




# ================
# ===== main =====
# ================

if __name__ == '__main__':


    unittest.main()
