require 'spec_helper'
require_relative '../../lib/errors/exceptions'

describe PhotosController do
	# this is the default api key used in flickr website
	# https://www.flickr.com/services/api/explore/flickr.photos.search
	# look into the URL at the bottom of the form submission
	let(:api_key) { "da5f1818f1abf3fd41d6ace508651a45"}
	let(:text) { "Melbourne" }
	let(:photos_per_page) { 100 }

	subject { PhotosController.new }
	
	context "getting total number of pages" do		
		it "returns corrent number of pages" do
			stub_request(:get,
				"https://api.flickr.com/services/rest/?method=flickr.photos.search" +
	      "&api_key=#{api_key}" +
	      "&text=#{text}&per_page=#{photos_per_page}" +
	      "&format=json"
	    ).to_return(:body => 'jsonFlickrApi(
	    	{ "photos":
	    			{ "page": 1, "pages": "3820153", "perpage": 1, "total": "3820153", "photo": [
	      			{ "id": "14828085599", "owner": "40003627@N03", "secret": "0c22a5fa64", "server": "5560", "farm": 6, "title": "Devon", "ispublic": 1, "isfriend": 0, "isfamily": 0 }
	    			] },
	    		"stat": "ok"
	    	}', :status => 200
	    )
			actual = subject.get_total_number_of_pages(api_key, text, photos_per_page)
			expect(actual).to eql(3820153)
		end

		it "raises error when pages number not found in request" do
			api_key = "invalid"
			stub_request(:get,
				"https://api.flickr.com/services/rest/?method=flickr.photos.search" +
	      "&api_key=#{api_key}" +
	      "&text=#{text}&per_page=#{photos_per_page}" +
	      "&format=json"
	    ).to_return(:body => 'jsonFlickrApi(
	    		{ "stat": "fail", "code": 3, "message": "Parameterless searches have been disabled. Please use flickr.photos.getRecent instead." }',
	     	:status => 200)
			expect { subject.get_total_number_of_pages(api_key, text, photos_per_page) }.to raise_error(Exceptions::FlickrApiError)
		end
	end
end