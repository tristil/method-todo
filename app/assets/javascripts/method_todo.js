/*
 * Namespace object for looking up Backbone objects
 */
window.MethodTodo = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  Globals : {},
  init: function(initial_data) {
    page = new MethodTodo.Views.Page(initial_data);
  }
};
