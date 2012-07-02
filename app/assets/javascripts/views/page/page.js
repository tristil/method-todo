MethodTodo.Views.Page = Backbone.View.extend({
  el : 'body',

  events : {
    'click .nav-tabs a' : 'switchTab'
  },

  initialize : function()
  {
    focusTodoInput();
    this.help_box = new MethodTodo.Views.HelpBox();
    $('.alert').delay(1200).fadeOut('slow');
  },

  switchTab : function(event)
  {
    event.preventDefault();
    var tab = $(event.target);
    var target_div = tab.attr('href');
    var list_type = tab.attr('id').replace('-tab', '');
    if(list_type == 'active')
    {
      list_type = "";
    }
    $(tab).tab('show');
    focusTodoInput();
  }
}
);
