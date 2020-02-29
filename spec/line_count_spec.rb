require 'securerandom'
require_relative '../line_count'

describe LineCount do
  let(:uri) { "https://www.example.com/foo.png" }

  context 'there is a file with 5 lines (4 newlines)' do
    let(:filename) { "/tmp/#{SecureRandom.hex(16)}.txt" }

    before { File.write(filename, Array.new(5, uri).join("\n")) }

    it "tells us that file has 5 lines" do
      expect(LineCount.call(filename)).to eq 5
    end
  end
end
