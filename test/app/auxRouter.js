var Ice = require('ice-js'),
    auxRouter = require('./auxRouter2.js');

var Router = module.exports = new Ice.Router();

Router.path('/aux', function(page){
  page.render('aux-ok');
});

Router.use(auxRouter);
