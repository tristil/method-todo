MethodTodo.Views.DropdownBar = Backbone.View.extend({
  el : '#dropdowns-bar',

  events : {
    'click #all-todos-button-navitem' : 'viewAllTodos'
  },

  initialize : function(options)
  {
    this.parent = options.parent;
    this.all_button = this.$('#all-todos-button-navitem');
    this.caret_html = caret_html = "<b class='caret'></b>";

    this.context_dropdown = new MethodTodo.Views.Dropdown(
        {
          collection : this.parent.Contexts,
          dropdown_type : 'context',
          el : '#context-dropdown-navitem',
          parent : this
        }
    );
    this.context_dropdown.render();

    this.project_dropdown = new MethodTodo.Views.Dropdown(
        {
          collection : this.parent.Projects,
          dropdown_type : 'project',
          el : '#project-dropdown-navitem',
          parent : this
        }
    );
    this.project_dropdown.render();

    this.tags_dropdown = new MethodTodo.Views.Dropdown(
        {
          collection : this.parent.Tags,
          dropdown_type : 'tag', el : '#tag-dropdown-navitem',
          parent : this
        }
    );
    this.tags_dropdown.render();
  },

  viewAllTodos : function()
  {
    this.resetDropdownTitles();
    this.selectAllButton();
    this.clearAllSelections();

    this.parent.TodoFilter.removeAllFilters();
  },

  resetDropdownTitles : function()
  {
    $('#project-dropdown-navitem a.dropdown-toggle').html('Project' + this.caret_html);
    $('#context-dropdown-navitem a.dropdown-toggle').html('Context' + this.caret_html);
    $('#tag-dropdown-navitem a.dropdown-toggle').html('Tag' + this.caret_html);
  },

  selectDropdownItem : function(type, id)
  {
    var dropdown = this.getDropdownByType(type);
    dropdown.setAsActive();
    dropdown.setActiveItem(id);
  },

  getDropdownByType : function(type)
  {
    if(type == 'context')
    {
      return this.context_dropdown;
    }
    else if(type == 'project')
    {
      return this.project_dropdown;
    }
    else if(type == 'tag')
    {
      return this.tags_dropdown;
    }
  },

  setDropdownTitle : function(type, id)
  {
    this.getDropdownByType(type).setDropdownTitleFromId(id);
  },

  selectAllButton : function()
  {
    this.$('#all-todos-button-navitem').addClass('active');
  },

  deselectAllButton : function()
  {
    this.$('#all-todos-button-navitem').removeClass('active');
  },

  clearAllSelections : function()
  {
    this.$('.dropdown-menu li').removeClass('active');
    this.$('.dropdown').removeClass('active');
  }

});
