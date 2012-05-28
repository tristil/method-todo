MethodTodo.Collections.Todos = Backbone.Collection.extend({
  model: MethodTodo.Models.Todo,

  redraw : function()
  {
    this.fetch({url : this.getFilteredUrl()});
  },

  getFilteredUrl : function()
  {
    var parameters = [];

    if(ViewOptions.context_id)
    {
      parameters.push("context_id=" + ViewOptions.context_id);
    }

    if(ViewOptions.project_id)
    {
      parameters.push("project_id=" + ViewOptions.project_id);
    }

    if(ViewOptions.tag_id)
    {
      parameters.push("tag_id=" + ViewOptions.tag_id);
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
