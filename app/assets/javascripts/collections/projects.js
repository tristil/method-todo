/*
 * @class MethodTodo.Collections.Contexts
 * Represents a collection of Contexts
 * @extends Backbone.View
 */
MethodTodo.Collections.Projects = Backbone.Collection.extend({

  /*
   * @cfg
   * Associated model
   */
  model: MethodTodo.Models.Project,

  /*
   * @cfg
   * Resource URL to use
   */
  url   : '/projects'

});
