class UrlsController < ApplicationController
    def new
      @url = Url.new
    end
  
    def create
      @url = Url.new(url_params)
      @url.short_url = SecureRandom.hex(4) # Generate a unique short URL
  
      if @url.save
        redirect_to url_path(@url), notice: "Short URL created successfully!"
      else
        flash.now[:alert] = "Failed to create short URL."
        render :new
      end
    end
  
    def show
      @url = Url.find(params[:id])
    end
  
    def redirect
      url = Url.find_by(short_url: params[:short_url])
      if url
        redirect_to url.long_url,allow_other_host: true
      else
        render plain: "Short URL not found", status: :not_found
      end
    end
  
    private
  
    def url_params
      params.require(:url).permit(:long_url)
    end
  end
  