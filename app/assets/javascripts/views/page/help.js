MethodTodo.Views.HelpBox = Backbone.View.extend({
  el : '#help-container',

  events : {
    'click #show-help-box' : 'showHelp',
    'click #dismiss-help' : 'dismissHelp',
  },

  initialize : function()
  {
    this.help_box = this.$('#help-box');
    this.show_help_link = this.$('#show-help-box');
  },

  toggleHelp : function()
  {
    $.ajax(
      {
        url : '/toggle_help'
      }
    );
  },


  showHelp: function(event)
  {
    event.preventDefault();
    this.help_box.show();
    this.show_help_link.hide();
    this.toggleHelp();
  },

  dismissHelp : function(event)
  {
    event.preventDefault();
    this.help_box.hide();
    this.show_help_link.show();
    this.toggleHelp();
  }
}
);
