MethodTodo.Views.DeleteTodoModal = Backbone.View.extend({
  el : '#delete-todo-modal',

  events : {
    'click #close-delete-todo-modal' : 'closeDeleteModal',
    'click #delete-todo-button' : 'deleteTodo'
  },

  initialize : function(id)
  {
    this.id = id;
    $('#delete-todo-modal').modal('show');
  },

  closeDeleteModal : function(event)
  {
    event.preventDefault();
    $('#delete-todo-modal').modal('hide');
  },

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
