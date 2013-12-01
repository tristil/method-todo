#
# * @class MethodTodo.Collections.Tags
# * Represents a collection of Tags
# * @extends Backbone.View
#
class MethodTodo.Collections.Tags extends Backbone.Collection

  #
  #   * @cfg
  #   * Associated model
  #
  model: MethodTodo.Models.Tag

  #
  #   * @cfg
  #   * Resource URL to use
  #
  url: "/tags"
