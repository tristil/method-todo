/*
 * @class MethodTodo.Views.DeleteTodoModal
 * Represents a modal dialog that appears when you select to delete a Todo
 * @extends Backbone.View
 */
MethodTodo.Views.DeleteTodoModal = Backbone.View.extend({

  /*
   * @cfg {String} DOM id to target
   */
  el : '#delete-todo-modal',

  /*
   * @cfg
   * Event hookups
   */
  events : {
    'click #close-delete-todo-modal' : 'closeDeleteModal',
    'click #delete-todo-button' : 'deleteTodo'
  },

  /*
   * @constructor
   * Create a new DeleteTodoModal instance
   * @param {Integer} id Id of the Todo record that is to be deleted
   */
  initialize : function(id)
  {
    this.id = id;
    $('#delete-todo-modal').modal('show');
  },

  /*
   * Respond to click event to close dialog without deleting anything
   * @param {jQuery.Event}
   */
  closeDeleteModal : function(event)
  {
    event.preventDefault();
    $('#delete-todo-modal').modal('hide');
  },

  /*
   * Respond to click event to delete Todo and close dialog
   * @param {jQuery.Event}
   */
  deleteTodo : function(event)
  {
    event.preventDefault();
    $('#spinner').spin();
    var self = this;

    $.ajax(
        {
          type    : 'DELETE',
          url     : '/todos/'+this.id,
          success : function(data)
          {
            $('#delete-todo-modal').modal('hide');
            $('#todo-row-'+ self.id).fadeOut('slow');
            $('#todo-row-'+ self.id).addClass('hidden');
            focusTodoInput();
          },
          complete : function(jqXHR, textStatus)
          {
            stopSpinner();
          }
        }
    );
  }
}
);
