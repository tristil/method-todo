#
# * @class MethodTodo.Views.DeleteTodoModal
# * Represents a modal dialog that appears when you select to delete a Todo
# * @extends Backbone.View
#
class MethodTodo.Views.DeleteTodoModal extends Backbone.View

  #
  #   * @cfg {String} DOM id to target
  #
  el: "#delete-todo-modal"

  #
  #   * @cfg
  #   * Event hookups
  #
  events:
    "click #close-delete-todo-modal": "_onClickCloseModal"
    "click #delete-todo-button": "deleteTodo"

  #
  #   * @constructor
  #   * Create a new DeleteTodoModal instance
  #   * @param {Integer} id Id of the Todo record that is to be deleted
  #
  initialize: (options) ->
    @id = options.id
    @$el.modal "show"

  #
  #   * Respond to click event to close dialog without deleting anything
  #   * @param {jQuery.Event}
  #
  closeModal: ->
    @$el.modal "hide"
    @undelegateEvents()

  #
  #   * Respond to click event to delete Todo and close dialog
  #   * @param {jQuery.Event}
  #
  deleteTodo: (event) ->
    event.preventDefault()
    $("#spinner").spin()
    $.ajax
      type: "DELETE"
      url: "/todos/#{@id}.json"
      success: (data) =>
        @collection.remove(@id)
        @closeModal()
        focusTodoInput()

      complete: (jqXHR, textStatus) ->
        stopSpinner()

  _onClickCloseButton: (event) ->
    event.preventDefault()
    @closeModal()
