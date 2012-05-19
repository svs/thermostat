# Thermostat Gem

Thermostat keeps your IceCube humming alomg nicely.

[![Build Status](https://secure.travis-ci.org/svs/thermostat.png)](http://travis-ci.org/svs/thermostat)



It presents a declarative interface to IceCube and makes it more suitable to be called programmatically. It also has some niceties around handling holidays and so on.
Thermostat provides a uniform way to generate a list of dates. It takes care of building an IceCube object with the passed parameters.
 
given an appropriate inititalizer, the Thermostat#dates method will provide the required dates. It also adjusts dates for holidays


## Usage

call it thusly

```
@sched = Thermostat.new(:start_date => Date.today, :end_date => Date.today+14, :frequency => :weekly, :holidays => {(Date.today + 7) => Date.today + 9})
```


options are passed as a Hash with the following keys

```
start_date
end_date
n
frequency   -> one of :daily, :weekly, :biweekly, :quadweekly, :monthly, :bimonthly, :quarterly, :semiannually 
              or alternatively a Hash of {:period => :monthly, :every => 4}
days        -> WEEKDAY element(s) to constrain schedules. if not specified, defaults to start_date.weekday where appropriate
weekly_off  -> a WEEKDAY element
holidays    ->  a Hash of the type {:holiday_date => :date_to_replace_with}
```

one of end_date or n must be specified

See the specs for more usage examples



