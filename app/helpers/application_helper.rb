module ApplicationHelper

  def bootstrap_class_for(flash_type)
    case flash_type
    when "success"
      "alert-success"
    when "error"
      "alert-danger"
    when "alert"
      "alert-danger"
    when "notice"
      "alert-success"
    else
      flash_type.to_s
    end
  end

  def errors_for(obj)
    if obj.errors.any?

    end
  end
end
