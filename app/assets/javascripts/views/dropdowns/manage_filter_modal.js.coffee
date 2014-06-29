#
# * @class MethodTodo.Views.ManageFilterModal
# * Represents a modal dialog that appears when you manage a filter
# * dropdown(Context, Project, Tag)
# * @extends Backbone.View
#
class MethodTodo.Views.ManageFilterModal extends Backbone.View

  #
  #   * @cfg {String} DOM id to target
  #
  el: "#manage-filters-modal"

  #
  #   * @cfg
  #   * Event hookups
  #
  events:
    "click #close-manage-filters-modal": "closeModal"
    "click .remove-filter-button": "removeFilter"
    "click #remove-filter-button-final": "removeFilterFinal"
    "click #cancel-filter-removal-confirmation-dialog": "cancelConfirmation"


  #
  #   * @constructor
  #   * Create a new ManageFilterModal instance
  #   * @param {Object} Options for this dialog
  #
  initialize: (options) ->
    throw "Must supply options array for ManageFilterModal"  unless typeof (options) == "object"
    throw "Must supply options.filter_type for ManageFilterModal"  unless options.filter_type
    @filter_type = options.filter_type
    throw "Must supply options.parent for ManageFilterModal"  unless options.parent
    @parent = options.parent
    @template = JST["dropdowns/manage_filters_modal"]
    @confirmation_dialog = JST["dropdowns/manage_filters_confirmation"]
    @collection = @parent.collection
    @collection.bind "reset", @render, this
    @nice_name = @filter_type.replace(/^./, (letter) ->
      letter.toUpperCase()
    )


  #
  #   * How to show this modal
  #
  render: ->
    @$el.html @template(
      filter_type: @nice_name + "s"
      filters: @collection
    )
    @$el.modal "show"


  #
  #   * Respond to click event on delete button in modal
  #   * @param {jQuery.Event}
  #
  removeFilter: (event) ->
    event.preventDefault()
    id = $(event.currentTarget).attr("id").replace("filter-item-", "")
    $("#manage-filters-confirmation").show()
    $("#main-manage-filters").hide()
    filter = @collection.find((item) ->
      item.id == parseInt(id)
    )
    $("#manage-filters-confirmation").html @confirmation_dialog(
      filter_type: @nice_name
      filter_name: filter.get("name")
      filter_id: id
    )


  #
  #   * Respond to click event on Remove All button in modal
  #   * @param {jQuery.Event}
  #
  removeFilterFinal: (event) ->
    self = this
    event.preventDefault()
    id = $(event.currentTarget).attr("filter-id")
    $.ajax
      url: "/" + @filter_type + "s/" + id
      type: "DELETE"
      data:
        id: id

      success: (data) =>
        @collection.remove(id)
        MethodTodo.Globals.TodoFilter.refresh()
        $("#manage-filters-confirmation").hide()
        $("#main-manage-filters").show()
        self.parent.parent.parent.Tags.fetch()
        self.parent.parent.parent.Projects.fetch()
        self.parent.parent.parent.Contexts.fetch()
        @render()

      error: (request, status, error) ->
        $("#manage-filters-confirmation").hide()
        $("#main-manage-filters").show()



  #
  #   * Respond to click event to close dialog without deleting anything
  #   * @param {jQuery.Event}
  #
  closeModal: (event) ->
    event.preventDefault()
    @$el.modal "hide"


  #
  #   * Respond to click event to close confirmation dialog without deleting anything
  #   * @param {jQuery.Event}
  #
  cancelConfirmation: (event) ->
    event.preventDefault()
    $("#manage-filters-confirmation").hide()
    $("#main-manage-filters").show()
