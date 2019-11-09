module RepeatingObjectsHelper

  def days_of_week
    {"Sunday" => 1, "Monday" => 2, "Tuesday" => 3, "Wednesday" => 4, "Thursday" => 5, "Friday" => 6, "Saturday" => 7 }
  end

  def get_day_number(day_name)
    days_of_week[day_name.capitalize]
  end

  def get_day_name(day_number)
    days_of_week.key(day_number)
  end

  def repeat_description(repeat_object)
    ro = repeat_object
    if ro.repeat_every_x_periods > 1
      every_x_periods = " #{ro.repeat_every_x_periods}"
    else
      every_x_periods = ""
    end

    repeat_text = "every#{every_x_periods} #{ro.repeat_period.pluralize(ro.repeat_every_x_periods)}"
    if ro.repeat_period == "week"
      repeat_text += " on #{get_day_name(ro.repeat_on_x_day_of_period)}"
    elsif ro.repeat_period == "month"
      repeat_text += " on day #{ro.repeat_on_x_day_of_period} of the month"
    end
    repeat_text
  end

  def end_description(repeat_object)
    ro = repeat_object
    if ro.end_type == 'num-occurrences'
      end_text = "after #{ro.ends_after_num_occurrences} occurrences"
    elsif ro.end_type == 'end-date'
      end_text = "after #{display_date(ro.ends_after_date)}"
    else
      end_text = 'never'
    end
    end_text
  end

  def reinitialize_next_occurrence(repeating_object)

    #if the user moved up the start date, then set next occurrence = the new start date
    if repeating_object.last_occurrence_added.nil? || repeating_object.repeat_start_date > repeating_object.last_occurrence_added
      repeating_object.next_occurrence = repeating_object.repeat_start_date
    else
      if repeating_object.is_a?(RepeatingTransaction)
        klass = RepeatingTransaction
      elsif repeating_object.is_a?(RepeatingTransfer)
        klass = RepeatingTransfer
      else
        raise "error: repeating object type #{repeating_object.class} was not recognized."
      end
      #reset the next occurrence only if they changed the repeat start date
      previous_repeat_start_date = klass.find(repeating_object.id).repeat_start_date
      if previous_repeat_start_date != repeating_object.repeat_start_date
        repeating_object.next_occurrence = repeating_object.repeat_start_date
        repeating_object.last_occurrence_added = nil
      else
        #step back to the previous occurrence, then use that to reset the next occurrence.
        repeating_object.next_occurrence = repeating_object.last_occurrence_added
        increment_next_occurrence(repeating_object)
      end
    end
  end

  def check_and_create_repeat_instances()
    check_repeating_objects(current_user.repeating_transactions)
    check_repeating_objects(current_user.repeating_transfers)
  end

  def check_repeating_objects(repeating_objects)
    current_date = get_current_time.change(hour: 0)
    repeating_objects.each do |ro|
      changed = false
      while (ro.next_occurrence.present? && ro.next_occurrence <= current_date) do
        ro.create_instance()
        increment_next_occurrence(ro)
        changed = true
      end
      ro.save if changed #to save the last_occurrence_added and next_occurrence
    end
  end

  def increment_next_occurrence(repeating_obj)
    if repeating_obj.next_occurrence.nil?
      #the next_occurrence has been set to nil.
      #we've already been through here, and the next date was after the end of the repeats.
      #so, return nil.
      return
    else
      start = repeating_obj.next_occurrence
      next_date = add_repeat_period_to_date(start, repeating_obj.repeat_period, repeating_obj.repeat_every_x_periods)

      if repeating_obj.ends_after_date.present?
        #next occurrence is after the end date, so there is no next occurrence
        if next_date > repeating_obj.ends_after_date
          repeating_obj.next_occurrence = nil
          return
        end
      end

      if repeating_obj.ends_after_num_occurrences.present?
        max_periods = repeating_obj.repeat_every_x_periods * repeating_obj.ends_after_num_occurrences
        #DEBUG
        #not sure if I can use repeat_start_date directly, or if I need to calculate the actual first occurrence.
        if next_date >= add_repeat_period_to_date(repeating_obj.repeat_start_date, repeating_obj.repeat_period, max_periods)
          repeating_obj.next_occurrence = nil
          return
        end
      end

      repeating_obj.next_occurrence = next_date
    end
  end

  def add_repeat_period_to_date(start_date,repeat_period_string, number_of_periods)
    if repeat_period_string == 'day'
      next_date = start_date + (number_of_periods).days
    elsif repeat_period_string == 'week'
      next_date = start_date + (number_of_periods * 7).days
    elsif repeat_period_string == 'month'
      next_date = start_date + (number_of_periods).months
    else
      #this isn't handled. Throw an error.
      raise "Error: repeat period #{repeat_period_string} not handled in RepeatingObjectsHelper.add_repeat_period_to_date()"
    end
    next_date
  end

  def set_repeat_period(repeating_object, params_object)
    if repeating_object.repeat_period == 'day'
      repeating_object.repeat_on_x_day_of_period = nil
    elsif repeating_object.repeat_period == 'week'
      #add 1 because wday goes from zero (Sunday) to 6 (Saturday) and we want it to go 1 to 7.
      repeating_object.repeat_on_x_day_of_period = repeating_object.repeat_start_date.wday + 1
    elsif repeating_object.repeat_period == 'month'
      repeating_object.repeat_on_x_day_of_period = repeating_object.repeat_start_date.day
    else
      raise "error: repeating object repeat period '#{repeating_object.repeat_period}' was not handled."
    end
  end

  def set_end_type(repeating_object, params_object)
    end_type = params_object[:end_type]
    if end_type == 'never'
      repeating_object.ends_after_num_occurrences = nil
      repeating_object.ends_after_date = nil
    elsif end_type == 'num-occurrences'
      repeating_object.ends_after_date = nil
    elsif end_type == 'end-date'
      repeating_object.ends_after_num_occurrences = nil
    else
      raise "error: repeating object end type '#{end_type}' was not handled."
    end
  end

end