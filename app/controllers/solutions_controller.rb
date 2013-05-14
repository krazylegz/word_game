class SolutionsController < ApplicationController
  def create
    solution = MadLib.new(:text => params[:mad_lib_text]).solutions.create
    params[:solution].each do |label, value|
      solution.fill_field label, :with => value
    end
    @resolution = solution.resolve
  end
end
