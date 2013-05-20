/*
 * @class MethodTodo.Views.Tabs
 * Represents the tabs at the top of todos table
 * @extends Backbone.View
 */
MethodTodo.Views.Tabs = Backbone.View.extend({
  /*
   * @cfg
   * Event hookups
   */
  events : {
    'click a' : 'switchTab'
  },

  initialize: function() {
  },

  /*
   * Switch between the Active and Completed tabs
   */
  switchTab : function(event)
  {
    event.preventDefault();
    var tab = $(event.currentTarget);
    var target_div = tab.attr('href');
    var list_type = tab.attr('id').replace('-tab', '');
    this.trigger('switch-tab', list_type);
    $(tab).tab('show');
  }

});
