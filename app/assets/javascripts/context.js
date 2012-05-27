var Context = Backbone.Model;

var ContextList = Backbone.Collection.extend({
  model : Context,
  url   : '/contexts'
}
);

Contexts = new ContextList();
