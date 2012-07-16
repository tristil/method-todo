/*
 * @class MethodTodo.Views.DropdownBar
 * Represents the bar containing Dropdowns
 * @extends Backbone.View
 */
MethodTodo.Views.DropdownBar = Backbone.View.extend({

  /*
   * @cfg {String} DOM id to target
   */
  el : '#dropdowns-bar',

  /*
   * @cfg
   * Event hookups
   */
  events : {
    'click #all-todos-button-navitem' : 'viewAllTodos'
  },

  /*
   * @constructor
   * Create a new DropdownBar instance
   * @param {Object} options
   * @param options.parent Parent view that instiantiated this
   */
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

  /*
   * Reset filter to show all Todos
   */
  viewAllTodos : function()
  {
    this.resetDropdownTitles();
    this.selectAllButton();
    this.clearAllSelections();

    this.parent.TodoFilter.removeAllFilters();
  },

  /*
   * Reset titles of the attached Dropdowns
   */
  resetDropdownTitles : function()
  {
    $('#project-dropdown-navitem a.dropdown-toggle').html('Project' + this.caret_html);
    $('#context-dropdown-navitem a.dropdown-toggle').html('Context' + this.caret_html);
    $('#tag-dropdown-navitem a.dropdown-toggle').html('Tag' + this.caret_html);
  },

  /*
   * Select a dropdown item by collection type and record id
   * @param {String} type
   * @param {Integer} id
   */
  selectDropdownItem : function(type, id)
  {
    var dropdown = this.getDropdownByType(type);
    dropdown.setAsActive();
    dropdown.setActiveItem(id);
  },

  /*
   * Get the dropdown corresponding to the collection type
   * @param {String} type
   * @return {Backbone.Collection}
   */
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

  /*
   * Set the dropdown title based on collection type and record id
   * @param {String} type
   * @param {Integer} id
   */
  setDropdownTitle : function(type, id)
  {
    this.getDropdownByType(type).setDropdownTitleFromId(id);
  },

  /*
   * Mark the All button as 'active'
   */
  selectAllButton : function()
  {
    this.$('#all-todos-button-navitem').addClass('active');
  },

  /*
   * Unmark the All button as 'active'
   */
  deselectAllButton : function()
  {
    this.$('#all-todos-button-navitem').removeClass('active');
  },

  /*
   * Clear all the selections from attached dropdowns
   */
  clearAllSelections : function()
  {
    this.$('.dropdown-menu li').removeClass('active');
    this.$('.dropdown').removeClass('active');
  }

});
