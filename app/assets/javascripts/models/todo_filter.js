MethodTodo.Views.TodoFilter = Backbone.Model.extend({
  project_id : null,
  context_id: null,
  tag_id: null,

  applyFilter : function(id, type, clear)
  {
    this.$('#all-todos-button-navitem').removeClass('active');

    if(clear)
    {
      this.$('.dropdown-menu li').removeClass('active');
      this.$('.dropdown').removeClass('active');
    }

    $('#'+type+'-dropdown-navitem').addClass('active').find('li').removeClass('active');

    $('#'+type+'-link-' + id).parent().addClass('active');

    if(type == 'context')
    {
      MethodTodo.Globals.ViewOptions.context_id = id;
      if(clear)
      {
        MethodTodo.Globals.ViewOptions.project_id = null;
        MethodTodo.Globals.ViewOptions.tag_id = null;
      }
    }
    else if(type == 'project')
    {
      MethodTodo.Globals.ViewOptions.project_id = id;
      if(clear)
      {
        MethodTodo.Globals.ViewOptions.context_id = null;
        MethodTodo.Globals.ViewOptions.tag_id= null;
      }
    }
    else if(type == 'tag')
    {
      MethodTodo.Globals.ViewOptions.tag_id = id;
      if(clear)
      {
        MethodTodo.Globals.ViewOptions.project_id = null;
        MethodTodo.Globals.ViewOptions.context_id = null;
      }
    }
  }

});
