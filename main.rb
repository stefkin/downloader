require_relative 'chunked_download'
require_relative 'read_lines'
require 'securerandom'
require 'ruby-progressbar'
require_relative './line_count'

filename = ARGV[0]
destination = ARGV[1] || "./downloads/"

progress = ProgressBar.create(total: LineCount.call(filename))

ReadLines.call(filename, on_progress: -> { progress.increment }) do |uri|
  ChunkedDownload.call(uri, destination: "#{destination}/#{SecureRandom.hex(16)}")
end
