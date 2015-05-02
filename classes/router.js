var util = require('../lib/util.js'),
    serverRouter = require('../lib/serverRouter.js'),
    clientRouter = require('../lib/clientRouter.js');

module.exports = Router = function(){
  this.entries = [];
};

Router.prototype.path = function(path, handler){

  if (typeof path !== 'string') throw 'path must be a string';
  if (typeof handler !== 'function') throw 'handler must be a function';
  if (path[0] !== '/') path = '/'+path;

  this.entries.push({
    path: path,
    handler: handler
  });
};

Router.prototype.use = function(router){
  if (router instanceof Router){
    util.arrayMerge(this.entries, router.entries);
  }
  return this
};

Router.prototype.exportClient = function(){
  return new clientRouter(this);
};

Router.prototype.exportServer = function(){
  return serverRouter(this);
}