var Tag = Backbone.Model;

var TagList = Backbone.Collection.extend({
  model : Tag,
  url   : '/tags'
}
);

Tags = new TagList();
