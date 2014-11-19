$ ->
  stream = new EventSource '/sse'
  stream.onmessage = (event) ->
    data = JSON.parse event.data

    switch data.type
      when 'update'
        $('#' + data.id).html data.html

      when 'execute'
        eval data.js
