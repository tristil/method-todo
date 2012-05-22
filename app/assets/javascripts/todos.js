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

$(document).ready(
    function()
    {
      focusTodoInput();

      $(document).on('click', '.delete-todo-link',
        function(event)
        {
          var delete_link = $(event.target);
          openDeleteModel(delete_link)
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

          $(tab).tab('show');
          return false;
        }
      );

      $('.alert').delay(1200).fadeOut('slow');
    }
);
