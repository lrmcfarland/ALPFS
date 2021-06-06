#!/usr/bin/env node

// node client example using axios


// To install:
// npm install axios yargs


// To run:
// node client.js -u whoami


const axios = require('axios');
const yargs = require('yargs');

yargs.version('0.1')

const argv = yargs
      .command('client', 'nodejs client', {})
      .option('t', {
	  alias: 'host',
	  describe: 'target host',
	  default: 'localhost'
      })
      .option('p', {
	  alias: 'port',
	  describe: 'target port',
	  default: 80,
	  type: 'number'
      })
      .option('u', {
	  alias: 'url',
	  describe: 'url to run',
	  demandOption: 'The url is required.',
      })
      .help()
      .alias('help', 'h')
      .argv;


console.log('argv: ', argv);

async function get_whoami() {

    action_config = {
	method: 'get',
	baseURL: 'http://' + argv.host + ':' + argv.port,
	url: '/api/v0/' + argv.url,
    }

    axios(action_config).then(function (response) {

	console.log('action response', response['data']);

    }).catch(function (error) {
	console.log('action error', error);
    })

}



get_whoami()
