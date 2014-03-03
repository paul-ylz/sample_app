# Ex 10.5.7 Add a js display for the home page to count down from 140 chars.

updateCountdown = -> 
  remaining = 140 - jQuery('#micropost_content').val().length
  jQuery('#micropost_countdown').text(remaining + ' characters remaining.')

jQuery ->
    updateCountdown()
    $('#micropost_content').change updateCountdown
    $('#micropost_content').keyup updateCountdown