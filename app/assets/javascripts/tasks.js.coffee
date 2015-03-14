$(document).on "ready page:load", '', ->
  # chill

# Handle tasks
$(document
).on("ajax:send", "form#new_task", (event, data, status, error) ->
  $("input#task_name").val("")
  true
).on("ajax:success", "form#new_task", (event, data, status, error) ->
  $("ul#task_list").append(data)
  $("div#no-tasks-msg").hide()
  $(".best_in_place").best_in_place()
)

$(document).on("ajax:send", ".complete-task", (e)->
  container = $(this).parents("li.task")
  task_id = container.data("task-id")
  checkbox = $(this).children("i")

  container.toggleClass("task-done")
  checkbox.toggleClass("fa-square-o fa-check-square")
)

$(document).on("ajax:send", ".delete-task", (e)->
  container = $(this).parents("li.task")
  container.fadeOut ->
    container.remove()

    if $("li.task").size() == 0
      $("div#no-tasks-msg").show()
)

$(document).on("click", "#show-completed-tasks", (e)->
  $("#task_list_completed").slideToggle()

  if $(this).hasClass("less")
    $(this).removeClass("less")
    $(this).children(".action-show").show()
    $(this).children(".action-hide").hide()
  else
    $(this).addClass("less")
    $(this).children(".action-show").hide()
    $(this).children(".action-hide").show()
)


