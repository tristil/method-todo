#
# * @class MethodTodo.Views.HelpBox
# * Represents the available help at the top of the screen
# * @extends Backbone.View
#
class MethodTodo.Views.HelpBox extends Backbone.View

  #
  #   * @cfg {String} DOM id to target
  #
  el: 'body'

  #
  #   * @cfg
  #   * Event hookups
  #
  events:
    "click #show-help-box": "showHelp"
    "click #dismiss-help": "dismissHelp"

  #
  #   * @constructor
  #   * Create a new HelpBox instance
  #
  initialize: (options) ->
    @help_box = @$("#help-box")
    @show_help_link = @$("#show-help-box")
    @visible = options.visible
    if @visible
      @help_box.show()
      @show_help_link.css('visibility', 'hidden')

  #
  #   * Toggle the backend preference for showing help to the user
  #
  toggleHelp: ->
    $.ajax url: "/toggle_help"

  #
  #   * Respond to click event to show the help box
  #   * @param {jQuery.Event}
  #
  showHelp: (event) ->
    event.preventDefault()
    @help_box.show()
    @show_help_link.css('visibility', 'hidden')
    @toggleHelp()

  #
  #   * Respond to click event to hide the help box
  #   * @param {jQuery.Event}
  #
  dismissHelp: (event) ->
    event.preventDefault()
    @help_box.hide()
    @show_help_link.css('visibility', 'visible')
    @toggleHelp()
