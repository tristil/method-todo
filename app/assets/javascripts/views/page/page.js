MethodTodo.Views.Page = Backbone.View.extend({
  el : 'body',

  initialize : function()
  {
    this.help_box = new MethodTodo.Views.HelpBox();
  }
}
);
