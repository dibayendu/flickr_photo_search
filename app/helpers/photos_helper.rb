module PhotosHelper
	def get_small_photo_url(photo)
		"http://farm#{photo.farm}.staticflickr.com/#{photo.server}/#{photo.id}_#{photo.secret}_s.jpg"
	end

	def get_big_photo_url(photo)
		"http://farm#{photo.farm}.staticflickr.com/#{photo.server}/#{photo.id}_#{photo.secret}_b.jpg"
	end

	def get_page_url(page_number, query)
		"/?utf8=✓&query=#{query}&commit=Search&page_number=#{page_number}"
	end

	def get_paginations(current_page, total_pages, capacity)
		paginations = {}
		# paginations['First'] = current_page == 1 ? "disabled" : ""
		# paginations['Previous'] = current_page == 1 ? "disabled" : ""
		before_count, after_count = get_before_and_after_page_count(current_page, total_pages, capacity)
		(current_page - before_count).upto(current_page - 1) do |i|
			paginations[i.to_s] = ""
		end
		paginations[current_page.to_s] = "active"
		(current_page + 1).upto(current_page + after_count) do |i|
			paginations[i.to_s] = ""
		end
		# paginations['Next'] = current_page == total_pages ? "disabled" : ""
		# paginations['Last'] = current_page == total_pages ? "disabled" : ""
		paginations
	end

	def get_before_and_after_page_count(current_page, total_pages, capacity)
		half_capacity = capacity / 2
		before_pages = current_page - 1
		before_pages = capacity - 1 if before_pages > (capacity - 1) # maximum capacity
		after_pages = total_pages - current_page
		after_pages = capacity - 1 if after_pages > (capacity - 1) # maximum capacity
		if (before_pages > half_capacity) && (after_pages > half_capacity)
			before_pages = after_pages = half_capacity
		elsif (before_pages > after_pages)
			before_pages -= after_pages
		elsif (after_pages > before_pages)
			after_pages -= before_pages
		end
		return before_pages, after_pages
	end
end
