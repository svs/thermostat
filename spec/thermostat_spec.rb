require File.join( File.dirname(__FILE__), "spec_helper" )

describe Thermostat do

  it "should calculate next_weekday properly" do
    @schedule = Thermostat.new(:start_date => Date.today, :end_date => Date.today+14, :frequency => :daily, :weekly_off => [:thursday, :tuesday, :saturday])
    @schedule.send(:next_weekday, Date.new(2012,5,5), :tuesday).should == Date.new(2012,5,8)
    @schedule.send(:next_weekday, Date.new(2012,5,5), :saturday).should == Date.new(2012,5,12)
    @schedule.send(:next_weekday, Date.new(2012,5,5), :sunday).should == Date.new(2012,5,6)
    @schedule.send(:next_weekday, Date.new(2012,5,5), [:saturday, :tuesday]).should == Date.new(2012,5,8)
  end

  describe "daily" do
    describe "with end date" do
      before :all do
        @sched = Thermostat.new(:start_date => Date.today, :end_date => Date.today+14, :frequency => :daily)
      end
      
      it "should give correct dates" do
        @sched.dates.should == (Date.today..Date.today+14).to_a
      end
      
      describe "with weekly off" do
        it "should deal with single weekly off" do
          @sched = Thermostat.new(:start_date => Date.today, :end_date => Date.today+14, :frequency => :daily, :weekly_off => :thursday)
          @sched.dates.should == (Date.today..Date.today+14).to_a.select{|d| d.weekday != :thursday}
        end
        
        it "should deal with multiple weekly offs" do
          @mwf = Thermostat.new(:start_date => Date.today, :end_date => Date.today+14, :frequency => :daily, :weekly_off => [:thursday, :tuesday, :saturday])
          @mwf.dates.should == (Date.today..Date.today+14).to_a.select{|d| [:monday, :wednesday, :friday,:sunday].include?d.weekday}
        end
      end
    end

    describe "with n" do
      before :all do
        @sched = Thermostat.new(:start_date => Date.today, :n => 10, :frequency => :daily)
      end
      
      it "should give correct dates" do
        @sched.dates.should == (Date.today..Date.today+9).to_a
      end
      
      describe "with weekly off" do
        it "should deal with single weekly off" do
          @sched = Thermostat.new(:start_date => Date.today, :n => 10, :frequency => :daily, :weekly_off => :thursday)
          @sched.dates.should == (Date.today..Date.today+10).to_a.select{|d| d.weekday != :thursday}
        end
        
        it "should deal with multiple weekly offs" do
          @mwf = Thermostat.new(:start_date => Date.today, :n => 10, :frequency => :daily, :weekly_off => [:thursday, :tuesday, :saturday])
          @mwf.dates.should == (Date.today..Date.today+16).to_a.select{|d| [:monday, :wednesday, :friday,:sunday].include?d.weekday}
          @mwf.dates.count.should == 10
        end
      end
    end
  end


  describe "weekly" do
    it "should give correct dates for single weekday" do
      @sched = Thermostat.new(:start_date => Date.today, :end_date => Date.today+14, :frequency => :weekly)
      @sched.dates.should == [Date.today, Date.today + 7, Date.today + 14]
    end

    it "should give correct dates for single weekday with days specified" do
      d = Date.new(2012,5,4)
      @sched = Thermostat.new(:start_date => d, :end_date => d+14, :frequency => :weekly, :days => :thursday)
      @sched.dates.should == [d + 6, d + 13]
    end

    it "should give correct dates for single weekday with days specified" do
      d = Date.new(2012,5,4) #is a Friday btw
      @sched = Thermostat.new(:start_date => d, :end_date => d+14, :frequency => :weekly, :days => [:tuesday,:thursday])
      @sched.dates.should == [d + 4, d + 6, d + 11, d + 13]
    end
  end

  describe "biweekly" do
    describe "with end date" do
      it "should give correct dates for single weekday" do
        @sched = Thermostat.new(:start_date => Date.today, :end_date => Date.today+28, :frequency => :biweekly)
        @sched.dates.should == [Date.today, Date.today + 14, Date.today + 28]
      end
      
      it "should give correct dates for single weekday with days specified" do
        d = Date.new(2012,5,4)
        @sched = Thermostat.new(:start_date => d, :end_date => d+21, :frequency => :biweekly, :days => :thursday)
        @sched.dates.should == [d + 6, d + 20]
      end
      
      it "should give correct dates for single weekday with days specified" do
        d = Date.new(2012,5,4) #is a Friday btw
        @sched = Thermostat.new(:start_date => d, :end_date => d+21, :frequency => :biweekly, :days => [:tuesday,:thursday])
        @sched.dates.should == [d + 4, d + 6, d + 18, d + 20]
      end
    end
  end

  describe "quadweekly" do
    describe "with end date" do
      it "should give correct dates for single weekday" do
        @sched = Thermostat.new(:start_date => Date.today, :end_date => Date.today+56, :frequency => :quadweekly)
        @sched.dates.should == [Date.today, Date.today + 28, Date.today + 56]
      end
      
      it "should give correct dates for single weekday with days specified" do
        d = Date.new(2012,5,4)
        @sched = Thermostat.new(:start_date => d, :end_date => d+56, :frequency => :quadweekly, :days => :thursday)
        @sched.dates.should == [d + 6, d + 34]
      end
      
      it "should give correct dates for single weekday with days specified" do
        d = Date.new(2012,5,4) #is a Friday btw
        @sched = Thermostat.new(:start_date => d, :end_date => d+56, :frequency => :quadweekly, :days => [:tuesday,:thursday])
        @sched.dates.should == [d + 4, d + 6, d + 32, d + 34]
      end
    end
  end


  describe "monthly" do
    describe "with end date" do
      it "should give correct dates for single weekday" do
        @sched = Thermostat.new(:start_date => Date.today, :end_date => Date.today+70, :frequency => :monthly)
        @sched.dates.should == [Date.today, Date.today >> 1, Date.today >> 2]
      end
      
      it "should give correct dates for single weekday with days specified" do
        d = Date.new(2012,5,4)
        @sched = Thermostat.new(:start_date => d, :end_date => d+60, :frequency => :monthly, :days => {:thursday => [2,4]})
        @sched.dates.should == [Date.new(2012,5,10), Date.new(2012,5,24), Date.new(2012,6,14), Date.new(2012,6, 28)]
      end
      
      it "should give correct dates for single weekday with days specified" do
        d = Date.new(2012,5,4) #is a Friday btw
        @sched = Thermostat.new(:start_date => d, :end_date => d+30, :frequency => :monthly, :days => {:tuesday => [1,3], :thursday => [2,4]})
        @sched.dates.should == [Date.new(2012,5,10), Date.new(2012,5,15), Date.new(2012,5,24)]
      end
    end
  end
    
  describe "holidays" do
    it "should adjust dates for holidays" do
      @sched = Thermostat.new(:start_date => Date.today, :end_date => Date.today+14, :frequency => :weekly, :holidays => {(Date.today + 7) => Date.today + 9})
      @sched.dates.should == [Date.today, Date.today + 9, Date.today + 14]
    end
  end

  describe "slice" do
    before :all do
      @schedule = Thermostat.new(:start_date => Date.new(2012,1,1), :end_date => Date.new(2013,1,1), :frequency => :biweekly, :days => :thursday)
    end

    describe "with date as start_x" do
      before :all do
        @start_x = Date.new(2012,2,1)
      end

      it "should give right results when end_x is a Fixnum" do
        @end_x = 5
        d = Date.new(2012,2,2)
        @schedule.slice(@start_x, @end_x).should == (0..4).map{|x| d + (14 * x)}
      end
      it "should give right results when end_x is a Date" do
        d = Date.new(2012,2,2)
        @end_x = d + 70
        @schedule.slice(@start_x, @end_x).should == (0..5).map{|x| d + (14 * x)}
      end
    end

    describe "with Fixnum as start_x" do
      before :all do
        @start_x = 10
      end

      it "should give right results when end_x is a Fixnum" do
        @end_x = 15
        d = Date.new(2012,1,5) + 126 
        @schedule.slice(@start_x, @end_x).should == (0..5).map{|x| d + (14 * x)}
      end
      it "should give right results when end_x is a Date" do
        d = Date.new(2012,5,10)
        @end_x = d + 70
        @schedule.slice(@start_x, @end_x).should == (0..5).map{|x| d + (14 * x)}
      end
    end
    
    
  end
    
    

end
