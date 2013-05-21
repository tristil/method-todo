#
# * @class MethodTodo.Views.DropdownBar
# * Represents the bar containing Dropdowns
# * @extends Backbone.View
#
MethodTodo.Views.DropdownBar = Backbone.View.extend(

  #
  #   * @cfg {String} DOM id to target
  #
  el: "#dropdowns-bar"

  #
  #   * @cfg
  #   * Event hookups
  #
  events:
    "click #all-todos-button-navitem": "viewAllTodos"


  #
  #   * @constructor
  #   * Create a new DropdownBar instance
  #   * @param {Object} options
  #   * @param options.parent Parent view that instiantiated this
  #
  initialize: (options) ->
    @parent = options.parent
    @all_button = @$("#all-todos-button-navitem")
    @caret_html = caret_html = "<b class='caret'></b>"
    @context_dropdown = new MethodTodo.Views.Dropdown(
      collection: @parent.Contexts
      dropdown_type: "context"
      el: "#context-dropdown-navitem"
      parent: this
    )
    @context_dropdown.render()
    @project_dropdown = new MethodTodo.Views.Dropdown(
      collection: @parent.Projects
      dropdown_type: "project"
      el: "#project-dropdown-navitem"
      parent: this
    )
    @project_dropdown.render()
    @tags_dropdown = new MethodTodo.Views.Dropdown(
      collection: @parent.Tags
      dropdown_type: "tag"
      el: "#tag-dropdown-navitem"
      parent: this
    )
    @tags_dropdown.render()


  #
  #   * Reset filter to show all Todos
  #
  viewAllTodos: ->
    @resetDropdownTitles()
    @selectAllButton()
    @clearAllSelections()
    @parent.TodoFilter.removeAllFilters()


  #
  #   * Reset titles of the attached Dropdowns
  #
  resetDropdownTitles: ->
    $("#project-dropdown-navitem a.dropdown-toggle").html "Project" + @caret_html
    $("#context-dropdown-navitem a.dropdown-toggle").html "Context" + @caret_html
    $("#tag-dropdown-navitem a.dropdown-toggle").html "Tag" + @caret_html


  #
  #   * Select a dropdown item by collection type and record id
  #   * @param {String} type
  #   * @param {Integer} id
  #
  selectDropdownItem: (type, id) ->
    dropdown = @getDropdownByType(type)
    dropdown.setAsActive()
    dropdown.setActiveItem id


  #
  #   * Get the dropdown corresponding to the collection type
  #   * @param {String} type
  #   * @return {Backbone.Collection}
  #
  getDropdownByType: (type) ->
    if type == "context"
      @context_dropdown
    else if type == "project"
      @project_dropdown
    else @tags_dropdown  if type == "tag"


  #
  #   * Set the dropdown title based on collection type and record id
  #   * @param {String} type
  #   * @param {Integer} id
  #
  setDropdownTitle: (type, id) ->
    @getDropdownByType(type).setDropdownTitleFromId id


  #
  #   * Mark the All button as 'active'
  #
  selectAllButton: ->
    @$("#all-todos-button-navitem").addClass "active"


  #
  #   * Unmark the All button as 'active'
  #
  deselectAllButton: ->
    @$("#all-todos-button-navitem").removeClass "active"


  #
  #   * Clear all the selections from attached dropdowns
  #
  clearAllSelections: ->
    @$(".dropdown-menu li").removeClass "active"
    @$(".dropdown").removeClass "active"
)
