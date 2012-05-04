require 'ice_cube'
require 'date'
class Date

  WEEKDAYS = [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
  def weekday
    #week starts on monday
    WEEKDAYS[cwday - 1]
  end
  
  def inspect
    "#{self.strftime("%Y-%m-%d")} #{weekday.to_s.capitalize}"
  end
  
end

class Thermostat

  # keeps your ice cube fresh!

  # provides a uniform way for all elements (currently only thinking of Loan and Centers) to generate a list of dates
  # this class takes care of building the specific IceCube object (in this case)
  # and allows one to easily replace IceCube with something else later
  
  # given an appropriate inititalizer, the Schedule#dates method will provide the required dates
  # it is also aware of holiday calendars (can be overridden)

  # options is a Hash with the following keys
  #
  # start_date
  # end_date
  # n
  # frequency   -> one of :daily, :weekly, :biweekly, :quadweekly, :monthly, :bimonthly, :quarterly, :semiannually 
  #                TODO: go crazy and pass a Hash of type {:period => :monthly, :every => 4}
  # days        -> WEEKDAY element(s) to constrain schedules. if not specified, defaults to start_date.weekday where appropriate
  # weekly_off  -> a WEEKDAY element
  # holidays    -> a Hash of the type {:holiday_date => :date_to_replace_with}
  #
  # one of end_date or n must be specified
  
  attr_accessor :schedule
  
  def initialize(options)
    options.keys.each do |k| 
      instance_variable_set("@#{k.to_s}", options[k])
    end
    @holidays ||= {}
    wdays = [(@days || @start_date.weekday)].flatten
    case @frequency
    when :daily
      r = {:occurence => IceCube::Rule.daily}.merge( @weekly_off ? {:exception => IceCube::Rule.daily.day(*[@weekly_off].flatten)} : {})
    when :weekly
      r = IceCube::Rule.weekly.day(*wdays)
    when :biweekly
      # IceCube's default behaviour is to go directly two weeks later
      # what we want is to take the next particular weekday and then start a biweekly cycle from there
      @start_date = next_weekday(@start_date, wdays) if @days
      r = IceCube::Rule.weekly(2).day(*wdays)
    when :quadweekly
      @start_date = next_weekday(@start_date, wdays) if @days
      r = IceCube::Rule.weekly(4).day(*wdays)
    when :monthly
      if @days.class == Hash
        r = IceCube::Rule.monthly.day_of_week(@days)
      else
        r = IceCube::Rule.monthly.day_of_month(@start_date.day)
      end
    else
      raise "Strange Frequency you got"
    end 
    @schedule = IceCube::Schedule.new(date_to_time(@start_date))
    if r.class == Hash
      @schedule.add_recurrence_rule(r[:occurence])
      @schedule.add_exception_rule(r[:exception]) if r[:exception]
    else
      @schedule.add_recurrence_rule(r)
    end
  end

  def dates
    if @end_date
      rv = @schedule.occurrences(date_to_time(@end_date)).map{|x| time_to_date(x)}
    elsif @n
      rv = @schedule.next_occurrences(@n, date_to_time(@start_date - 1)).map{|x| time_to_date(x)}
    end
    rv.map{|d| @holidays[d] || d}
  end

  # get a slice of the above dates
  # end_x is either a Date or an Integer
  def slice(start_x, end_x)
    if start_x.class == Fixnum
      if end_x.class == Fixnum
        dates[(start_x-1)..(end_x-1)]
      else
        dates[start_x-1..-1].select{|d| d <= end_x}
      end
    elsif start_x.class ==Date 
      if end_x.class == Date
        dates.select{|d| d >= start_x and d <= end_x}
      else
        dates.select{|d| d >= start_x}[0..end_x-1]
      end
    end
  end

  private
  def date_to_time(d)
    Time.parse(DateTime.new(d.year, d.month, d.day,0,0,0).to_s)
  end

  def time_to_date(t)
    Date.parse(t.to_s)
  end

  # Private - returns the next given weekday to the given date.
  # d = Date.new(2012,5,4) # Friday
  # next_weekday(d, :thursday) = Date#2012,5,10
  # next_weekday(d, :saturday) = Date#2012,5,5
  
  def next_weekday(date, weekdays)
    [weekdays].flatten.map{|wd| 
      nwd = date - date.cwday + Date::WEEKDAYS.index(wd) + 1
      nwd += 7 if nwd <= date
      nwd
    }.sort[0]
  end

end
