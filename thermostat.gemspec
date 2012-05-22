Gem::Specification.new do |s|
  s.name        = 'thermostat'
  s.version     = '0.1.0'
  s.date        = '2012-05-04'
  s.summary     = "Declarative interface to IceCube"
  s.description = "Build IceCube objects by passing a Hash"
  s.authors     = ["svs"]
  s.email       = 'svs@svs.io'
  s.files       = ["lib/thermostat.rb"]
  s.homepage    = 'http://github.com/svs/thermostat'

  s.add_dependency 'ice_cube'
end
