module RepeatingObjectsHelper

  def initialize_next_occurrence(repeating_object)
    repeating_object.next_occurrence = recalculate_next_occurrence(repeating_object)
  end

  def check_and_create__repeat_instances(user)
    check_repeating_objects(user.repeating_transactions)
    check_repeating_objects(user.repeating_transfers)
  end

  def check_repeating_objects(repeating_objects)
    repeating_objects.each do |ro|
      next_date = find_next_occurrence(ro)
      while next_date.present? do
        ro.create_instance(next_date)
        next_date = find_next_occurrence(ro)
      end
    end
  end

  def find_next_occurrence(repeating_obj)
    if repeating_obj.last_occurrence_added.nil?
      #this is the first time we're
      return(get_initialized_next_occurrence(ro))
    end

    if self.next_occurrence.nil?
      #this object isn't new, but the next_occurrence has been set to nil.
      #we've already been through here, and the next date was after the end of the repeats.
      #so, return nil.
      return nil
    else
      start = repeating_obj.next_occurrence
      next_date = add_repeat_period_to_date(start, repeating_obj.repeat_period, repeating_obj.repeat_every_x_periods)

      if ends_after_date.present?
        #next occurrence is after the end date, so there is no next occurrence
        if next_date > ends_after_date
          return nil
        end
      end

      if ends_after_num_occurrences.present?
        max_periods = repeating_obj.repeat_every_x_periods * repeating_obj.ends_after_num_occurrences
        if next_date > add_repeat_period_to_date(start, repeating_obj.repeat_period, max_periods)
          return nil
        end
      end

      return next_date
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
    elsif repeat_period_string == 'week'
      #for a weekly repeat, the first instance will be on the next repeat_on_x_day_of_period weekday, between 0 and 6 days after the start day.
      #for a weekly repeat, repeat_on_x_day_of_period goes from 1 (Sunday) to 7 (Saturday).
      #Date.cwday() also goes from 1 (Sunday) to 7 (Saturday).
      #add 7 to make sure the result is positive, then take mod 7 so it's not ever above 7.
      days_to_add = (7 + repeating_object.repeat_on_x_day_of_period - start_date.cwday()) % 7
      return start_date + days_to_add
    elsif repeat_period_string == 'month'
      #for a monthly repeat, the first instance will be on the next repeat_on_x_day_of_period day of the month, between 0 and 30 days after the start day.
      #for a monthly repeat, repeat_on_x_day_of_period goes from 1 (first day of month) to 31 (last day of a 31-day month).
      start_day_day_of_the_month =  start_date.day
      days_to_add = (31 +  repeat_on_x_day_of_period - start_day_day_of_the_month) % 31
      return start_date + days_to_add
    else
      #this isn't handled. Throw an error.
      raise "Error: repeat period #{repeat_period_string} not handled in RepeatingObjectsHelper.get_initialized_next_occurrence()"
    end
  end

  def add_repeat_period_to_date(start_date,repeat_period_string, number_of_periods)
    if repeat_period_string == 'day'
      next_date = start_date + (number_of_periods * 1)
    elsif repeat_period_string == 'week'
      next_date = start_date + (number_of_periods * 7)
    elsif repeat_period_string == 'month'
      next_date = start_date + (number_of_periods.months)
    else
      #this isn't handled. Throw an error.
      raise "Error: repeat period #{repeat_period_string} not handled in RepeatingObjectsHelper.add_repeat_period_to_date()"
    end
    next_date
  end

end