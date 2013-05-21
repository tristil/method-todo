#
# * @class MethodTodo.Collections.Contexts
# * Represents a collection of Contexts
# * @extends Backbone.View
#
MethodTodo.Collections.Contexts = Backbone.Collection.extend(

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
)
