var Context = Backbone.Model;

var ContextList = Backbone.Collection.extend({
  model : Context,
  url   : '/contexts'
}
);

Contexts = new ContextList();

var ContextDropdown = Backbone.View.extend({
  el : '#context-dropdown-navitem',

  initialize : function()
  {
    this.dropdown_menu = this.$el.find('ul.dropdown-menu');
    this.template = _.template($('#context-navitem-template').html());

    this.collection.bind('reset', this.render, this);
  },

  render : function()
  {
    this.dropdown_menu.html('');
    var self = this;
    this.collection.each(
      function(context)
      {
        self.dropdown_menu.append(self.template({context : context.toJSON()}))
      }
    );
    return this;
  }
}
);

