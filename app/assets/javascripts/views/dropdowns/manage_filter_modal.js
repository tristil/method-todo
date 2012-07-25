/*
 * @class MethodTodo.Views.ManageFilterModal
 * Represents a modal dialog that appears when you manage a filter
 * dropdown(Context, Project, Tag)
 * @extends Backbone.View
 */
MethodTodo.Views.ManageFilterModal = Backbone.View.extend({

  /*
   * @cfg {String} DOM id to target
   */
  el : '#manage-filters-modal',

  /*
   * @cfg
   * Event hookups
   */
  events : {
    'click #close-manage-filters-modal' : 'closeModal',
  },

  /*
   * @constructor
   * Create a new ManageFilterModal instance
   * @param {Object} Options for this dialog
   */
  initialize : function(options)
  {
    if(typeof(options) != 'object')
    {
      throw "Must supply options array for ManageFilterModal";
    }

    if(!options.filter_type)
    {
      throw "Must supply options.filter_type for ManageFilterModal";
    }
    this.filter_type = options.filter_type;

    if(!options.parent)
    {
      throw "Must supply options.parent for ManageFilterModal";
    }
    this.parent = options.parent;
    this.template = JST['dropdowns/manage_filters_modal'];
    this.collection = this.parent.collection;
  },

  /*
   * How to show this modal
   */
  render : function()
  {
    var nice_name = this.filter_type.replace(
        /^./,
        function(letter) { return letter.toUpperCase() }) + 's';

    this.$el.html(this.template({
      filter_type : nice_name,
      filters     : this.collection
    }));

    this.$el.modal('show');
  },

  /*
   * Respond to click event to close dialog without deleting anything
   * @param {jQuery.Event}
   */
  closeModal : function(event)
  {
    event.preventDefault();
    this.$el.modal('hide');
  }
}
);
