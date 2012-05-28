MethodTodo.Views.TodoInput = Backbone.View.extend({
  el : '#add-todo-area',

  events : {
    'submit #new_todo'         : 'createTodo',
    'click #add-todo-button'   : 'createTodo'
  },

  createTodo : function(event)
  {
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
          Contexts.fetch();
          Projects.fetch();
          Tags.fetch();
        }
      }
    );
  },

  focus : function()
  {
    $('#todo_description').focus();
  }
});
