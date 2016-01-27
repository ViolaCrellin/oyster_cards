# class Station
#   attr_reader :name, :zone
#
#   def initialize(name, zone)
#     @name = name
#     @zone = zone
#   end
# end

Station = Struct.new :name, :zone
