#
# * @class MethodTodo.Views.Tabs
# * Represents the tabs at the top of todos table
# * @extends Backbone.View
#
MethodTodo.Views.Tabs = Backbone.View.extend(

  #
  #   * @cfg
  #   * Event hookups
  #
  events:
    "click a": "switchTab"

  initialize: ->


  #
  #   * Switch between the Active and Completed tabs
  #
  switchTab: (event) ->
    event.preventDefault()
    tab = $(event.currentTarget)
    target_div = tab.attr("href")
    list_type = tab.attr("id").replace("-tab", "")
    @trigger "switch-tab", list_type
    $(tab).tab "show"
)
