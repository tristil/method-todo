/*
 * @class MethodTodo.Views.Page
 * Represents the page containing other views
 * @extends Backbone.View
 */
MethodTodo.Views.Page = Backbone.View.extend({

  /*
   * @cfg {String} DOM id to target
   */
  el : 'body',

  /*
   * @cfg
   * Event hookups
   */
  events : {
  },

  /*
   * @constructor
   * Create a new Page instance
   * @param {Object} initial_data Data for bootstrapping page
   */
  initialize : function(initial_data)
  {
    this.initial_data = initial_data;
    focusTodoInput();
    this.help_box = new MethodTodo.Views.HelpBox();
    $('.alert').delay(1200).fadeOut('slow');

    this.TodoFilter = new MethodTodo.Views.TodoFilter({parent : this});
    MethodTodo.Globals.TodoFilter = this.TodoFilter;
    this.setupCollections();
    this.setupViews();
    this.getGeoPosition();
  },

  /*
   * Set up the collections
   */
  setupCollections : function() { this.Contexts = new MethodTodo.Collections.Contexts(); this.Projects = new MethodTodo.Collections.Projects(); this.Tags     = new MethodTodo.Collections.Tags();
    this.Contexts.reset(this.initial_data.contexts);
    this.Projects.reset(this.initial_data.projects);
    this.Tags.reset(this.initial_data.tags);

    this.ActiveTodos = new MethodTodo.Collections.Todos();
    this.ActiveTodos.url= '/todos/';
    this.ActiveTodos.reset(this.initial_data.active_todos);

    this.CompletedTodos = new MethodTodo.Collections.Todos();
    this.CompletedTodos.url = '/todos/?completed=1';
    this.CompletedTodos.reset(this.initial_data.completed_todos);

    this.TicklerTodos = new MethodTodo.Collections.Todos();
    this.TicklerTodos.url = '/todos/?tickler=1';
    this.TicklerTodos.reset(this.initial_data.tickler_todos);
  },

  /*
   * Set up the views
   */
  setupViews : function()
  {
    this.todo_input = new MethodTodo.Views.TodoInput(
        {
          collection : this.ActiveTodos,
          parent : this
        }
    );
    this.todo_input.render();

    this.filter_header = new MethodTodo.Views.FilterHeader({parent : this});

    this.dropdowns_bar = new MethodTodo.Views.DropdownBar({parent : this});
    this.dropdowns_bar.render();

    this._setUpTabs();

    active_todo_table = new MethodTodo.Views.TodoTable(
        {
          collection : this.ActiveTodos,
          el : '#active-todos-list',
          parent : this
        }
    );
    active_todo_table.render();

    completed_todo_table = new MethodTodo.Views.TodoTable(
        {
          collection : this.CompletedTodos,
          el : '#completed-todos-list',
          parent : this
        }
    );
    completed_todo_table.render();

    tickler_todo_table = new MethodTodo.Views.TodoTable(
        {
          collection : this.TicklerTodos,
          el : '#tickler-todos-list',
          parent : this
        }
    );
    tickler_todo_table.render();

  },

  _setUpTabs: function() {
    var self = this;
    this.tabs = new MethodTodo.Views.Tabs({el: '.nav-tabs'});

    this.tabs.on('switch-tab', function(list_type) {
      if(list_type == 'active')
      {
        list_type = "";
      }
      focusTodoInput();
      self.TodoFilter.status = list_type;
      self.filter_header.refresh();
    });
  },

  /*
   * Try to get the geo position of the user and send to server, by hook or by
   * crook
   */
  getGeoPosition : function()
  {
    var sendPayload = function(payload)
    {
      $.ajax(
        {
          type : 'POST',
          url : '/timezone',
          data : payload,
          success : function(data)
          {
            self.CompletedTodos.fetch();
            self.ActiveTodos.fetch();
            self.TicklerTodos.fetch();
          }
        }
      );
    };

    var geoDenied = function()
    {
      var payload = {
        offset : new Date().getTimezoneOffset() / 60
      };

      sendPayload(payload);
    }

    var self = this;
    if (navigator.geolocation)
    {
      navigator.geolocation.getCurrentPosition(
      function(position)
      {
        var payload= {
          latitude : position.coords.latitude,
          longitude : position.coords.longitude,
          offset : new Date().getTimezoneOffset() / 60
        };

        sendPayload(payload);
      }, geoDenied
      );
    }
    else
    {
      geoDenied();
    }
  }
}
);
