class MadLibsController < ApplicationController
  def new ; end

  def create
    @mad_lib = MadLib.new(params[:mad_lib])
  end
end
