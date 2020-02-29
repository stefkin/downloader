require 'net/http'
require 'uri'

module ChunkedDownload
  module_function

  def call(raw_uri, destination:)
    return unless raw_uri
    uri = URI(raw_uri)

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Get.new uri

      http.request request do |response|
        raise StandardError, error_message(response.code, uri) unless success?(response)

        File.open destination, 'wb' do |io|
          response.read_body { |chunk| io.write chunk }
        end
      end
    end
  end

  def success?(response)
    (200...300).include?(response.code.to_i)
  end

  def error_message(code, uri)
    "Error #{code}: #{uri}"
  end
end
