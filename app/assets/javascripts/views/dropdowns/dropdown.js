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

    if(this.dropdown_type == 'project')
    {
      this.item_symbol = '+';
    }
    else if(this.dropdown_type == 'context')
    {
      this.item_symbol = '@';
    }
    else if(this.dropdown_type == 'tag')
    {
      this.item_symbol = '#';
    }
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

  selectItem : function(event)
  {
    this.$('a.dropdown-toggle').html($(event.target).text() + this.caret_html);
    $('#all-todos-button-navitem').removeClass('active');
    this.$el.addClass('active').find('li').removeClass('active');
    $(event.target).parent().addClass('active');
    var id = $(event.target).attr('id').replace(this.dropdown_type+'-link-', '');

    this.setViewOptionValue(id);

    this.parent.ActiveTodos.redraw();
    this.parent.CompletedTodos.redraw();
    event.preventDefault();
  },

  setViewOptionValue : function(value)
  {
    if(this.dropdown_type == 'project')
    {
      MethodTodo.Globals.ViewOptions.project_id = value;
    }
    else if(this.dropdown_type == 'context')
    {
      MethodTodo.Globals.ViewOptions.context_id = value;
    }
    else if(this.dropdown_type == 'tag')
    {
      MethodTodo.Globals.ViewOptions.tag_id = value;
    }
  },

  unselectItem : function(event)
  {
    this.$('a.dropdown-toggle').html(this.dropdown_title);
    this.$el.removeClass('active').find('li').removeClass('active');

    this.setViewOptionValue(null);

    if(MethodTodo.Globals.ViewOptions.project_id == null && MethodTodo.Globals.ViewOptions.context_id == null && MethodTodo.Globals.ViewOptions.tag_id == null)
    {
      $('#all-todos-button-navitem').addClass('active');
    }

    this.parent.ActiveTodos.redraw();
    this.parent.CompletedTodos.redraw();
    event.preventDefault();
  }

});
