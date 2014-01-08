class Parser

  def self.convert(chars_dict, phonetics_dict)
    entries = File.read(chars_dict).lines.map { |x| x.split[1] }.uniq
    File.write(phonetics_dict, entries.join("\n") + "\n")
  end

  def initialize(phonetics_dict = 'phonetics.dict')
    @entries = File.read(phonetics_dict).lines.map { |p| p.strip }

    # Sort by length to prioritize longer token
    @entries.sort_by! { |x| x.length }.reverse!
  end

  def parse(input, partial = [], &block)
    if input.empty?
      block.call(partial)
      return
    end

    parts = input.split("'")

    return parts.map { |p| parse(p) }.flatten unless parts.length == 1

    @entries.each do |token|
      if input[0...token.length] == token
        parse(input[token.length...input.length], partial + [token], &block)
      end
    end
  end

end
