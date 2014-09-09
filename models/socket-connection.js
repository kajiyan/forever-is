var socket = require('socket.io');

var schemas = require('../models/Is.js');
var isSchema = schemas.IsSchema;
var isCounterSchema = schemas.IsCounterSchema;

function socketConnection(server, db) {
    var io = socket.listen(server);

    var Is = db.model('is', isSchema);
    var IsCounter = db.model('is_counter', isCounterSchema);

    // IsCounter.getNewId('Is', function(err, counter){
    //     if (err) throw err;
    //     // 呼び出すごとにseqが+1ずつされていく
    //     var newId = counter.seq;
    //     console.log(newId);
    // });

    // IsCounter.find(null, "date pos", {sort: {"isID": -1}, limit:1}, function(error, data){
    //             if(error){
    //                 console.log(error);
    //             }
    //             console.log(data);
    //             // res.render('index', {data: data});
    //         });


    io.sockets.on('connection', function (socket) {
        console.log('connection');

        // IsCounter.find(null, "date pos", {sort: {"isID": -1}, limit:1}, function(error, data){
        //     if(error){
        //         console.log(error);
        //     }
        //     console.log(data);
        //     // res.render('index', {data: data});
        // });



        // IsCounter.findOne(null, function (err, data) {
        //     console.log(data);
        // });


// QuoteSchema.statics.random = function(callback) {
//   this.count(function(err, count) {
//     if (err) {
//       return callback(err);
//     }
//     var rand = Math.floor(Math.random() * count);
//     this.findOne().skip(rand).exec(callback);
//   }.bind(this));
// };


        // IsCounter.getNewId('Is', function(err, counter){
        //     if (err) throw err;
        //     // 呼び出すごとにseqが+1ずつされていく
        //     var newId = counter.seq;
        //     console.log(newId);
        // });

        socket.on('c-to-s-connect', function() {
            console.log('MESSAGE - c-to-s-connect');
            socket.emit('s-to-c-connect', socket.id);
        });

        socket.on('disconnect', function() {
            console.log('disconnected');
            socket.broadcast.emit('s-to-c-disconnect', socket.id);
        });

        socket.on('c-to-s-now-position', function (data) {
            // マウスの情報を配信
            // console.log(data);

            // socketのIDを付加
            data.socketID = socket.id;
            socket.broadcast.emit('s-to-c-now-position', data);
        });

        socket.on('c-to-s-add-position', function (data) {
            IsCounter.getNewId('Is', function(error, counter){
                if (error) throw error;
                // 呼び出すごとにseqが+1ずつされていく
                var newId = counter.seq;

                // Bits スキーマモデル生成
                var is = new Is();

                is['isID'] = newId;
                is['pos'] = data.pos;



                // is.save(function(error){
                //     console.log(error);
                // });
            });
        });

        socket.on('c-to-s-get-position', function (data) {
            var query = { "isID": "613" };

            console.log("更新されています");

            Is.random(function(err, quote) {
                console.log(quote);
            });


            // Is.statics.random = function(callback) {
            //     this.count(function(err, count) {
            //         if (error) {
            //             return callback(error);
            //         }

            //         var random = Math.floor(Math.random() * count);
            //         this.findOne().skip(rand).exec(callback);

            //     }.bind(this));
            // };

// QuoteSchema.statics.random = function(callback) {
//   this.count(function(err, count) {
//     if (err) {
//       return callback(err);
//     }
//     var rand = Math.floor(Math.random() * count);
//     this.findOne().skip(rand).exec(callback);
//   }.bind(this));
// };

            // Adventure.count({ type: 'jungle' }, function (error, count) {
            //     if(error){
            //         console.log(error);
            //     }
            //     console.log('there are %d jungle adventures', count);
            // });

            // FIND
            // Is.find(query, "date pos", {sort: {"isID": -1}, limit:1}, function(error, data){
            //     if(error){
            //         console.log(error);
            //     }
            //     console.log(data);
            //     // res.render('index', {data: data});
            // });
        });
    });
}

module.exports = socketConnection;


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