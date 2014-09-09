var mongoose = require('mongoose');

function databaseConnection() {
  return mongoose.connect('mongodb://localhost:27017/nodedb', function (error) {
    if (error) {
      console.log(error);
    }
  });
}

module.exports = databaseConnection;

// var mongoose = require('mongoose');

// DataBase = mongoose.connect('mongodb://localhost:27017/nodedb', function (error) {
//     if (error) {
//         console.log(error);
//     }
// });

// exports.DataBase = DataBase;