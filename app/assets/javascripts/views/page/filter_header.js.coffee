#
# * @class MethodTodo.Views.FilterHeader
# * An area at the top of the page that displays changes in the TodoFilter
# * @extends Backbone.View
#
class MethodTodo.Views.FilterHeader extends Backbone.View

  #
  #   * @cfg {String} DOM id to target
  #
  el: "#filter"

  #
  #   * @constructor
  #   * Create a new FilterHeader instance
  #   * @param {Object} options
  #   * @param options.parent Parent view that instiantiated this
  #
  initialize: (options) ->
    @parent = options.parent
    @refresh()


  #
  #   * Redraw the FilterHeader
  #
  refresh: ->
    if @parent.TodoFilter.isUnfiltered()
      message = "Showing: All "
      message += @getStatusString() + " "
    else
      message = "Showing: "
      message += @getStatusString() + " "
      filters = []
      filters.push @getFilterName("context", @parent.TodoFilter.context_id)  if @parent.TodoFilter.context_id
      filters.push @getFilterName("project", @parent.TodoFilter.project_id)  if @parent.TodoFilter.project_id
      filters.push @getFilterName("tag", @parent.TodoFilter.tag_id)  if @parent.TodoFilter.tag_id
      message += filters.join(", ")
    @$el.html message + " Todos"


  #
  #   * Get operative status string, e.g. Active or Completed
  #   * @return {String}
  #
  getStatusString: ->
    if @parent.TodoFilter.status == "active"
      "Active"
    else if @parent.TodoFilter.status == "tickler"
      "Tickler"
    else
      "Completed"


  #
  #   * Get a collection by its type
  #   * @param {String} type
  #   * @return {Backbone.Collection}
  #
  getCollectionByType: (type) ->
    if type == "project"
      @parent.Projects
    else if type == "context"
      @parent.Contexts
    else @parent.Tags  if type == "tag"


  #
  #   * Get the name of the filter for collection type and record id
  #   * @param {String} type
  #   * @param {Integer} id
  #   * @return {String}
  #
  getFilterName: (type, id) ->
    record = @getCollectionByType(type).find((record) ->
      record.id == parseInt(id)
    )
    getSymbolFromType(type) + record.get("name")
