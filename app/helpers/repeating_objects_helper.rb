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

  def reset_repeating_transactions
    #debug
    Transaction.delete_all
    Transfer.delete_all

    RepeatingTransaction.all.each do |rt|
      rt.last_occurrence_added = nil
      initialize_next_occurrence(rt)
      rt.save
    end

    RepeatingTransfer.all.each do |rt|
      rt.last_occurrence_added = nil
      initialize_next_occurrence(rt)
      rt.save
    end

  end

  def initialize_next_occurrence(repeating_object)

    #if the user moved up the start date, then reset last_occurrence_added
    if repeating_object.last_occurrence_added.present? && repeating_object.repeat_start_date > repeating_object.last_occurrence_added
      repeating_object.last_occurrence_added = nil
    end

    repeating_object.next_occurrence = recalculate_next_occurrence(repeating_object)

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

  def recalculate_next_occurrence(repeating_object)

    if repeating_object.last_occurrence_added.present?
      start_date = repeating_object.last_occurrence_added
    else
      start_date = repeating_object.repeat_start_date
    end

    if repeating_object.repeat_period == 'day'
      #for a daily repeat, the first instance will be on the start day.
      return start_date
    elsif repeating_object.repeat_period == 'week'
      #for a weekly repeat, the first instance will be on the next repeat_on_x_day_of_period weekday, between 0 and 6 days after the start day.
      #for a weekly repeat, repeat_on_x_day_of_period goes from 1 (Sunday) to 7 (Saturday).
      #Date.wday() also goes from 0 (Sunday) to 6 (Saturday). Hence the minus one.
      #add 7 to make sure the result is positive, then take mod 7 so it's not ever above 7.
      days_to_add = (7 + repeating_object.repeat_on_x_day_of_period - 1 - start_date.wday()) % 7
      return start_date + days_to_add.days
    elsif repeating_object.repeat_period == 'month'
      #for a monthly repeat, the first instance will be on the next repeat_on_x_day_of_period day of the month, between 0 and 30 days after the start day.
      #for a monthly repeat, repeat_on_x_day_of_period goes from 1 (first day of month) to 31 (last day of a 31-day month).
      start_day_day_of_the_month =  start_date.day
      days_to_add = (31 +  repeating_object.repeat_on_x_day_of_period - start_day_day_of_the_month) % 31
      return start_date + days_to_add.days
    else
      #this isn't handled. Throw an error.
      raise "Error: repeat period #{repeating_object.repeat_period} not handled in RepeatingObjectsHelper.recalculate_next_occurrence()"
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
      day_name = params_object[:on_weekday]
      repeating_object.repeat_on_x_day_of_period = get_day_number(day_name)
    elsif repeating_object.repeat_period == 'month'
      #no need to take any action. repeating_object.repeat_on_x_day_of_period is set by textbox on interface.
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