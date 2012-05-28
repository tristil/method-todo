MethodTodo.Views.TodoTable = Backbone.View.extend({

  events : {
    'click .complete-checkbox' : 'toggleCheckbox',
    'click .todo-badge' : 'clickBadge',
    'click .edit-todo-link' : 'editTodoDescription',
    'click .todo-editor-close' : 'closeTodoEditor',
    'click .todo-editor-save' : 'clickSaveTodoEditor',
    'submit .todo-editor-form' : 'saveTodoEditorForm'
  },

  initialize : function(options)
  {
    this.dropdowns_bar = options.dropdowns_bar;

    this.table_body = this.$el.find('tbody');

    this.row_template = JST['todos/table_row'];

    this.editor_template = JST['todos/editor'];

    this.collection.bind('reset', this.render, this);
    this.collection.bind('add', this.addTodo, this);
    this.collection.bind('sync', this.updateTodoDescription, this);
  },

  toggleCheckbox : function(event)
  {
    var self = this;
    var checkbox = $(event.target);
    var id = parseInt(checkbox.attr('id').replace("todo-complete-", ""));

    var ajaxOptions = {
      type    : 'PUT',
      url     : '/todos/'+id+'/complete',
      complete : function(jqXHR, textStatus)
      {
        stopSpinner();
      }
    };

    $('#spinner').spin();

    if(checkbox.is(':checked'))
    {
      $('#todo-'+id).addClass('struck-through');
      from_collection = ActiveTodos;
      to_collection = CompletedTodos;
      ajaxOptions.data = {complete : 1};
    }
    else
    {
      from_collection = CompletedTodos;
      to_collection = ActiveTodos;
      ajaxOptions.data = {complete : 0};
    }

    todo = from_collection.find(function(todo) { return todo.id == id });

    ajaxOptions.success = function(data)
    {
      $('#todo-row-' + id).fadeOut('slow').remove();
      from_collection.remove(todo, {silent : true});
      todo.fetch(
      {
        url : '/todos/' + todo.id,
        success : function(todo)
        {
          to_collection.add(todo);
        }
      });
    };

    $.ajax(ajaxOptions);
  },

  addTodo : function(todo, collection)
  {
    this.table_body.prepend(this.row_template({todo : todo.attributes}));
  },

  render : function()
  {
    this.table_body.html('');
    var self = this;
    this.collection.each(
      function(todo)
      {
        self.table_body.append(self.row_template({todo : todo.toJSON()}))
      }
    );
    return this;
  },

  clickBadge : function(event)
  {
    event.preventDefault();
    var badge = $(event.currentTarget);
    var badge_id = _(badge.attr('class').split(/\s+/)).find(function(className) { return className != 'todo-badge' });
    var badge_type = badge_id.match(/(.*)-badge/)[1];
    var id = parseInt(badge_id.replace(badge_type + '-badge-', ''));

    this.dropdowns_bar.selectDropdownItem(id, badge_type, true);

    ActiveTodos.redraw();
    CompletedTodos.redraw();
  },

  editTodoDescription : function(event)
  {
    event.preventDefault();
    var link = $(event.currentTarget);
    var id = parseInt(link.attr('id').replace('todo-edit-', ''));
    $('#todo-' + id).hide();

    $('#todo-' + id + '-editor').html(this.editor_template({todo : {id : id, text_description : $('#todo-' + id).text()} }));
    $('#todo-' + id + '-editor').show();
    $('#todo-' + id + '-editor').focus();
  },

  closeTodoEditor : function(event)
  {
    event.preventDefault();
    var link = $(event.currentTarget);
    var id = parseInt(link.attr('id').replace('todo-close-editor-', ''));
    $('#todo-' + id + '-editor').hide();
    $('#todo-' + id).show();
  },

  clickSaveTodoEditor: function(event)
  {
    event.preventDefault();
    var link = $(event.currentTarget);
    var id = parseInt(link.attr('id').replace('todo-save-editor-', ''));
    this.saveTodoEditor(id);
  },

  saveTodoEditorForm : function(event)
  {
    event.preventDefault();
    var form = $(event.currentTarget);
    var id = parseInt(form.attr('id').replace('todo-edit-form-', ''));
    this.saveTodoEditor(id);
  },

  saveTodoEditor : function(id)
  {
    var new_description = $('#todo-' + id + '-editor input').val();
    var todo = this.collection.find(function(todo) { return todo.id == id });
    todo.set('description', new_description);
    todo.save({},{
      url : '/todos/' + todo.id,
      success : function(data)
      {
        $('#todo-' + id + '-editor').hide();
        $('#todo-' + id).show();
        $('#todo-' + id).html(todo.get('description'));
      }
    }
    );
  }

});
