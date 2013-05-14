class Solution
  attr_accessor :mad_lib

  def initialize(mad_lib)
    self.mad_lib = mad_lib
  end

  def fill_field(label, values)
    @hashes = self.mad_lib.hashes
    @hashes[label] = values[:with]
  end

  def resolve
    text = self.mad_lib.text
    self.mad_lib.hashes.each {|k,v| text.sub!('{' + k.split(/ \(|\)/)[0].downcase + '}', v.to_s)}
    text
  end
end
