#!/usr/bin/env node

var fs = require('fs');
var path = require('path');
var xml2js = require('xml2js');

// Don't show path in usage information.
var argv = [];
process.argv.forEach((elem) => {
  argv.push(path.basename(elem));
});

// Print usage information if argument not specified
if (argv.length !== 3) {
  console.log('USAGE: ' + argv[0] + ' ' + argv[1] + ' file');
  console.log('       ' + './' + argv[1] + ' file');
} else {
  var parser = new xml2js.Parser();
  // Read file and parse it, pass output to filter function.
  fs.readFile(path.join(__dirname, argv[2]), (err, data) => {
    if (err) console.log(err);
    else {
      parser.parseString(data, (error, result) => {
        if (error) console.log(error);
        else
          filter(result);
      });
    }
  });
}

function filter(obj) {
  // Print title for each element with a category of "artikler".
  obj.rss.channel[0].item.forEach((elem) => {
    if (elem.category[0]["$"].nicename == "artikler") {
      console.log(elem.title[0]);
    }
  });
}

