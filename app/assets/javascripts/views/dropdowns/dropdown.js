/*
 * @class MethodTodo.Views.Dropdown
 * Represents a dropdown for Context, Project, Tag
 * @extends Backbone.View
 */
MethodTodo.Views.Dropdown = Backbone.View.extend({

  /*
   * @cfg
   * Event hookups
   */
  events : {
    'click .dropdown-item' : 'selectItem',
    'click .dropdown-reset' : 'unselectItem'
  },

  /*
   * @constructor
   * Create a new Dropdown instance
   * @param {Object} options
   * @param options.parent Parent view that instantiated this
   */
  initialize : function(options)
  {
    this.parent = options.parent;

    this.dropdown_item_template = JST['dropdowns/dropdown_item'];

    this.dropdown_type = options.dropdown_type;

    this.caret_html = "<b class='caret'></b>";

    this.dropdown_title = this.dropdown_type.replace(/^./, function(letter) { return letter.toUpperCase() }) + this.caret_html;
    this.dropdown_menu = this.$el.find('ul.dropdown-menu');

    this.collection.bind('reset', this.render, this);

    this.item_symbol = this.parent.parent.getSymbolFromType(this.dropdown_type);
  },

  /*
   * How to show this dropdown
   */
  render : function()
  {
    this.dropdown_menu.html("<li><a href='#' id='"+ this.dropdown_type +"-link-reset' class='dropdown-reset'>Any</a></li>");
    var self = this;
    this.collection.each(
      function(item)
      {
        self.dropdown_menu.append(self.dropdown_item_template(
            {item: item.toJSON(), dropdown_type : self.dropdown_type, item_symbol : self.item_symbol}
          )
        );
      }
    );
    return this;
  },

  /*
   * Responds to the click event on the dropdown
   * @param {jQuery.Event}
   */
  selectItem : function(event)
  {
    event.preventDefault();
    var title = $(event.target).text();
    this.setDropdownTitle(title);

    $('#all-todos-button-navitem').removeClass('active');
    this.$el.addClass('active').find('li').removeClass('active');
    $(event.target).parent().addClass('active');
    var id = $(event.target).attr('id').replace(this.dropdown_type+'-link-', '');

    this.parent.parent.TodoFilter.applyFilter(this.dropdown_type, id, false);
  },

  /*
   * Respond to clicking on 'Any' in dropdown
   * @param {jQuery.Event}
   */
  unselectItem : function(event)
  {
    event.preventDefault();
    this.$('a.dropdown-toggle').html(this.dropdown_title);
    this.$el.removeClass('active').find('li').removeClass('active');

    this.parent.parent.TodoFilter.clearFilter(this.dropdown_type);

    if(this.parent.parent.TodoFilter.isUnfiltered())
    {
      this.parent.selectAllButton();
    }
  },

  /*
   * Make the dropdown display as 'active'
   */
  setAsActive : function()
  {
    $('#'+this.dropdown_type+'-dropdown-navitem').addClass('active').find('li').removeClass('active');
  },

  /*
   * Select an item in the dropdown
   * @param {Integer} id Id of record in associated collection
   */
  setActiveItem : function(id)
  {
    this.$('#'+this.dropdown_type+'-link-' + id).parent().addClass('active');
  },

  /*
   * Fetch the name of an item from the associated collection, using id
   * @param {Integer} id Id of record in associated collection
   * @return {String}
   */
  getItemNameById : function(id)
  {
     var record = this.collection.find(
      function(record) { return record.id == id }
      );
     return record.get('name');
  },

  /*
   * Set title of the dropdown by id of record in associated collection
   * @param {Integer} id Id of record in associated collection
   */
  setDropdownTitleFromId : function(id)
  {
    this.setDropdownTitle(this.item_symbol + this.getItemNameById(id));
  },

  /*
   * Set title of dropdown
   * @param {String} title
   */
  setDropdownTitle : function(title)
  {
    this.$('a.dropdown-toggle').html(title + this.caret_html);
  }

});
