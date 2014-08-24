require_relative '../../lib/errors/exceptions'

class PhotosController < ApplicationController
  PHOTOS_PER_PAGE = 112

  def search
    @searched_query = params[:query]
    @current_page = (params[:page_number] && !params[:page_number].empty?) ? params[:page_number].to_i : 1
    @photos = []
    @capacity = 8
  	if @searched_query && !@searched_query.empty?
  		begin
        @last_page = @total_pages = get_total_number_of_pages(ENV['FLICKR_API_KEY'], @searched_query, PHOTOS_PER_PAGE)
  			@photos = flickr.photos.search(text: @searched_query, per_page: PHOTOS_PER_PAGE, page: @current_page)
        flash.now[:warn] = "Sorry, could not find photos for text: #{@searched_query}" unless @photos.any?
  		rescue => e
  			flash.now[:error] = "Something went wrong! Either you don't have internet connection of Flickr is down!"
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
      raise ::Exceptions::FlickrApiError.new(data)
    end
  end

  private
    def get_default_flickr_photo_search_url(api_key, text, photos_per_page)
      text = URI.escape(text)
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
