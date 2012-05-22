var Project = Backbone.Model;

var ProjectList = Backbone.Collection.extend({
  model : Project,
  url   : '/projects'
}
);

Projects = new ProjectList();

var ProjectDropdown = Backbone.View.extend({
  el: '#project-dropdown-navitem',

  initialize : function()
  {
    this.dropdown_menu = this.$el.find('ul.dropdown-menu');
    this.template = _.template($('#project-navitem-template').html());

    this.collection.bind('reset', this.render, this);
  },

  render : function()
  {
    this.dropdown_menu.html('');
    var self = this;
    this.collection.each(
      function(project)
      {
        self.dropdown_menu.append(self.template({project : project.toJSON()}))
      }
    );
    return this;
  }
}
);

