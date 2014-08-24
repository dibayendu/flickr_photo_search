require 'spec_helper'

describe PhotosHelper do	
	let(:photo) do
		OpenStruct.new({
			id: "photo_id", owner: "test", secret: "rspec_test",
			server: "webrick", farm: 4, title: "Testing",
			ispublic: 1, isfriend: 0, isfamily: 0
		})
	end

	# this is the default api key used in flickr website
	# https://www.flickr.com/services/api/explore/flickr.photos.search
	# look into the URL at the bottom of the form submission
	let(:api_key) { "da5f1818f1abf3fd41d6ace508651a45"}
	let(:text) { "Melbourne" }
	let(:photos_per_page) { 1 }

	it "returns correct url for small image" do
	  expected_url = "http://farm4.staticflickr.com/webrick/photo_id_rspec_test_s.jpg"
		actual_url = get_small_photo_url(photo)
		expect(actual_url).to eql(expected_url)
	end

	it "returns correct url for big image" do
	  expected_url = "http://farm4.staticflickr.com/webrick/photo_id_rspec_test_b.jpg"
		actual_url = get_big_photo_url(photo)
		expect(actual_url).to eql(expected_url)
	end

	it "returns correct page url" do
		expected_url = "/?utf8=✓&query=#{text}&commit=Search&page_number=111"
		actual_url = get_page_url(111, text)
		expect(actual_url).to eql(expected_url)
	end

	context "getting correct paginations" do
		let(:total_pages) { 10 }
		let(:capacity) { 5 }

		it "returns no pages before and 4 pages after" do
			actual = get_before_and_after_page_count(1, total_pages, capacity)
			expect(actual).to eql([0,4])
		end

		it "returns 1 page before and 3 pages after" do
			actual = get_before_and_after_page_count(2, total_pages, capacity)
			expect(actual).to eql([1,3])
		end

		it "returns 2 pages before and 2 pages after" do
			actual = get_before_and_after_page_count(5, total_pages, capacity)
			expect(actual).to eql([2,2])
		end

		it "returns 3 pages before and 1 page after" do
			actual = get_before_and_after_page_count(9, total_pages, capacity)
			expect(actual).to eql([3,1])
		end

		it "returns 4 pages before and no pages after" do
			actual = get_before_and_after_page_count(10, total_pages, capacity)
			expect(actual).to eql([4,0])
		end

		it "returns page number 5 as active" do
			actual = get_paginations(5, total_pages, capacity)
			expected = { "3" => "", "4" => "", "5" => "active", 
									 "6" => "", "7" => "" }
			expect(actual).to eql(expected)
		end

		it "returns page number 1 as active" do
			actual = get_paginations(1, total_pages, capacity)
			expected = { "1" => "active", "2" => "", "3" => "",
									 "4" => "", "5" => "" }
			expect(actual).to eql(expected)
		end

		it "returns page number 10 as active" do
			actual = get_paginations(10, total_pages, capacity)
			expected = { "6" => "", "7" => "", "8" => "", 
									 "9" => "", "10" => "active" }
			expect(actual).to eql(expected)
		end
	end
end