window.MethodTodo = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  init: function(initial_data) {

    Contexts = new MethodTodo.Collections.Contexts();
    Projects = new MethodTodo.Collections.Projects();
    Tags     = new MethodTodo.Collections.Tags();

    ActiveTodos = new MethodTodo.Collections.Todos();
    ActiveTodos.url= '/todos/';

    CompletedTodos = new MethodTodo.Collections.Todos();
    CompletedTodos.url = '/todos/?completed=1';

    ViewOptions = {};

    page = new MethodTodo.Views.Page();

    todo_input = new MethodTodo.Views.TodoInput({collection : ActiveTodos});
    todo_input.render();

    dropdowns_bar = new MethodTodo.Views.DropdownBar();

    ActiveTodos.reset(initial_data.active_todos);
    active_todo_table = new MethodTodo.Views.TodoTable({collection : ActiveTodos, el : '#active-todos-list', dropdowns_bar : dropdowns_bar });
    active_todo_table.render();

    CompletedTodos.reset(initial_data.completed_todos);
    completed_todo_table = new MethodTodo.Views.TodoTable({collection : CompletedTodos, el : '#completed-todos-list', dropdowns_bar : dropdowns_bar });
    completed_todo_table.render();

    Contexts.reset(initial_data.contexts);
    context_dropdown = new MethodTodo.Views.Dropdown({collection : Contexts, dropdown_type : 'context', el : '#context-dropdown-navitem'});
    context_dropdown.render();

    Projects.reset(initial_data.projects);
    project_dropdown = new MethodTodo.Views.Dropdown({collection : Projects, dropdown_type : 'project', el : '#project-dropdown-navitem'})
    project_dropdown.render();

    Tags.reset(initial_data.tags);
    tags_dropdown = new MethodTodo.Views.Dropdown({collection : Tags, dropdown_type : 'tag', el : '#tag-dropdown-navitem'})
    tags_dropdown.render();
  }
};
