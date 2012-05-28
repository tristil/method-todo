MethodTodo.Views.DropdownBar = Backbone.View.extend({
  el : '#dropdowns-bar',

  events : {
    'click #all-todos-button-navitem' : 'viewAllTodos'
  },

  initialize : function()
  {
    this.all_button = this.$('#all-todos-button-navitem');
  },

  viewAllTodos : function()
  {
    var caret_html = "<b class='caret'></b>";
    $('#project-dropdown-navitem a.dropdown-toggle').html('Project' + caret_html);
    $('#context-dropdown-navitem a.dropdown-toggle').html('Context' + caret_html);
    $('#tag-dropdown-navitem a.dropdown-toggle').html('Tag' + caret_html);
    this.$('#all-todos-button-navitem').addClass('active');
    this.$('.dropdown').removeClass('active');
    this.$('.dropdown-menu li').removeClass('active');
    ViewOptions.context_id = null;
    ViewOptions.project_id = null;
    ViewOptions.tag_id = null;
    ActiveTodos.redraw();
    CompletedTodos.redraw();
  },

  selectDropdownItem : function(id, type, clear)
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
      ViewOptions.context_id = id;
      if(clear)
      {
        ViewOptions.project_id = null;
        ViewOptions.tag_id = null;
      }
    }
    else if(type == 'project')
    {
      ViewOptions.project_id = id;
      if(clear)
      {
        ViewOptions.context_id = null;
        ViewOptions.tag_id= null;
      }
    }
    else if(type == 'tag')
    {
      ViewOptions.tag_id = id;
      if(clear)
      {
        ViewOptions.project_id = null;
        ViewOptions.context_id = null;
      }
    }
  }

});
