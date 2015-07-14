module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
    when 'success'
      'alert-success' # Green
    when 'error'
      'alert-danger' # Red
    when 'alert'
      'alert-danger' # Red
    when 'notice'
      'alert-info' # Blue
    else
      flash_type.to_s
    end
  end

  # Button for forms without an object
  def button(name, loading_text = 'Saving...')
    button_tag name, class: 'btn btn-theme', data: { disable_with: raw("<i class='fa fa-circle-o-notch fa-spin'></i> #{loading_text}") }
  end

  # Button for object forms
  def form_button_for(obj, name = nil)
    name ||= obj.object.new_record? ? 'Create' : 'Update'

    obj.button name, class: 'btn btn-theme', data: { disable_with: raw("<i class='fa fa-circle-o-notch fa-spin'></i> Saving...") }
  end
end
