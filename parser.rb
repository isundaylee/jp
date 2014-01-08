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

  def parse(input, partial = [])
    return [partial] if input.empty?

    parts = input.split("'")

    if parts.length > 1
      first = parse(parts.first, [])
      second = parse(parts[1...parts.length].join("'"))

      return first.product(second).collect { |x, y| x + y }
    end

    results = []

    @entries.each do |token|
      if input[0...token.length] == token
        results += parse(input[token.length...input.length], partial + [token])
      end
    end

    results
  end

end
