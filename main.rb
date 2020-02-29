require_relative 'chunked_download'
require_relative 'read_lines'
require 'securerandom'

filename = ARGV[0]
destination = ARGV[1] || "./downloads/"

ReadLines.call(filename) do |uri|
  ChunkedDownload.call(uri, destination: "#{destination}/#{SecureRandom.hex(16)}")
end
