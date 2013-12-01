#
# * @class MethodTodo.Collections.Contexts
# * Represents a collection of Contexts
# * @extends Backbone.View
#
class MethodTodo.Collections.Contexts extends Backbone.Collection

  #
  #   * @cfg
  #   * Associated model
  #
  model: MethodTodo.Models.Context

  #
  #   * @cfg
  #   * Resource URL to use
  #
  url: "/contexts"
