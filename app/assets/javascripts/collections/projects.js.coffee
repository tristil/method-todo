#
# * @class MethodTodo.Collections.Contexts
# * Represents a collection of Contexts
# * @extends Backbone.View
#
class MethodTodo.Collections.Projects extends Backbone.Collection

  #
  #   * @cfg
  #   * Associated model
  #
  model: MethodTodo.Models.Project

  #
  #   * @cfg
  #   * Resource URL to use
  #
  url: "/projects"
