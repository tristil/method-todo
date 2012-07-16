/*
 * @class MethodTodo.Views.TodoInput
 * Represents the input for adding Todos
 * @extends Backbone.View
 */
MethodTodo.Views.TodoInput = Backbone.View.extend({

  /*
   * @cfg {String} DOM id to target
   */
  el : '#add-todo-area',

  /*
   * @cfg
   * Event hookups
   */
  events : {
    'submit #new_todo'         : 'createTodo',
    'click #add-todo-button'   : 'createTodo'
  },

  /*
   * @constructor
   * Create a new TodoInput instance
   * @param {Object} options
   * @param options.parent Parent view that instiantiated this
   */
  initialize : function(options)
  {
    this.parent = options.parent;
  },

  /*
   * Respond to submit event to create a Todo
   * @param {jQuery.Event}
   */
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

  /*
   * Return focus to the input
   */
  focus : function()
  {
    $('#todo_description').focus();
  }
});
