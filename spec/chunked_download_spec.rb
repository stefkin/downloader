require_relative '../chunked_download'
require 'webmock/rspec'
require 'securerandom'

describe ChunkedDownload do
  let(:destination) { "/tmp/#{SecureRandom.hex(16)}.png" }
  let(:uri) { "https://www.example.com/foo.png" }

  context 'when I ask to download an available image' do
    before { stub_request(:any, uri).to_return(body: "frog") }

    it "saves it to the provided destination" do
      ChunkedDownload.call(uri, destination: destination)

      expect(File.read(destination)).to eq "frog"
    end
  end

  context 'when I ask to download an unavailable image' do
    before { stub_request(:any, uri).to_return(status: 403) }

    it "there is no corrupted file after the failure" do
      expect { ChunkedDownload.call(uri, destination: destination) }
        .to raise_error(
          an_instance_of(StandardError)
            .and having_attributes(message: "Error 403: https://www.example.com/foo.png"))

      expect(File.exist?(destination)).not_to be
    end
  end
end
