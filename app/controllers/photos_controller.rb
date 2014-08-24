class PhotosController < ApplicationController
  def search
  	@photos = []
    @current_page = 1
    @capacity = 8
    photos_per_page = 110
  	@error
  	if params[:query] && !params[:query].empty?
  		query = params[:query]
      @searched_query = query
      @total_pages = get_total_number_of_pages(ENV['FLICKR_API_KEY'], @searched_query, photos_per_page)
      @last_page = @total_pages
      p @last_page
      @current_page = params[:page_number] if params[:page_number] && !params[:page_number].empty?
  		begin
  			@photos = flickr.photos.search(text: query, per_page: photos_per_page, page: @current_page)
  		rescue
  			@error = "Something went wrong! Either you don't have internet connection of Flickr is down!"
        flash.now[:error] = @error
  		end
  	end
  end

  def get_total_number_of_pages(api_key, text, photos_per_page)
    url = get_default_flickr_photo_search_url(api_key, text, photos_per_page)
    data = get_data_from_flickr(url)
    data = filter_received_data(data)
    if data.has_key? "photos"
      data["photos"]["pages"].to_i
    else
      raise Exceptions::FlickrApiError.new(data)
    end
  end

  private
    def get_default_flickr_photo_search_url(api_key, text, photos_per_page)
      "https://api.flickr.com/services/rest/?method=flickr.photos.search" +
      "&api_key=#{api_key}" +
      "&text=#{text}&per_page=#{photos_per_page}" +
      "&format=json"
    end

    def get_data_from_flickr(url)
      url = URI.parse(url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = url.scheme == "https"
      request = Net::HTTP::Get.new(url)
      response= http.request(request)
      response.body
    end

    def filter_received_data(data)
      data = data.sub("jsonFlickrApi(", "")
      data = data.chomp(')')
      JSON.parse(data)
    end
end
