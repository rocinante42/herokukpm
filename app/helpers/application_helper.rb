module ApplicationHelper
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, messages|
      messages.each do |msg|
        concat(content_tag(:div, messages, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
          concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
          concat msg
        end)
      end
    end
    nil
  end
  def formatted_duration total_seconds
    days = (total_seconds / (60 * 60 * 24)).round
    if days > 0
      days =  days - 1
    end
    "#{days }d " if days != 0
  end
end
