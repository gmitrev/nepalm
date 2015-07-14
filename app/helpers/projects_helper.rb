module ProjectsHelper
  def disk_usage_progress_bar_color(percentage)
    case
    when percentage > 90
      'danger'
    when percentage > 70
      'warning'
    else
      'success'
    end
  end
end
