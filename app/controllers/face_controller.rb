class FaceController < ApplicationController
  
  def index

    if params[:image_url]
      @image_source = params[:image_url]
      @face_detected = face_detect(@image_source)
    end

  end

end