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
    'click .remove-filter-button' : 'removeFilter',
    'click #cancel-filter-removal-confirmation-dialog' : 'cancelConfirmation'
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
    this.confirmation_dialog = JST['dropdowns/manage_filters_confirmation'];
    this.collection = this.parent.collection;

    this.nice_name = this.filter_type.replace(
        /^./,
        function(letter) { return letter.toUpperCase() });

  },

  /*
   * How to show this modal
   */
  render : function()
  {
    this.$el.html(this.template({
      filter_type : this.nice_name + 's',
      filters     : this.collection
    }));

    this.$el.modal('show');
  },

  /*
   * Respond to click event on delete button in modal
   * @param {jQuery.Event}
   */
  removeFilter : function(event)
  {
    event.preventDefault();
    var id = $(event.currentTarget).attr('id').replace('filter-item-', '');
    $('#manage-filters-confirmation').show();
    $('#main-manage-filters').hide();

    var filter = this.collection.find(function(item) { return item.id == id } );

    $('#manage-filters-confirmation').html(this.confirmation_dialog(
      {filter_type : this.nice_name, filter_name : filter.get('name'), filter_id : id}
    ));
  },

  /*
   * Respond to click event to close dialog without deleting anything
   * @param {jQuery.Event}
   */
  closeModal : function(event)
  {
    event.preventDefault();
    this.$el.modal('hide');
  },

  /*
   * Respond to click event to close confirmation dialog without deleting anything
   * @param {jQuery.Event}
   */
  cancelConfirmation : function(event)
  {
    event.preventDefault();
    $('#manage-filters-confirmation').hide();
    $('#main-manage-filters').show();
  }
}
);
