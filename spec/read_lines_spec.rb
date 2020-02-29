require_relative '../chunked_download'
require_relative '../read_lines'
require 'webmock/rspec'
require 'securerandom'
require 'fileutils'


describe ReadLines do
  let(:uri) { "https://www.example.com/foo.png" }

  context 'when I ask to download available images' do
    let(:filename) { "/tmp/#{SecureRandom.hex(16)}.txt" }
    let(:dirname) { "/tmp/#{SecureRandom.hex(4)}"}

    before { FileUtils.mkdir_p dirname }
    before { File.write(filename, Array.new(5, uri).join("\n")) }
    before { stub_request(:any, uri).to_return(body: "frog") }

    it "saves it to the provided folder" do
      ReadLines.call(filename) do |uri|
        ChunkedDownload.call(uri, destination: "#{dirname}/#{SecureRandom.hex(16)}")
      end

      expect(Dir["#{dirname}/*"].count).to eq 5

      Dir["#{dirname}/*"].each do |filename|
        expect(File.read(filename)).to eq "frog"
      end
    end
  end

  context 'when some URIs are unavailable' do
    let(:filename) { "/tmp/#{SecureRandom.hex(16)}.txt" }
    let(:dirname) { "/tmp/#{SecureRandom.hex(4)}"}
    let(:bad_uri) { "https://www.example.com/bar.png" }

    before { FileUtils.mkdir_p dirname }
    before { stub_request(:any, uri).to_return(body: "happy frog") }
    before { stub_request(:any, bad_uri).to_return(body: "sad frog", status: 404) }
    before { File.write(filename, "#{uri}\n#{bad_uri}") }

    it "saves only available uri" do
      ReadLines.call(filename) do |uri|
        ChunkedDownload.call(uri, destination: "#{dirname}/#{SecureRandom.hex(16)}")
      end

      expect(Dir["#{dirname}/*"].count).to eq 1

      Dir["#{dirname}/*"].each do |filename|
        expect(File.read(filename)).to eq "happy frog"
      end
    end

    it "writes an error message to STDOUT" do
      expect do
        ReadLines.call(filename) do |uri|
          ChunkedDownload.call(uri, destination: "#{dirname}/#{SecureRandom.hex(16)}")
        end
      end.to output("Error 404: https://www.example.com/bar.png\n").to_stdout
    end
  end
end
