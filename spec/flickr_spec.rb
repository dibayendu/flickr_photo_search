require 'spec_helper'

describe 'flickr api ping' do

	let(:api_key) { ENV["FLICKR_API_KEY"] }
	let(:shared_secret) { ENV["FLICKR_SHARED_SECRET"] }
	before(:each) do
		FlickRaw.api_key = api_key
  	FlickRaw.shared_secret = shared_secret
	end

  # since once flickr object initialised with correct api and secret
  # it tends to remember it. Therefore creating new flickr object
  # to check if error is raised
	subject { FlickRaw::Flickr.new }

	context "when valid api key is given" do
		context "and valid shared secret is given" do
			it { expect { subject }.to_not raise_error }
			it { expect { flickr.test.echo }.to_not raise_error }
		end

		context "and nil shared secret is given" do
			let(:shared_secret) { nil }
			it { expect { subject }.to raise_error FlickRaw::FlickrAppNotConfigured }
		end
	end
	
	context "when valid shared secret is given" do
		context "and nil api key is given" do
			let(:api_key) { nil }
			it { expect { subject }.to raise_error FlickRaw::FlickrAppNotConfigured }
		end
	end
end