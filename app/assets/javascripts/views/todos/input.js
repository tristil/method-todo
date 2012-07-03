MethodTodo.Views.TodoInput = Backbone.View.extend({
  el : '#add-todo-area',

  events : {
    'submit #new_todo'         : 'createTodo',
    'click #add-todo-button'   : 'createTodo'
  },

  initialize : function(options)
  {
    this.parent = options.parent;
  },

  createTodo : function(event)
  {
    var self = this;
    event.preventDefault();
    var attributes = {
      todo : {
        description : $('#todo_description').val()
      }
    };
    $('#spinner').spin();
    this.collection.create(
      attributes,
      {
        wait : true,
        success : function()
        {
          $('#todo_description').val('');
          focusTodoInput();
          stopSpinner();
          self.parent.Contexts.fetch();
          self.parent.Projects.fetch();
          self.parent.Tags.fetch();
        }
      }
    );
  },

  focus : function()
  {
    $('#todo_description').focus();
  }
});
