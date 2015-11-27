class Colors
  # Amount should be a decimal between 0 and 1. Lower means darker
  def self.darken_color(hex_color, amount = 0.4)
    color_procedure(hex_color) do |val|
      (val.to_i * amount).round
    end
  end

  # Amount should be a decimal between 0 and 1. Higher means lighter
  def self.lighten_color(hex_color, amount = 0.6)
    color_procedure(hex_color) do |val|
      [(val.to_i + 255 * amount).round, 255].min
    end
  end

  def self.color_procedure(hex_color)
    hex_color = hex_color.gsub('#', '')
    rgb = hex_color.scan(/../).map(&:hex)
    (0..2).each do |i|
      rgb[i] = yield rgb[i]
    end
    '#%02x%02x%02x' % rgb
  end
end
