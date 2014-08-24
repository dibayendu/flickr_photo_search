class PhotosController < ApplicationController
  def search
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
