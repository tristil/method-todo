MethodTodo.Views.FilterHeader = Backbone.View.extend({
  el : '#filter',

  initialize : function(options)
  {
    this.parent = options.parent;
    this.refresh();
  },

  refresh : function()
  {
    if(this.parent.TodoFilter.isUnfiltered())
    {
      var message = 'Showing: All';
    }
    else
    {
      var message = "Showing: ";

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

  getFilterName: function(type, id)
  {
     var record = this.getCollectionByType(type).find(
      function(record) { return record.id == id }
      );
     return this.parent.getSymbolFromType(type) + record.get('name');
  }

});
