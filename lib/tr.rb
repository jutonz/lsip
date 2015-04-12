class TR
  def initialize(tr)
    @mac  = tr[0].text
    @ip   = tr[1].text
    @name = tr[2].text
  end

  def to_s
    "#{@ip}   #{@name}"
  end
end