class FramesController < ApplicationController
  before_action :set_frame, only: %i[ show update destroy ]

  # GET /frames
  def index
    @frames = Frame.all

    render json: @frames
  end

  # GET /frames/1
  def show
    render json: @frame
  end
end
