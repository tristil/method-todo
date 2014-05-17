#
# * @class MethodTodo.Views.TodoTable
# * Represents the data table containing Todos
# * @extends Backbone.View
#
class MethodTodo.Views.TodoTable extends Backbone.View

  #
  #   * @cfg
  #   * Event hookups
  #
  events:
    "click .complete-checkbox": "toggleCheckbox"
    "click .todo-badge": "clickBadge"
    "click .edit-todo-link": "editTodoDescription"
    "click .todo-editor-close": "closeTodoEditor"
    "click .todo-editor-save": "clickSaveTodoEditor"
    "click .delete-todo-link": "openDeleteModal"
    "click .toggle-tickler-status-link": "toggleTicklerStatus"
    "click span[data-todo_star]": "toggleStarredStatus"
    "mouseenter span[data-todo_star]": "fillInStar"
    "mouseleave span[data-todo_star]": "unFillStar"
    "submit .todo-editor-form": "saveTodoEditorForm"
    "sortbeforestop": "reorderTodo"

  #
  #   * @constructor
  #   * Create a new TodoTable instance
  #   * @param {Object} options
  #   * @param options.parent Parent view that instiantiated this
  #
  initialize: (options) ->
    @parent = options.parent
    @table_body = @$el.find("tbody")
    @row_template = JST["todos/table_row"]
    @editor_template = JST["todos/editor"]
    @collection.bind "reset", @render, this
    @collection.bind "sync", @render, this
    @collection.bind "remove", @render, this

  #
  #   * Respond to click event to launch DeleteTodoModal
  #   * @param {jQuery.Event}
  #
  openDeleteModal: (event) ->
    event.preventDefault()
    delete_link = $(event.currentTarget)
    id = parseInt(delete_link.attr("id").replace("todo-delete-", ""))
    modal = new MethodTodo.Views.DeleteTodoModal(id: id, collection: @collection)

  #
  #   * Respond to click event to move Todo to Completed or Active status
  #   * @param {jQuery.Event}
  #
  toggleCheckbox: (event) ->
    self = this
    checkbox = $(event.target)
    id = parseInt(checkbox.attr("id").replace("todo-complete-", ""))
    ajaxOptions =
      type: "PUT"
      url: "/todos/" + id + "/complete"
      complete: (jqXHR, textStatus) ->
        stopSpinner()

    $("#spinner").spin()
    if checkbox.is(":checked")
      $("#todo-" + id).addClass "struck-through"
      from_collection = @parent.ActiveTodos
      to_collection = @parent.CompletedTodos
      ajaxOptions.data = complete: 1
    else
      from_collection = @parent.CompletedTodos
      to_collection = @parent.ActiveTodos
      ajaxOptions.data = complete: 0
    todo = from_collection.find((todo) ->
      todo.id == id
    )
    ajaxOptions.success = (data) ->
      $("#todo-row-" + id).fadeOut("slow").remove()
      from_collection.remove todo,
        silent: true

      todo.fetch
        url: "/todos/" + todo.id
        success: (todo) ->
          to_collection.add todo

    $.ajax(ajaxOptions)

  #
  #   * Respond to sortbeforestop to change ranking of todo
  #   * @param {jQuery.Event}
  #
  reorderTodo: (event, ui) ->
    id = ui.item.data('todo_id')
    prior_todo_id = ui.item.prev().data('todo_id')
    ajaxOptions =
      type: "PUT"
      data: { prior_todo_id: prior_todo_id }
      url: "/todos/" + id + "/reorder"
      complete: (jqXHR, textStatus) ->
        stopSpinner()
      success: () ->
        return

    $("#spinner").spin()
    $.ajax(ajaxOptions)

  #
  #   * Add a Todo to the associated Collection
  #   * @param {MethodTodo.Models.Todo} todo
  #   * @param {MethodTodo.Collections.Todos} collection
  #
  addTodo: (todo, collection) ->
    @table_body.prepend @row_template(todo: todo.attributes)

  #
  #   * How to show this TodoTable
  #
  render: ->
    @table_body.html ""
    @collection.each (todo) =>
      @table_body.append @row_template(todo: todo.toJSON())
    @

  #
  #   * Respond to click event to set filter based on clicked badge
  #   * @param {jQuery.Event}
  #
  clickBadge: (event) ->
    event.preventDefault()
    badge = $(event.currentTarget)
    badge_id = _(badge.attr("class").split(/\s+/)).find((className) ->
      className isnt "todo-badge"
    )
    badge_type = badge_id.match(/(.*)-badge/)[1]
    id = parseInt(badge_id.replace(badge_type + "-badge-", ""))
    @parent.TodoFilter.applyFilter badge_type, id, true

  #
  #   * Respond to click event to open line editor for a Todo
  #   * @param {jQuery.Event}
  #
  editTodoDescription: (event) ->
    event.preventDefault()
    link = $(event.currentTarget)
    id = parseInt(link.attr("id").replace("todo-edit-", ""))
    $("#todo-" + id).hide()
    $("#todo-" + id + "-editor").html @editor_template(todo:
      id: id
      text_description: $("#todo-" + id).text()
    )
    $("#todo-" + id + "-editor").show()
    $("#todo-" + id + "-editor").focus()

  #
  #   * Respond to click event to open line editor for a Todo
  #   * @param {jQuery.Event}
  #
  closeTodoEditor: (event) ->
    event.preventDefault()
    link = $(event.currentTarget)
    id = parseInt(link.attr("id").replace("todo-close-editor-", ""))
    $("#todo-" + id + "-editor").hide()
    $("#todo-" + id).show()

  #
  #   * Respond to click event to close line editor and save changes to Todo
  #   * @param {jQuery.Event}
  #
  clickSaveTodoEditor: (event) ->
    event.preventDefault()
    link = $(event.currentTarget)
    id = parseInt(link.attr("id").replace("todo-save-editor-", ""))
    @saveTodoEditor id

  #
  #   * Respond to submit event to close line editor and save changes to Todo
  #   * @param {jQuery.Event}
  #
  saveTodoEditorForm: (event) ->
    event.preventDefault()
    form = $(event.currentTarget)
    id = parseInt(form.attr("id").replace("todo-edit-form-", ""))
    @saveTodoEditor id

  #
  #   * Update todo on backend
  #   * @param {Integer} id
  #
  saveTodoEditor: (id) ->
    self = this
    new_description = $("#todo-" + id + "-editor input").val()
    todo = @collection.find((todo) ->
      todo.id == parseInt(id)
    )
    todo.set "description", new_description
    todo.save {},
      url: "/todos/" + todo.id
      success: (data) ->
        $("#todo-" + id + "-editor").hide()
        $("#todo-" + id).show()
        $("#todo-" + id).html todo.get("description")
        self.parent.Contexts.fetch()
        self.parent.Projects.fetch()
        self.parent.Tags.fetch()

  #
  #   * Toggle tickler status of todo
  #   * @param {jQuery.Event}
  #
  toggleTicklerStatus: (event) ->
    event.preventDefault()
    todo = @getTodoFromElement(event.currentTarget)
    $("#spinner").spin()
    todo.save {},
      url: "/todos/" + todo.id + "/toggle_tickler_status"
      success: (data) =>
        stopSpinner()
        @parent.TodoFilter.refresh()

  #
  #   * Toggle starred status of todo
  #   * @param {jQuery.Event}
  #
  toggleStarredStatus: (event) ->
    event.preventDefault()
    todo = @getTodoFromElement(event.currentTarget)
    todo.starred = !todo.starred
    $("#spinner").spin()
    todo.save {},
      url: "/todos/" + todo.id + "/toggle_starred_status"
      success: (data) =>
        stopSpinner()
        @parent.TodoFilter.refresh()

  fillInStar: (event) ->
    todo = @getTodoFromElement(event.currentTarget)
    return if todo.get('starred')
    $(event.currentTarget).removeClass('glyphicon-star-empty')
    $(event.currentTarget).addClass('glyphicon-star')

  unFillStar: (event) ->
    todo = @getTodoFromElement(event.currentTarget)
    return if todo.get('starred')
    $(event.currentTarget).removeClass('glyphicon-star')
    $(event.currentTarget).addClass('glyphicon-star-empty')

  getTodoFromElement: (element) ->
    id = $(element).parentsUntil('[data-todo_id]').parent().data('todo_id')
    @collection.get(id)
