$(document).on "ready page:load", '', ->

  # $('form').bind 'ajax:before', (event, data, status, xhr) ->
  #   console.log "HEYY"

    $(document).on("ajax:before", 'form#new_task', (a, b, c) ->
      console.log "HOLA"
    )

$(document).bind "ajax:before", "form#new_task", (event, jqxhr, settings, exception) ->
  console.log "HOLA"
  return


