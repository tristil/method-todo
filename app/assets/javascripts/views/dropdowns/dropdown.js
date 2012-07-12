MethodTodo.Views.Dropdown = Backbone.View.extend({

  events : {
    'click .dropdown-item' : 'selectItem',
    'click .dropdown-reset' : 'unselectItem'
  },

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

  setAsActive : function()
  {
    $('#'+this.dropdown_type+'-dropdown-navitem').addClass('active').find('li').removeClass('active');
  },

  setActiveItem : function(id)
  {
    this.$('#'+this.dropdown_type+'-link-' + id).parent().addClass('active');
  },

  selectItem : function(event)
  {
    var title = $(event.target).text();
    this.setDropdownTitle(title);

    $('#all-todos-button-navitem').removeClass('active');
    this.$el.addClass('active').find('li').removeClass('active');
    $(event.target).parent().addClass('active');
    var id = $(event.target).attr('id').replace(this.dropdown_type+'-link-', '');

    this.parent.parent.TodoFilter.applyFilter(this.dropdown_type, id, false);
    event.preventDefault();
  },

  getItemNameById : function(id)
  {
     var record = this.collection.find(
      function(record) { return record.id == id }
      );
     return record.get('name');
  },

  setDropdownTitleFromId : function(id)
  {
    this.setDropdownTitle(this.item_symbol + this.getItemNameById(id));
  },

  setDropdownTitle : function(title)
  {
    this.$('a.dropdown-toggle').html(title + this.caret_html);
  },

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
  }

});
