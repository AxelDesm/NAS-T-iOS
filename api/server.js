var express    = require('express');
var app        = express();
var bodyParser = require('body-parser');

var Cover      = require('./app/models/cover');

var mongoose   = require('mongoose');
mongoose.connect('mongodb://localhost/api');

app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));
app.use(bodyParser.json({ limit: '50mb' }));

var port = process.env.PORT || 8080;

var router = express.Router();

router.use(function(req, res, next) {
    console.log('Something is happening.');
    next();
});

router.route('/covers').post(function(req, res) {
        var cover = new Cover();
        var date = new Date();

        cover.type = req.body.type;
        cover.date = req.body.date;
        cover.thumbnail = req.body.thumbnail;

        cover.save(function(err) {
            if (err)
                res.send(err);

            res.json({ message: 'Cover created!' });
        });
}).get(function(req, res) {
    Cover.find().where('archived').equals(false).exec(function(err, covers) {
        if (err)
            res.send(err);

        res.json(covers);
    });
});

router.route('/covers/:cover_id').post(function(req, res) {
  Cover.findById(req.params.cover_id, function(err, cover) {
      if (err)
          res.send(err);

      cover.gallery.push(req.body.image);
      cover.save(function(err) {
          if (err)
              res.send(err);

          res.json({ message: 'Image added!' });
      });
  });
}).get(function(req, res) {
    Cover.findById(req.params.cover_id, function(err, cover) {
        if (err)
            res.send(err);

        res.json(cover);
    });
}).put(function(req, res) {
  Cover.findById(req.params.cover_id, function(err, cover) {
      if (err)
          res.send(err);

      cover.archived = true;
      cover.save(function(err) {
          if (err)
              res.send(err);

          res.json({ message: 'Archived' });
      });
  });
});

router.get('/', function(req, res) {
    res.json({ message: 'Working API!' });
});

app.use('/api', router);

app.listen(port);
console.log('Magic happens on port ' + port);
