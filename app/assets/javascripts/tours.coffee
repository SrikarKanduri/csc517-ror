$(document).on 'turbolinks:load', ->

  # hide the 'remove' link for the first tour_location in _form.html.erb
  $('.remove-link').first().css('display', 'none')

  $('#tour-status-select').change ->
    if this.value == "Cancelled" then alert('Cancelling a tour will delete all bookings for this tour!')

  $('#book_form').submit ->
    available_seats = $(this).data('seats')
    desired_seats = $('#book_tour_select').val()

    if desired_seats <= available_seats then return true
    if available_seats == 0 then $('#waitlist_amt').val(desired_seats)
    if $('#waitlist_amt').val() then return true

    overbooked = desired_seats - available_seats
    $('#book_dialog').prepend('<p>You have overbooked this tour by ' + overbooked + ' seats. Would you like to waitlist these seats?</p>')
    $('#book_dialog').dialog('option', 'buttons', {
      Cancel: ->
        $('#book_dialog p').remove()
        $(this).dialog("close")
      Submit: ->
        selected = $("input[type='radio'][name='book_options']:checked").val()
        if selected == 'no_waitlist' then $('#waitlist_amt').val('0')
        if selected == 'waitlist_some' then $('#waitlist_amt').val(overbooked)
        if selected == 'waitlist_all' then $('#waitlist_amt').val(desired_seats)
        $('#book_form').submit()
        $(this).dialog("close")
    })
    $('#book_dialog').dialog('open')
    return false

  $('#book_dialog').dialog({
    dialogClass: "no-close",
    autoOpen: false,
    resizable: false,
    height: 300,
    width: 500,
    modal: true
  })

  $('#cancel_seats_dialog').dialog({
    autoOpen: false,
    resizable: false,
    height: "auto",
    width: 400,
    modal: true,
    buttons: {
      Submit: ->
        $('#seats_to_cancel').val($('#cancel_seats_select').val())
        $('#update_book_form').submit()
        $(this).dialog("close")
    }
  })

  $('#update_book_form').submit ->
    if $('#seats_to_cancel').val() then return true
    $('#cancel_seats_dialog').dialog('open')
    return false