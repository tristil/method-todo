var Project = Backbone.Model;

var ProjectList = Backbone.Collection.extend({
  model : Project,
  url   : '/projects'
}
);

Projects = new ProjectList();
var ProjectDropdown = Backbone.View.extend({
  el: '#project-dropdown-navitem',

  events : {
    'click .project-dropdown-item' : 'selectContext',
    'click #project-link-reset' : 'unselectProject'
  },

  initialize : function()
  {
    this.dropdown_menu = this.$el.find('ul.dropdown-menu');
    this.template = _.template($('#project-navitem-template').html());

    this.collection.bind('reset', this.render, this);
  },

  render : function()
  {
    this.dropdown_menu.html("<li><a href='#' id='project-link-reset'>Any</a></li>");
    var self = this;
    this.collection.each(
      function(project)
      {
        self.dropdown_menu.append(self.template({project : project.toJSON()}))
      }
    );
    return this;
  },

  selectContext : function(event)
  {
    $('#project-dropdown-navitem a.dropdown-toggle').html($(event.target).html());
    $('#all-todos-button-navitem').removeClass('active');
    $('#project-dropdown-navitem').addClass('active').find('li').removeClass('active');
    $(event.target).parent().addClass('active');
    var id = $(event.target).attr('id').replace('project-link-', '');
    ViewOptions.project_id = id;
    ActiveTodos.redraw();
    CompletedTodos.redraw();
    event.preventDefault();
  },

  unselectProject : function(event)
  {
    $('#project-dropdown-navitem a.dropdown-toggle').html('Project');
    $('#project-dropdown-navitem').removeClass('active').find('li').removeClass('active');
    ViewOptions.project_id = null;

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

