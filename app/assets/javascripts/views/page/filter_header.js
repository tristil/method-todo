/*
 * @class MethodTodo.Views.FilterHeader
 * An area at the top of the page that displays changes in the TodoFilter
 * @extends Backbone.View
 */
MethodTodo.Views.FilterHeader = Backbone.View.extend({

  /*
   * @cfg {String} DOM id to target
   */
  el : '#filter',

  /*
   * @constructor
   * Create a new FilterHeader instance
   * @param {Object} options
   * @param options.parent Parent view that instiantiated this
   */
  initialize : function(options)
  {
    this.parent = options.parent;
    this.refresh();
  },

  /*
   * Redraw the FilterHeader
   */
  refresh : function()
  {
    if(this.parent.TodoFilter.isUnfiltered())
    {
      var message = 'Showing: All ';
      message += this.getStatusString() + " ";
    }
    else
    {
      var message = "Showing: ";
      message += this.getStatusString() + " ";

      var filters = [];
      if(this.parent.TodoFilter.context_id)
      {
        filters.push(this.getFilterName('context', this.parent.TodoFilter.context_id));
      }

      if(this.parent.TodoFilter.project_id)
      {
        filters.push(this.getFilterName('project', this.parent.TodoFilter.project_id));
      }

      if(this.parent.TodoFilter.tag_id)
      {
        filters.push(this.getFilterName('tag', this.parent.TodoFilter.tag_id));
      }

      message += filters.join(', ');
    }

    this.$el.html(message + ' Todos');
  },

  /*
   * Get operative status string, e.g. Active or Completed
   * @return {String}
   */
  getStatusString : function()
  {
    if(this.parent.TodoFilter.status == 'active')
    {
      return "Active";
    } else if(this.parent.TodoFilter.status == 'tickler') {
      return 'Tickler';
    } else {
      return "Completed";
    }
  },

  /*
   * Get a collection by its type
   * @param {String} type
   * @return {Backbone.Collection}
   */
  getCollectionByType : function(type)
  {
    if(type == 'project')
    {
      return this.parent.Projects;
    }
    else if (type == 'context')
    {
      return this.parent.Contexts;
    }
    else if(type == 'tag')
    {
      return this.parent.Tags;
    }
  },

  /*
   * Get the name of the filter for collection type and record id
   * @param {String} type
   * @param {Integer} id
   * @return {String}
   */
  getFilterName: function(type, id)
  {
     var record = this.getCollectionByType(type).find(
      function(record) { return record.id == id }
      );
     return getSymbolFromType(type) + record.get('name');
  }

});
