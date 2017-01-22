var mongoose     = require('mongoose');
var Schema       = mongoose.Schema;

var CoverSchema   = new Schema({
    date: String,
    type: String,
    thumbnail: String,
    gallery: [],
    archived: { type: Boolean, default: false }
});

module.exports = mongoose.model('Cover', CoverSchema);
