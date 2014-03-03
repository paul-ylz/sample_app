# Ex 10.5.7 Add a js display for the home page to count down from 140 chars.
updateMicropostCountdown = -> 
  remaining = 140 - jQuery('#micropost_content').val().length
  jQuery('#micropost_countdown').text(remaining + ' characters remaining.')

jQuery ->
    updateMicropostCountdown()
    $('#micropost_content').change updateMicropostCountdown
    $('#micropost_content').keyup updateMicropostCountdown