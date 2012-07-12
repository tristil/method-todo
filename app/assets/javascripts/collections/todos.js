MethodTodo.Collections.Todos = Backbone.Collection.extend({
  model: MethodTodo.Models.Todo,

  redraw : function()
  {
    this.fetch({url : this.getFilteredUrl()});
  },

  getFilteredUrl : function()
  {
    var parameters = [];

    if(MethodTodo.Globals.TodoFilter.context_id)
    {
      parameters.push("context_id=" + MethodTodo.Globals.TodoFilter.context_id);
    }

    if(MethodTodo.Globals.TodoFilter.project_id)
    {
      parameters.push("project_id=" + MethodTodo.Globals.TodoFilter.project_id);
    }

    if(MethodTodo.Globals.TodoFilter.tag_id)
    {
      parameters.push("tag_id=" + MethodTodo.Globals.TodoFilter.tag_id);
    }

    if(this.url.indexOf('?') == -1)
    {
      query_string = "?";
    }
    else
    {
      query_string = "&";
    }

    if(parameters.length > 0)
    {
      parameters = parameters.join("&");
      query_string += parameters;
    }
    var url = this.url + query_string;

    return this.url + query_string;
  }
}
);
