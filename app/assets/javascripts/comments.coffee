# Handle comments
$(document
).on("ajax:send", "form#new_comment", (event, data, status, error) ->
  $("textarea#comment_body").val("")
  true
).on("ajax:success", "form#new_comment", (event, data, status, error) ->
  $("div#comments").append(data)
  $("div#no-comments-msg").hide()
  $("time").timeago()
  $(".best_in_place").best_in_place()
)

$(document).on("ajax:send", ".delete-comment", (e)->
  container = $(this).parents("div.comment")
  container.fadeOut ->
    container.remove()

)
