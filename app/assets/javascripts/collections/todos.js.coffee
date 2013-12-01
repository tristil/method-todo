#
# * @class MethodTodo.Collections.Todos
# * Represents a collection of Todos
# * @extends Backbone.View
#
class MethodTodo.Collections.Todos extends Backbone.Collection

  #
  #   * @cfg
  #   * Associated model
  #
  model: MethodTodo.Models.Todo

  #
  #   * Get back records from the server based on filter status
  #
  redraw: ->
    @fetch url: @getFilteredUrl()

  #
  #   * Construct a url based on the current filter settings
  #   * @return {String}
  #
  getFilteredUrl: ->
    parameters = []
    if MethodTodo.Globals.TodoFilter.context_id
      parameters.push "context_id=" + MethodTodo.Globals.TodoFilter.context_id
    if MethodTodo.Globals.TodoFilter.project_id
      parameters.push "project_id=" + MethodTodo.Globals.TodoFilter.project_id
    if MethodTodo.Globals.TodoFilter.tag_id
      parameters.push "tag_id=" + MethodTodo.Globals.TodoFilter.tag_id

    # If string doesn't have ? begin with it
    if @url.indexOf("?") == -1
      query_string = "?"
    else
      query_string = "&"
    if parameters.length > 0
      parameters = parameters.join("&")
      query_string += parameters
    url = @url + query_string
    @url + query_string
