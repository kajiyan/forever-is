var express = require('express');
var path = require('path');
var favicon = require('static-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');

var socket = require('socket.io');
var request = require('request');
var validator = require('validator');
var mongoose = require('mongoose');
var swig = require('swig');

var routes = require('./routes/index');
var users = require('./routes/users');

var debug = require('debug')('ai');

var settings = require("./settings");

var databaseConnection = require('./models/database-connection');
var socketConnection = require('./models/socket-connection');

var app = module.exports = express();
// var app = express();

app.set('host', process.env.HOST || settings.host);
app.set('port', process.env.PORT || settings.port);

var server = app.listen(app.get('port'), function() {
  debug('Express server listening on port ' + server.address().port);
});



// To disable Swig's cache, do the following:
swig.setDefaults({ cache: false });

// swig view engine setup
app.engine('html', swig.renderFile);
app.set('view engine', 'html');
app.set('views', path.join(__dirname, 'views'));

app.use(favicon());
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));


// --------------------------------------------
//  DATA BASE
// --------------------------------------------
// // Bits スキーマ定義
// var Schema = mongoose.Schema;
// var BitsSchema = new Schema({
//     id: Number,
//     pos: [], // {x: 0, y: 0}
//     date: { 'type': Date, 'default': Date.now }
// });

// // mongoDBサーバ接続
// db = mongoose.connect('mongodb://localhost:27017/nodedb', function (error) {
//     if (error) {
//         console.log(error);
//     }
// });

// // Bits スキーマモデル生成
// var Bits = db.model('Bits', BitsSchema);

// // インスタンス生成
// var bits = new Bits();
// bits['id'] = 1000;
// bits['pos'] = {x: 1000, y: 1000};
// bits.save(function(err) {
//     console.log(err);
// });


// Bits.find({}, function(err, docs) {
//     //検索結果をクライアントに送信
//     console.log(docs);
// });

// --------------------------------------------
// METHODS
// --------------------------------------------
// --------------------------------------------
// database
db = databaseConnection();
app.set('db', db);

// --------------------------------------------
// socket.io
socketConnection(server, db);
// var io = socket.listen(server);

// io.sockets.on('connection', function (socket) {
//     console.log('connection');
//     socket.on('disconnect', function() {
//         console.log('disconnected');
//     });

//     socket.on('c-to-s-now-position', function (data) {
//         console.log(data);
//     });

//     socket.on('c-to-s-add-position', function (data) {
//         console.log(data);
//     });
// });

// --------------------------------------------
// ROUTERS
// --------------------------------------------
app.use('/', routes);
app.use('/users', users);

/// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

/// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});


module.exports = app;
