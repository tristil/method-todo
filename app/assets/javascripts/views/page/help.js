/*
 * @class MethodTodo.Views.HelpBox
 * Represents the available help at the top of the screen
 * @extends Backbone.View
 */
MethodTodo.Views.HelpBox = Backbone.View.extend({

  /*
   * @cfg {String} DOM id to target
   */
  el : '#help-container',

  /*
   * @cfg
   * Event hookups
   */
  events : {
    'click #show-help-box' : 'showHelp',
    'click #dismiss-help' : 'dismissHelp',
  },

  /*
   * @constructor
   * Create a new HelpBox instance
   */
  initialize : function()
  {
    this.help_box = this.$('#help-box');
    this.show_help_link = this.$('#show-help-box');
  },

  /*
   * Toggle the backend preference for showing help to the user
   */
  toggleHelp : function()
  {
    $.ajax(
      {
        url : '/toggle_help'
      }
    );
  },

  /*
   * Respond to click event to show the help box
   * @param {jQuery.Event}
   */
  showHelp: function(event)
  {
    event.preventDefault();
    this.help_box.show();
    this.show_help_link.hide();
    this.toggleHelp();
  },

  /*
   * Respond to click event to hide the help box
   * @param {jQuery.Event}
   */
  dismissHelp : function(event)
  {
    event.preventDefault();
    this.help_box.hide();
    this.show_help_link.show();
    this.toggleHelp();
  }
}
);
