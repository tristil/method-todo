function focusTodoInput()
{
  $('#todo_description').focus();
}

function todoChecked(checkbox)
{
  var id = parseInt(checkbox.attr('id').replace("todo-complete-", ""));
  if(checkbox.is(':checked'))
  {
    $.ajax(
      {
        type    : 'PUT',
        url     : '/todos/'+id+'/complete',
        data    : {complete : 1},
        success : function(data)
        {
          $('#todo-'+id).addClass('struck-through');
        }
      }
    );
  }
  else
  {
    $.ajax(
      {
        type    : 'PUT',
        url     : '/todos/'+id+'/complete',
        data    : {complete : 0},
        success : function(data)
        {
          $('#todo-'+id).removeClass('struck-through');
        }
      }
    );
  }
}

function openDeleteModel(delete_link)
{
  var id = parseInt(delete_link.attr('id').replace("todo-delete-", ""));
  $('#delete-todo-modal').modal('show');

  $('#close-delete-todo-modal').click(
    function(event)
    {
      $('#delete-todo-modal').modal('hide');
      return false;
    }
  );

  $('#delete-todo-button').click(
    function(event)
    {
      $.ajax(
          {
            type    : 'DELETE',
            url     : '/todos/'+id,
            success : function(data)
            {
              $('#delete-todo-modal').modal('hide');
              $('#todo-row-'+id).fadeOut('slow');
              $('#todo-row-'+id).addClass('hidden');
              focusTodoInput();
            }
          }
      );
      return false;
    }
  );
}

function refreshTodoList()
{
  $.ajax(
    {
      url   : '/todos',
      type  : 'GET',
      success : function(data)
      {
        $('#todos-list').html(data);
        $('#todo_description').val('');
        focusTodoInput();
      }
    }
  );
}

function addNewTodo()
{
  $.ajax(
    {
      url  : '/todos.json',
      type : 'POST',
      data : $('#new_todo').serialize(),
      success : function(data)
      {
        refreshTodoList();
      }
    }
  );
}


$(document).ready(
    function()
    {
      focusTodoInput();

      $(document).on('click', '.complete-checkbox',
        function(event)
        {
          var checkbox = $(event.target);
          todoChecked(checkbox);
        }
      );

      $(document).on('click', '.delete-todo-link',
        function(event)
        {
          var delete_link = $(event.target);
          openDeleteModel(delete_link)
          return false;
        }
      );

      $('#new_todo').submit(
        function(event)
        {
          addNewTodo();
          return false;
        }
      );

      $('#add-todo-button').click(
        function(event)
        {
          addNewTodo();
          return false;
        }
      );

      $('#refresh-todolist-button').click(
        function(event)
        {
          refreshTodoList();
          return false;
        }
      );
    }
);
