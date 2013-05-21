# Namespace object for looking up Backbone objects
window.MethodTodo = {
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Globals : {}

  # Initializes the Backbone page hierarchy
  # @param {Object} initial_data Data for bootstrapping page
  init: (initial_data) ->
    page = new MethodTodo.Views.Page(initial_data)
}
