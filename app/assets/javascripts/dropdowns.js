var DropdownsBar = Backbone.View.extend({
  el : '#dropdowns-bar',

  events : {
    'click #all-todos-button-navitem' : 'viewAllTodos'
  },

  initialize : function()
  {
    this.all_button = this.$('#all-todos-button-navitem');
  },

  viewAllTodos : function()
  {
    var caret_html = "<b class='caret'></b>";
    $('#project-dropdown-navitem a.dropdown-toggle').html('Project' + caret_html);
    $('#context-dropdown-navitem a.dropdown-toggle').html('Context' + caret_html);
    $('#tag-dropdown-navitem a.dropdown-toggle').html('Tag' + caret_html);
    this.$('#all-todos-button-navitem').addClass('active');
    this.$('.dropdown').removeClass('active');
    this.$('.dropdown-menu li').removeClass('active');
    ViewOptions.context_id = null;
    ViewOptions.project_id = null;
    ActiveTodos.redraw();
    CompletedTodos.redraw();
  },

  selectDropdownItem : function(id, type, clear)
  {
    this.$('#all-todos-button-navitem').removeClass('active');

    if(clear)
    {
      this.$('.dropdown-menu li').removeClass('active');
      this.$('.dropdown').removeClass('active');
    }

    $('#'+type+'-dropdown-navitem').addClass('active').find('li').removeClass('active');

    $('#'+type+'-link-' + id).parent().addClass('active');

    if(type == 'context')
    {
      ViewOptions.context_id = id;
      if(clear)
      {
        ViewOptions.project_id = null;
        ViewOptions.tag_id = null;
      }
    }
    else if(type == 'project')
    {
      ViewOptions.project_id = id;
      if(clear)
      {
        ViewOptions.context_id = null;
        ViewOptions.tag_id= null;
      }
    }
    else if(type == 'tag')
    {
      ViewOptions.tag_id = id;
      if(clear)
      {
        ViewOptions.project_id = null;
        ViewOptions.context_id = null;
      }
    }
  }

});

var Dropdown = Backbone.View.extend({
  events : {
    'click .dropdown-item' : 'selectItem',
    'click .dropdown-reset' : 'unselectItem'
  },

  initialize : function(options)
  {
    this.dropdown_type = options.dropdown_type;

    this.caret_html = "<b class='caret'></b>";

    this.dropdown_title = this.dropdown_type.replace(/^./, function(letter) { return letter.toUpperCase() }) + this.caret_html;

    this.dropdown_menu = this.$el.find('ul.dropdown-menu');
    this.template = _.template($('#navitem-template').html());

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
        self.dropdown_menu.append(self.template(
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

    ActiveTodos.redraw();
    CompletedTodos.redraw();
    event.preventDefault();
  },

  setViewOptionValue : function(value)
  {
    if(this.dropdown_type == 'project')
    {
      ViewOptions.project_id = value;
    }
    else if(this.dropdown_type == 'context')
    {
      ViewOptions.context_id = value;
    }
    else if(this.dropdown_type == 'tag')
    {
      ViewOptions.tag_id = value;
    }
  },

  unselectItem : function(event)
  {
    this.$('a.dropdown-toggle').html(this.dropdown_title);
    this.$el.removeClass('active').find('li').removeClass('active');

    this.setViewOptionValue(null);

    if(ViewOptions.project_id == null && ViewOptions.context_id == null && ViewOptions.tag_id == null)
    {
      $('#all-todos-button-navitem').addClass('active');
    }

    ActiveTodos.redraw();
    CompletedTodos.redraw();
    event.preventDefault();
  }
}
);

