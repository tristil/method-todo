#
# * @class MethodTodo.Views.Dropdown
# * Represents a dropdown for Context, Project, Tag
# * @extends Backbone.View
#
MethodTodo.Views.Dropdown = Backbone.View.extend(

  #
  #   * @cfg
  #   * Event hookups
  #
  events:
    "click .dropdown-item": "selectItem"
    "click .dropdown-reset": "unselectItem"
    "click .manage-filters": "manageFilters"


  #
  #   * @constructor
  #   * Create a new Dropdown instance
  #   * @param {Object} options
  #   * @param options.parent Parent view that instantiated this
  #
  initialize: (options) ->
    @parent = options.parent
    @dropdown_item_template = JST["dropdowns/dropdown_item"]
    @dropdown_type = options.dropdown_type
    @caret_html = "<b class='caret'></b>"
    @dropdown_title = @dropdown_type.replace(/^./, (letter) ->
      letter.toUpperCase()
    ) + @caret_html
    @dropdown_menu = @$el.find("ul.dropdown-menu")
    @collection.bind "reset", @render, this
    @item_symbol = getSymbolFromType(@dropdown_type)


  #
  #   * How to show this dropdown
  #
  render: ->
    @dropdown_menu.html "<li><a href='#' id='" + @dropdown_type + "-link-reset' class='dropdown-reset'>Any</a></li>"
    self = this
    @collection.each (item) ->
      self.dropdown_menu.append self.dropdown_item_template(
        item: item.toJSON()
        dropdown_type: self.dropdown_type
        item_symbol: self.item_symbol
      )

    self.dropdown_menu.append "<li><a href='#' id='manage-" + @dropdown_type + "s' class='manage-filters'>Manage...</a></li>"
    this


  #
  #   * Responds to the click event on the dropdown
  #   * @param {jQuery.Event}
  #
  selectItem: (event) ->
    event.preventDefault()
    title = $(event.target).text()
    @setDropdownTitle title
    $("#all-todos-button-navitem").removeClass "active"
    @$el.addClass("active").find("li").removeClass "active"
    $(event.target).parent().addClass "active"
    id = $(event.target).attr("id").replace(@dropdown_type + "-link-", "")
    @parent.parent.TodoFilter.applyFilter @dropdown_type, id, false


  #
  #   * Respond to clicking on 'Any' in dropdown
  #   * @param {jQuery.Event}
  #
  unselectItem: (event) ->
    event.preventDefault()
    @$("a.dropdown-toggle").html @dropdown_title
    @$el.removeClass("active").find("li").removeClass "active"
    @parent.parent.TodoFilter.clearFilter @dropdown_type
    @parent.selectAllButton()  if @parent.parent.TodoFilter.isUnfiltered()


  #
  #   * Respond to clicking on 'Manage...' in dropdown
  #   * @param {jQuery.Event}
  #
  manageFilters: (event) ->
    event.preventDefault()
    manage_filters_modal = new MethodTodo.Views.ManageFilterModal(
      filter_type: @dropdown_type
      parent: this
    )
    manage_filters_modal.render()


  #
  #   * Make the dropdown display as 'active'
  #
  setAsActive: ->
    $("#" + @dropdown_type + "-dropdown-navitem").addClass("active").find("li").removeClass "active"


  #
  #   * Select an item in the dropdown
  #   * @param {Integer} id Id of record in associated collection
  #
  setActiveItem: (id) ->
    @$("#" + @dropdown_type + "-link-" + id).parent().addClass "active"


  #
  #   * Fetch the name of an item from the associated collection, using id
  #   * @param {Integer} id Id of record in associated collection
  #   * @return {String}
  #
  getItemNameById: (id) ->
    record = @collection.find((record) ->
      record.id == parseInt(id)
    )
    record.get "name"


  #
  #   * Set title of the dropdown by id of record in associated collection
  #   * @param {Integer} id Id of record in associated collection
  #
  setDropdownTitleFromId: (id) ->
    @setDropdownTitle @item_symbol + @getItemNameById(id)


  #
  #   * Set title of dropdown
  #   * @param {String} title
  #
  setDropdownTitle: (title) ->
    @$("a.dropdown-toggle").html title + @caret_html
)
