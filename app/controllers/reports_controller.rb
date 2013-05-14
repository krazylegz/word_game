class ReportsController < ApplicationController
  def index
    @fields = MadLibField.count(:group => :name)
    @terms = MadLibTerm.count(:group => :name)
  end
end
