#
# * @class MethodTodo.Views.Page
# * Represents the page containing other views
# * @extends Backbone.View
#
MethodTodo.Views.Page = Backbone.View.extend(

  #
  #   * @cfg {String} DOM id to target
  #
  el: "body"

  #
  #   * @cfg
  #   * Event hookups
  #
  events: {}

  #
  #   * @constructor
  #   * Create a new Page instance
  #   * @param {Object} initial_data Data for bootstrapping page
  #
  initialize: (initial_data) ->
    @initial_data = initial_data
    focusTodoInput()
    @help_box = new MethodTodo.Views.HelpBox()
    $(".alert").delay(1200).fadeOut "slow"
    @TodoFilter = new MethodTodo.Views.TodoFilter(parent: this)
    MethodTodo.Globals.TodoFilter = @TodoFilter
    @setupCollections()
    @setupViews()
    @getGeoPosition()


  #
  #   * Set up the collections
  #
  setupCollections: ->
    @Contexts = new MethodTodo.Collections.Contexts()
    @Projects = new MethodTodo.Collections.Projects()
    @Tags = new MethodTodo.Collections.Tags()
    @Contexts.reset @initial_data.contexts
    @Projects.reset @initial_data.projects
    @Tags.reset @initial_data.tags
    @ActiveTodos = new MethodTodo.Collections.Todos()
    @ActiveTodos.url = "/todos/"
    @ActiveTodos.reset @initial_data.active_todos
    @CompletedTodos = new MethodTodo.Collections.Todos()
    @CompletedTodos.url = "/todos/?completed=1"
    @CompletedTodos.reset @initial_data.completed_todos
    @TicklerTodos = new MethodTodo.Collections.Todos()
    @TicklerTodos.url = "/todos/?tickler=1"
    @TicklerTodos.reset @initial_data.tickler_todos


  #
  #   * Set up the views
  #
  setupViews: ->
    @todo_input = new MethodTodo.Views.TodoInput(
      collection: @ActiveTodos
      parent: this
    )
    @todo_input.render()
    @filter_header = new MethodTodo.Views.FilterHeader(parent: this)
    @dropdowns_bar = new MethodTodo.Views.DropdownBar(parent: this)
    @dropdowns_bar.render()
    @_setUpTabs()
    active_todo_table = new MethodTodo.Views.TodoTable(
      collection: @ActiveTodos
      el: "#active-todos-list"
      parent: this
    )
    active_todo_table.render()
    completed_todo_table = new MethodTodo.Views.TodoTable(
      collection: @CompletedTodos
      el: "#completed-todos-list"
      parent: this
    )
    completed_todo_table.render()
    tickler_todo_table = new MethodTodo.Views.TodoTable(
      collection: @TicklerTodos
      el: "#tickler-todos-list"
      parent: this
    )
    tickler_todo_table.render()

  _setUpTabs: ->
    self = this
    @tabs = new MethodTodo.Views.Tabs(el: ".nav-tabs")
    @tabs.on "switch-tab", (list_type) ->
      list_type = ""  if list_type == "active"
      focusTodoInput()
      self.TodoFilter.status = list_type
      self.filter_header.refresh()



  #
  #   * Try to get the geo position of the user and send to server, by hook or by
  #   * crook
  #
  getGeoPosition: ->
    sendPayload = (payload) ->
      $.ajax
        type: "POST"
        url: "/timezone"
        data: payload
        success: (data) ->
          self.CompletedTodos.fetch()
          self.ActiveTodos.fetch()
          self.TicklerTodos.fetch()


    geoDenied = ->
      payload = offset: new Date().getTimezoneOffset() / 60
      sendPayload payload

    self = this
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition ((position) ->
        payload =
          latitude: position.coords.latitude
          longitude: position.coords.longitude
          offset: new Date().getTimezoneOffset() / 60

        sendPayload payload
      ), geoDenied
    else
      geoDenied()
)
