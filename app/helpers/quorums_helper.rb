module QuorumsHelper
  def desc_percentage(percentage)
    return '1' unless percentage && percentage > 0
    ret = "#{percentage}%"
    ret += '+1' if percentage < 100
    ret
  end
end
