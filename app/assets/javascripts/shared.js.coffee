window.focusTodoInput = ->
  $("#todo_description").focus()

window.stopSpinner = ->
  if $("#spinner").data().spinner
    $("#spinner").data().spinner.stop()
  else
    $("#spinner").spin()
    $("#spinner").data().spinner.stop()

#
# * Get the notation symbol for a type
# * @param {String} type
# * @return {String}
#
window.getSymbolFromType = (type) ->
  if type == "project"
    "+"
  else if type == "context"
    "@"
  else "#"  if type == "tag"

window.$.fn.spin = (opts) ->
  @each ->
    $this = $(this)
    data = $this.data()
    if data.spinner
      data.spinner.stop()
      delete data.spinner
    if opts isnt false
      data.spinner = new Spinner($.extend(
        color: $this.css("color")
      , opts)).spin(this)
  this
