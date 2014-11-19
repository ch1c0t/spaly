$ ->
  $('p').text ''

  $('input').on 'input', ->
    input = $(@).val()

    if input.length == 0
      $('p').text ''
    else
      $('p').text "Привет, #{input}!"
