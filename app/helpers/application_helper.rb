module ApplicationHelper
  def full_title(page_title)
    base_title = "Spending Tracker"
    if(page_title.empty?)
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def swap_and_save(first, second)
    if first.order_in_list > second.order_in_list
      first.order_in_list = second.order_in_list
      second.order_in_list = first.order_in_list + 1 #if there's space in between due to deletions, move up
    else
      second.order_in_list = first.order_in_list
      first.order_in_list = second.order_in_list + 1 #if there's space in between due to deletions, move up
    end
    first.save
    second.save
  end

  def show_boolean(bool_variable)
    return "Y" if bool_variable
    "N"
  end

  def nil_to_zero(variable)
    return variable if variable.present?
    0
  end
end
