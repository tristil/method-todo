/*
 * @class MethodTodo.Views.TodoTable
 * Represents the data table containing Todos
 * @extends Backbone.View
 */
MethodTodo.Views.TodoTable = Backbone.View.extend({

  /*
   * @cfg
   * Event hookups
   */
  events : {
    'click .complete-checkbox' : 'toggleCheckbox',
    'click .todo-badge' : 'clickBadge',
    'click .edit-todo-link' : 'editTodoDescription',
    'click .todo-editor-close' : 'closeTodoEditor',
    'click .todo-editor-save' : 'clickSaveTodoEditor',
    'click .delete-todo-link' : 'openDeleteModal',
    'click .toggle-tickler-status-link' : 'toggleTicklerStatus',
    'submit .todo-editor-form' : 'saveTodoEditorForm'
  },

  /*
   * @constructor
   * Create a new TodoTable instance
   * @param {Object} options
   * @param options.parent Parent view that instiantiated this
   */
  initialize : function(options)
  {
    this.parent = options.parent;

    this.table_body = this.$el.find('tbody');

    this.row_template = JST['todos/table_row'];

    this.editor_template = JST['todos/editor'];

    this.collection.bind('reset', this.render, this);
    this.collection.bind('add', this.addTodo, this);
    this.collection.bind('sync', this.updateTodoDescription, this);
  },

  /*
   * Respond to click event to launch DeleteTodoModal
   * @param {jQuery.Event}
   */
  openDeleteModal : function(event)
  {
    event.preventDefault();
    var delete_link = $(event.currentTarget);
    var id = parseInt(delete_link.attr('id').replace("todo-delete-", ""));
    modal = new MethodTodo.Views.DeleteTodoModal(id);
  },

  /*
   * Respond to click event to move Todo to Completed or Active status
   * @param {jQuery.Event}
   */
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
      from_collection = this.parent.ActiveTodos;
      to_collection = this.parent.CompletedTodos;
      ajaxOptions.data = {complete : 1};
    }
    else
    {
      from_collection = this.parent.CompletedTodos;
      to_collection = this.parent.ActiveTodos;
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

  /*
   * Add a Todo to the associated Collection
   * @param {MethodTodo.Models.Todo} todo
   * @param {MethodTodo.Collections.Todos} collection
   */
  addTodo : function(todo, collection)
  {
    this.table_body.prepend(this.row_template({todo : todo.attributes}));
  },

  /*
   * How to show this TodoTable
   */
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

  /*
   * Respond to click event to set filter based on clicked badge
   * @param {jQuery.Event}
   */
  clickBadge : function(event)
  {
    event.preventDefault();
    var badge = $(event.currentTarget);
    var badge_id = _(badge.attr('class').split(/\s+/)).find(
        function(className) { return className != 'todo-badge' });
    var badge_type = badge_id.match(/(.*)-badge/)[1];
    var id = parseInt(badge_id.replace(badge_type + '-badge-', ''));

    this.parent.TodoFilter.applyFilter(badge_type, id, true);
  },

  /*
   * Respond to click event to open line editor for a Todo
   * @param {jQuery.Event}
   */
  editTodoDescription : function(event)
  {
    event.preventDefault();
    var link = $(event.currentTarget);
    var id = parseInt(link.attr('id').replace('todo-edit-', ''));
    $('#todo-' + id).hide();

    $('#todo-' + id + '-editor').html(this.editor_template(
          {todo : {id : id, text_description : $('#todo-' + id).text()} }));
    $('#todo-' + id + '-editor').show();
    $('#todo-' + id + '-editor').focus();
  },

  /*
   * Respond to click event to open line editor for a Todo
   * @param {jQuery.Event}
   */
  closeTodoEditor : function(event)
  {
    event.preventDefault();
    var link = $(event.currentTarget);
    var id = parseInt(link.attr('id').replace('todo-close-editor-', ''));
    $('#todo-' + id + '-editor').hide();
    $('#todo-' + id).show();
  },

  /*
   * Respond to click event to close line editor and save changes to Todo
   * @param {jQuery.Event}
   */
  clickSaveTodoEditor: function(event)
  {
    event.preventDefault();
    var link = $(event.currentTarget);
    var id = parseInt(link.attr('id').replace('todo-save-editor-', ''));
    this.saveTodoEditor(id);
  },

  /*
   * Respond to submit event to close line editor and save changes to Todo
   * @param {jQuery.Event}
   */
  saveTodoEditorForm : function(event)
  {
    event.preventDefault();
    var form = $(event.currentTarget);
    var id = parseInt(form.attr('id').replace('todo-edit-form-', ''));
    this.saveTodoEditor(id);
  },

  /*
   * Update todo on backend
   * @param {Integer} id
   */
  saveTodoEditor : function(id)
  {
    var self = this;
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
        self.parent.Contexts.fetch();
        self.parent.Projects.fetch();
        self.parent.Tags.fetch();
      }
    }
    );
  },

  /*
   * Toggle tickler status of todo
   * @param {jQuery.Event}
   */
  toggleTicklerStatus: function(event) {
    event.preventDefault();
    var self = this;
    var id = parseInt($(event.currentTarget).attr('id').replace('todo-tickler-', ''));
    var todo = this.collection.find(function(todo) { return todo.id == id });

    $('#spinner').spin();

    todo.save({},{
      url : '/todos/' + todo.id + '/toggle_tickler_status',
      success : function(data) {
        stopSpinner();
        self.parent.TodoFilter.refresh();
      }
    });
  }
});
