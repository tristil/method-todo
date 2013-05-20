/*
 * @class MethodTodo.Views.TodoFilter
 * Represents the filter at work on the page
 * @todo This isn't really a view
 * @todo A lot of this would be better done using events
 * @extends Backbone.View
 */
MethodTodo.Views.TodoFilter = Backbone.View.extend({

  /*
   * @cfg {String} DOM id to target
   */
  el : 'body',

  /*
   * @cfg {String} active|completed|tickler
   */
  status : 'active',

  /*
   * @cfg {null|Integer} Current Project Id
   */
  project_id : null,

  /*
   * @cfg {null|Integer} Current Context Id
   */
  context_id: null,

  /*
   * @cfg {null|Integer} Current Tag Id
   */
  tag_id: null,

  /*
   * @constructor
   * Create a new TodoFilter instance
   * @param {Object} options
   * @param options.parent Parent view that instiantiated this
   */
  initialize : function(options)
  {
    this.parent = options.parent;
  },

  /*
   * Redraw the page based on the filter settings
   */
  refresh : function()
  {
    this.parent.ActiveTodos.redraw();
    this.parent.CompletedTodos.redraw();
    this.parent.TicklerTodos.redraw();
    this.parent.filter_header.refresh();
  },

  /*
   * Remove all the filters and redraw the page
   */
  removeAllFilters : function()
  {
    this.context_id = null;
    this.project_id = null;
    this.tag_id = null;
    this.refresh();
  },

  /*
   * Is there no filter operating atm?
   * @return {Boolean}
   */
  isUnfiltered : function()
  {
    return this.context_id == null && this.project_id == null && this.tag_id == null;
  },

  /*
   * Set a filter value by collection type and record id
   * @param {String} type
   * @param {Integer} id
   */
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

  /*
   * Clear a filter by type
   * @param {String} type
   */
  clearFilter : function(type)
  {
    this.setValueByType(type, null);
    this.refresh();
  },

  /*
   * Apply a filter by type and id
   * @param {String} type
   * @param {Integer} id
   * @param {Boolean} clear Whether to clear out the other Dropdowns
   */
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
