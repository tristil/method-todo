MethodTodo.Views.TodoFilter = Backbone.View.extend({
  el : 'body',

  status : 'active',
  project_id : null,
  context_id: null,
  tag_id: null,

  initialize : function(options)
  {
    this.parent = options.parent;
  },

  refresh : function()
  {
    this.parent.ActiveTodos.redraw();
    this.parent.CompletedTodos.redraw();
    this.parent.filter_header.refresh();
  },

  removeAllFilters : function()
  {
    this.context_id = null;
    this.project_id = null;
    this.tag_id = null;
    this.refresh();
  },

  isUnfiltered : function()
  {
    return this.context_id == null && this.project_id == null && this.tag_id == null;
  },

  setValueByType : function(type, value)
  {
    if(type == 'context')
    {
      this.context_id = value;
    }
    else if(type == 'project')
    {
      this.project_id = value;
    }
    else if(type == 'tag')
    {
      this.tag_id = value;
    }
    this.refresh();
  },

  clearFilter : function(type)
  {
    this.setValueByType(type, null);
    this.refresh();
  },

  applyFilter : function(type, id, clear)
  {
    this.parent.dropdowns_bar.deselectAllButton();

    if(clear)
    {
      this.parent.dropdowns_bar.clearAllSelections();
    }

    this.parent.dropdowns_bar.selectDropdownItem(type, id);

    if(type == 'context')
    {
      this.context_id = id;
      if(clear)
      {
        this.project_id = null;
        this.tag_id = null;
      }
    }
    else if(type == 'project')
    {
      this.project_id = id;
      if(clear)
      {
        this.context_id = null;
        this.tag_id= null;
      }
    }
    else if(type == 'tag')
    {
      this.tag_id = id;
      if(clear)
      {
        this.project_id = null;
        this.context_id = null;
      }
    }

    this.parent.dropdowns_bar.setDropdownTitle(type, id);
    this.refresh();
  }
});
