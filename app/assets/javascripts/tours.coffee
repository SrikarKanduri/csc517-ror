$(document).on 'turbolinks:load', ->

  # hide the 'remove' link for the first tour_location in _form.html.erb
  $('.remove-link').first().css('display', 'none')

  $('#tour-status-select').change ->
    if this.value == "Cancelled" then alert('Cancelling a tour will delete all bookings for this tour!')
