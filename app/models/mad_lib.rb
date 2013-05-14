# == Schema Information
#
# Table name: mad_libs
#
#  id   :integer          not null, primary key
#  text :text
#

class MadLib < ActiveRecord::Base
  attr_accessible :text
  attr_accessor :solutions, :hashes

  after_initialize do |mad_lib|
    self.hashes = Hash.new
    mad_lib.text.to_s.scan(/{(.*?)}/).flatten.inject(Hash.new(0)) {|h, (k, v)| h[k.capitalize] = h[k.capitalize] + 1 ; h}.each {|k,v| v.times {|i| self.hashes[k + ' (' + (i + 1).to_s + '):'] = nil}} # This may be a bit much.
    self.solutions = SolutionSet.new(mad_lib)
  end

  def has_field?(field)
    self.hashes.has_key? field
  end
end
