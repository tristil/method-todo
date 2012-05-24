$.fn.spin = function(opts) {
  this.each(function() {
    var $this = $(this),
  data = $this.data();

  if (data.spinner) {
    data.spinner.stop();
    delete data.spinner;
  }
  if (opts !== false) {
    data.spinner = new Spinner($.extend({color: $this.css('color')}, opts)).spin(this);
  }
  });
  return this;
};

function focusTodoInput()
{
  $('#todo_description').focus();
}

function stopSpinner()
{
  if($('#spinner').data().spinner)
  {
    $('#spinner').data().spinner.stop();
  }
  else
  {
    $('#spinner').spin();
    $('#spinner').data().spinner.stop();
  }
}

ViewOptions = {};
