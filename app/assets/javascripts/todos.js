$.fn.spin = function(opts) {
  this.each(function() {
    var $this = $(this),
  data = $this.data();

  if (data.spinner) {
    data.spinner.stop();
    delete data.spinner;
  }
  if (opts !== false) {
    data.spinner = new Spinner($.extend({color: $this.css('color')}, opts)).spin(this);
  }
  });
  return this;
};

function focusTodoInput()
{
  $('#todo_description').focus();
}

function stopSpinner()
{
  if($('#spinner').data().spinner)
  {
    $('#spinner').data().spinner.stop();
  }
  else
  {
    $('#spinner').spin();
    $('#spinner').data().spinner.stop();
  }
}

function todoChecked(checkbox)
{
  var id = parseInt(checkbox.attr('id').replace("todo-complete-", ""));

  var ajaxOptions = {
    type    : 'PUT',
    url     : '/todos/'+id+'/complete',
    data    : {complete : 1},
    complete : function(jqXHR, textStatus)
    {
      stopSpinner();
    }
  };

  $('#spinner').spin();

  if(checkbox.is(':checked'))
  {
    ajaxOptions.data = { complete : 1};
    ajaxOptions.success = function(data)
    {
      $('#todo-'+id).addClass('struck-through');
      $('#todo-row-' + id).fadeOut('slow').remove();
    };
  }
  else
  {
    ajaxOptions.data = { complete : 0};
    ajaxOptions.success = function(data)
    {
      $('#todo-'+id).removeClass('struck-through');
    }
  }
  $.ajax(ajaxOptions);
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
      $('#spinner').spin();

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
            },
            complete : function(jqXHR, textStatus)
            {
              stopSpinner();
            }
          }
      );
      return false;
    }
  );
}

function refreshTodoList(list_type)
{
  if(typeof list_type == 'undefined')
  {
    list_type = 'active';
  }

  if(list_type == 'active')
  {
    list_url = '';
  }
  else
  {
    list_url = list_type;
  }

  $('#spinner').spin();
  $.ajax(
    {
      url   : '/todos/' + list_url,
      type  : 'GET',
      success : function(data)
      {
        $('#'+ list_type +'-todos-list').html(data);
        $('#todo_description').val('');
        focusTodoInput();
      },
      complete : function(jqXHR, textStatus)
      {
        stopSpinner();
      }
    }
  );
}

function addNewTodo()
{
  $('#spinner').spin();
  $.ajax(
    {
      url  : '/todos.json',
      type : 'POST',
      data : $('#new_todo').serialize(),
      success : function(data)
      {
        refreshTodoList();
      },
      complete : function(jqXHR, textStatus)
      {
        stopSpinner();
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

      $('#new_todo').on('submit',
        function(event)
        {
          addNewTodo();
          event.preventDefault();
          return false;
        }
      );

      $(document).on('click', '#add-todo-button',
        function(event)
        {
          addNewTodo();
          return false;
        }
      );

      $(".nav-tabs a").on('click',
        function(event)
        {
          var tab = $(event.target);

          var target_div = $(this).attr('href');
          var list_type = $(this).attr('id').replace('-tab', '');
          if(list_type == 'active')
          {
            list_type = "";
          }

          $('#spinner').spin();

          $.ajax(
            {
              url : '/todos/' + list_type,
              success : function(data)
              {
                $(target_div).html(data);
                $(tab).tab('show');
                stopSpinner();
              }
            }
          );
        }
      );

      $('.alert').delay(1200).fadeOut('slow');
    }
);
