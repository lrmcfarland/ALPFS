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

        a_response = self.client.get('/')

        self.assertEqual('200 OK', a_response.status)

        return

    def test_starbug_link(self):

        a_response = self.client.get('/')
        self.assertIn(b'by <a href="https://www.starbug.com">starbug.com', a_response.data)

        return



if __name__ == '__main__':
    unittest.main()
