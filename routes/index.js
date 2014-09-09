var express = require('express');
var router = express.Router();

// var mongoose = require('mongoose');

// var connection = require("../models/db-connection.js");
// var schemas = require('../models/Is.js');
// var isSchema = schemas.IsSchema;
// var isCounterSchema = schemas.IsCounterSchema;


// var db = connection.DataBase;
// var Is = db.model('is', isSchema);
// var IsCounter = db.model('is_counter', isCounterSchema);

// console.log(IsCounter.getNewId('Is', function(){}));

// /* GET home page. */
// router.get('/', function(req, res) {
//   _self = {
//     'req': req,
//     'res': res
//   };

//   IsCounter.getNewId('Is', function(err, counter){
//     console.log(counter);
//     // res.end('hello world');
//     _self.res.render('index');
//   });

//   // IsCounters.getNewId('Is', function(err, counter){
//   //   // if (err) throw err;
//   //   //呼び出すごとにseqが+1ずつされていく
//   //   // var newId = counter.seq;
//   //   // console.log(newId);
//   //   res.end('hello world');
//   // });

//   // res.render('index', { title: 'Express' });
// });

// module.exports = router;

/* GET home page. */
router.get('/', function(req, res) {
  res.render('index');
});

module.exports = router;