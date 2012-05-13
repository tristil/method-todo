function todoChecked(checkbox)
{
  var id = parseInt(checkbox.attr('id').replace("todo-complete-", ""));
  if(checkbox.is(':checked'))
  {
    $.ajax(
      {
        type    : 'PUT',
        url     : '/todos/'+id+'/complete',
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
            }
          }
      );
      return false;
    }
  );
}


$(document).ready(
    function()
    {
      $('.complete-checkbox').click(
        function(event)
        {
          var checkbox = $(event.target);
          todoChecked(checkbox);
        }
      );

      $('.delete-todo-link').click(
        function(event)
        {
          var delete_link = $(event.target);
          openDeleteModel(delete_link)
          return false;
        }
      );
    }
);
