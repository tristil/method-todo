#
# * @class MethodTodo.Views.TodoInput
# * Represents the input for adding Todos
# * @extends Backbone.View
#
class MethodTodo.Views.TodoInput extends Backbone.View

  #
  #   * @cfg {String} DOM id to target
  #
  el: "#add-todo-area"

  #
  #   * @cfg
  #   * Event hookups
  #
  events:
    "submit #new_todo": "createTodo"
    "click #add-todo-button": "createTodo"

  #
  #   * @constructor
  #   * Create a new TodoInput instance
  #   * @param {Object} options
  #   * @param options.parent Parent view that instiantiated this
  #
  initialize: (options) ->
    @parent = options.parent

  #
  #   * Respond to submit event to create a Todo
  #   * @param {jQuery.Event}
  #
  createTodo: (event) ->
    event.preventDefault()
    attributes = todo:
      description: $("#todo_description").val()

    $("#spinner").spin()
    @collection.create attributes,
      wait: true
      success: =>
        $("#todo_description").val ""
        focusTodoInput()
        stopSpinner()
        @parent.Contexts.fetch()
        @parent.Projects.fetch()
        @parent.Tags.fetch()

      error: ->
        $("#todo_description").val ""
        focusTodoInput()
        stopSpinner()
        alert "Can't create todo!"

  #
  #   * Return focus to the input
  #
  focus: ->
    $("#todo_description").focus()
