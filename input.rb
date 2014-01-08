require_relative 'parser'

string = 'ngo\'keisatgokdakzejatcedousihojizaudik'

parser = Parser.new

parser.parse(string).each do |p| puts p.join("'") end