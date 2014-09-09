var mongoose = require('mongoose');

// auto increment
// I"s counter schema
var IsCounterSchema = new mongoose.Schema({
    _id: String,
    seq: Number
});

IsCounterSchema.statics.getNewId = function (name, callback) {
    return this.collection.findAndModify(
        { '_id': name },
        [],
        { '$inc': { seq: 1 } },
        { 'new': true, upsert: true },
        callback
    );
};

var getDate = function(){
    var result = null;

    var monthLabel = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    var weekLabel = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    var now = new Date();

    y = now.getFullYear();
    mon = now.getMonth();
    hours = (now.getHours() < 10) ? '0' + now.getHours() : now.getHours();
    min = (now.getMinutes() < 10) ? '0' + now.getMinutes() : now.getMinutes();
    s = (now.getSeconds() < 10) ? '0' + now.getSeconds() : now.getSeconds();
    d = (now.getDate() < 10) ? '0' + now.getDate() : now.getDate();
    w = now.getDay();
    result = d + ' ' + monthLabel[mon] + ' ' +  y  + ' at ' + hours + ':' + min + ':' + s;

    return result;
};

// I"s sub schema for position
var posSubSchema = mongoose.Schema({
    x: Number,
    y: Number
}, { _id: false });

var IsSchema = new mongoose.Schema({
    isID: { type: Number, index: { unique: true } },
    pos: [posSubSchema],
    date: { 'type': String, 'default': getDate() }
});

IsSchema.statics.random = function(callback) {
    this.count(function(error, count) {
        if (error) {
            return callback(error);
        }

        var random = Math.floor(Math.random() * count);
        this.findOne().skip(random).exec(callback);

    }.bind(this));
};

exports.IsSchema = IsSchema;
exports.IsCounterSchema = IsCounterSchema;