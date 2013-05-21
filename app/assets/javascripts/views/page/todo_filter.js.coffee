#
# * @class MethodTodo.Views.TodoFilter
# * Represents the filter at work on the page
# * @todo This isn't really a view
# * @todo A lot of this would be better done using events
# * @extends Backbone.View
#
MethodTodo.Views.TodoFilter = Backbone.View.extend(

  #
  #   * @cfg {String} DOM id to target
  #
  el: "body"

  #
  #   * @cfg {String} active|completed|tickler
  #
  status: "active"

  #
  #   * @cfg {null|Integer} Current Project Id
  #
  project_id: null

  #
  #   * @cfg {null|Integer} Current Context Id
  #
  context_id: null

  #
  #   * @cfg {null|Integer} Current Tag Id
  #
  tag_id: null

  #
  #   * @constructor
  #   * Create a new TodoFilter instance
  #   * @param {Object} options
  #   * @param options.parent Parent view that instiantiated this
  #
  initialize: (options) ->
    @parent = options.parent


  #
  #   * Redraw the page based on the filter settings
  #
  refresh: ->
    @parent.ActiveTodos.redraw()
    @parent.CompletedTodos.redraw()
    @parent.TicklerTodos.redraw()
    @parent.filter_header.refresh()


  #
  #   * Remove all the filters and redraw the page
  #
  removeAllFilters: ->
    @context_id = null
    @project_id = null
    @tag_id = null
    @refresh()


  #
  #   * Is there no filter operating atm?
  #   * @return {Boolean}
  #
  isUnfiltered: ->
    not @context_id? and not @project_id? and not @tag_id?


  #
  #   * Set a filter value by collection type and record id
  #   * @param {String} type
  #   * @param {Integer} id
  #
  setValueByType: (type, value) ->
    if type == "context"
      @context_id = value
    else if type == "project"
      @project_id = value
    else @tag_id = value  if type == "tag"
    @refresh()


  #
  #   * Clear a filter by type
  #   * @param {String} type
  #
  clearFilter: (type) ->
    @setValueByType type, null
    @refresh()


  #
  #   * Apply a filter by type and id
  #   * @param {String} type
  #   * @param {Integer} id
  #   * @param {Boolean} clear Whether to clear out the other Dropdowns
  #
  applyFilter: (type, id, clear) ->
    @parent.dropdowns_bar.deselectAllButton()
    @parent.dropdowns_bar.clearAllSelections()  if clear
    @parent.dropdowns_bar.selectDropdownItem type, id
    if type == "context"
      @context_id = id
      if clear
        @project_id = null
        @tag_id = null
    else if type == "project"
      @project_id = id
      if clear
        @context_id = null
        @tag_id = null
    else if type == "tag"
      @tag_id = id
      if clear
        @project_id = null
        @context_id = null
    @parent.dropdowns_bar.setDropdownTitle type, id
    @refresh()
)
