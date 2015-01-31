$(document).on "ready page:load", '', ->
  # chill

# Handle tasks
$(document
).on("ajax:send", "form#new_task", (event, data, status, error) ->
  $("input#task_name").val("")
  true
).on("ajax:success", "form#new_task", (event, data, status, error) ->
  console.log("HUH?")
  $("ul#task_list").append data
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
  container.fadeOut("")
)
