MethodTodo.Views.Page = Backbone.View.extend({
  el : 'body',

  events : {
    'click .nav-tabs a' : 'switchTab'
  },

  initialize : function(initial_data)
  {
    this.initial_data = initial_data;
    focusTodoInput();
    this.help_box = new MethodTodo.Views.HelpBox();
    $('.alert').delay(1200).fadeOut('slow');

    this.setupCollections();
    this.setupViews();
    this.getGeoPosition();
  },

  setupCollections : function()
  {
    MethodTodo.Globals.ViewOptions = {};

    this.Contexts = new MethodTodo.Collections.Contexts();
    this.Projects = new MethodTodo.Collections.Projects();
    this.Tags     = new MethodTodo.Collections.Tags();

    this.ActiveTodos = new MethodTodo.Collections.Todos();
    this.ActiveTodos.url= '/todos/';

    this.CompletedTodos = new MethodTodo.Collections.Todos();
    this.CompletedTodos.url = '/todos/?completed=1';
  },

  setupViews : function()
  {
    todo_input = new MethodTodo.Views.TodoInput(
        {
          collection : this.ActiveTodos,
          parent : this
        }
    );

    todo_input.render();

    dropdowns_bar = new MethodTodo.Views.DropdownBar({parent : this});

    this.ActiveTodos.reset(this.initial_data.active_todos);
    active_todo_table = new MethodTodo.Views.TodoTable(
        {
          collection : this.ActiveTodos,
          el : '#active-todos-list',
          dropdowns_bar : dropdowns_bar,
          parent : this
        }
    );
    active_todo_table.render();

    this.CompletedTodos.reset(this.initial_data.completed_todos);
    completed_todo_table = new MethodTodo.Views.TodoTable(
        {
          collection : this.CompletedTodos,
          el : '#completed-todos-list',
          dropdowns_bar : dropdowns_bar,
          parent : this
        }
    );
    completed_todo_table.render();

    this.Contexts.reset(this.initial_data.contexts);
    context_dropdown = new MethodTodo.Views.Dropdown(
        {
          collection : this.Contexts,
          dropdown_type : 'context',
          el : '#context-dropdown-navitem',
          parent : this
        }
    );
    context_dropdown.render();

    this.Projects.reset(this.initial_data.projects);
    project_dropdown = new MethodTodo.Views.Dropdown(
        {
          collection : this.Projects,
          dropdown_type : 'project',
          el : '#project-dropdown-navitem',
          parent : this
        }
    );
    project_dropdown.render();

    this.Tags.reset(this.initial_data.tags);
    tags_dropdown = new MethodTodo.Views.Dropdown(
        {
          collection : this.Tags,
          dropdown_type : 'tag', el : '#tag-dropdown-navitem',
          parent : this
        }
    );
    tags_dropdown.render();
  },

  switchTab : function(event)
  {
    event.preventDefault();
    var tab = $(event.target);
    var target_div = tab.attr('href');
    var list_type = tab.attr('id').replace('-tab', '');
    if(list_type == 'active')
    {
      list_type = "";
    }
    $(tab).tab('show');
    focusTodoInput();
  },

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
