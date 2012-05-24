var Context = Backbone.Model;

var ContextList = Backbone.Collection.extend({
  model : Context,
  url   : '/contexts'
}
);

Contexts = new ContextList();

var ContextDropdown = Backbone.View.extend({
  el : '#context-dropdown-navitem',

  events : {
    'click .context-dropdown-item' : 'selectContext',
    'click #context-link-reset' : 'unselectContext'
  },

  initialize : function()
  {
    this.dropdown_menu = this.$el.find('ul.dropdown-menu');
    this.template = _.template($('#context-navitem-template').html());

    this.collection.bind('reset', this.render, this);
  },

  render : function()
  {
    this.dropdown_menu.html("<li><a href='#' id='context-link-reset'>Any</a></li>");
    var self = this;
    this.collection.each(
      function(context)
      {
        self.dropdown_menu.append(self.template({context : context.toJSON()}))
      }
    );
    return this;
  },

  selectContext : function(event)
  {
    $('#context-dropdown-navitem a.dropdown-toggle').html($(event.target).html());
    $('#all-todos-button-navitem').removeClass('active');
    $('#context-dropdown-navitem').addClass('active').find('li').removeClass('active');
    $(event.target).parent().addClass('active');
    var id = $(event.target).attr('id').replace('context-link-', '');
    ViewOptions.context_id = id;
    ActiveTodos.redraw();
    CompletedTodos.redraw();
    event.preventDefault();
  },

  unselectContext : function(event)
  {
    $('#context-dropdown-navitem a.dropdown-toggle').html('Context');
    $('#context-dropdown-navitem').removeClass('active').find('li').removeClass('active');
    ViewOptions.context_id = null;

    if(ViewOptions.project_id == null && ViewOptions.context_id == null)
    {
      $('#all-todos-button-navitem').addClass('active');
    }

    ActiveTodos.redraw();
    CompletedTodos.redraw();
    event.preventDefault();
  }

}
);

