var Todo = Backbone.Model;

var TodoList = Backbone.Collection.extend({
  model : Todo,

  redraw : function()
  {
    this.fetch({url : this.getFilteredUrl()});
  },

  getFilteredUrl : function()
  {
    var parameters = [];

    if(ViewOptions.context_id)
    {
      parameters.push("context_id=" + ViewOptions.context_id);
    }

    if(ViewOptions.project_id)
    {
      parameters.push("project_id=" + ViewOptions.project_id);
    }

    if(ViewOptions.tag_id)
    {
      parameters.push("tag_id=" + ViewOptions.tag_id);
    }

    if(this.url.indexOf('?') == -1)
    {
      query_string = "?";
    }
    else
    {
      query_string = "&";
    }

    if(parameters.length > 0)
    {
      parameters = parameters.join("&");
      query_string += parameters;
    }
    var url = this.url + query_string;

    return this.url + query_string;
  }
}
);

var TodoInput = Backbone.View.extend({
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

var TodoTable = Backbone.View.extend({
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
    this.template = _.template($('#todo-table-row-template').html());

    this.editor_template = _.template($('#todo-editor-template').html());

    this.collection.bind('reset', this.render, this);
    this.collection.bind('add', this.addTodo, this);
    this.collection.bind('sync', this.updateTodoDescription, this);
  },

  toggleCheckbox : function(event)
  {
    var checkbox = $(event.target);
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
      todo = ActiveTodos.find(function(todo) { return todo.id == id });

      ajaxOptions.data = { complete : 1};
      ajaxOptions.success = function(data)
      {
        $('#todo-'+id).addClass('struck-through');
        $('#todo-row-' + id).fadeOut('slow').remove();
        ActiveTodos.remove(todo, {silent : true});
        todo.set('completed', true);
        CompletedTodos.add(todo);
      };
    }
    else
    {
      todo = CompletedTodos.find(function(todo) { return todo.id == id });

      ajaxOptions.data = { complete : 0};
      ajaxOptions.success = function(data)
      {
        $('#todo-row-' + id).fadeOut('slow').remove();
        CompletedTodos.remove(todo, {silent : true});
        todo.set('completed', false);
        ActiveTodos.add(todo);
      };
    }
    $.ajax(ajaxOptions);
  },

  addTodo : function(todo, collection)
  {
    this.table_body.prepend(this.template({todo : todo.attributes}))
  },

  render : function()
  {
    this.table_body.html('');
    var self = this;
    this.collection.each(
      function(todo)
      {
        self.table_body.append(self.template({todo : todo.toJSON()}))
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

ActiveTodos = new TodoList();
ActiveTodos.url= '/todos/';

CompletedTodos = new TodoList();
CompletedTodos.url = '/todos/?completed=1';
