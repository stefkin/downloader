require 'concurrent-ruby'

module ReadLines
  module_function

  def call(filename, on_progress: -> {})
    IO.foreach(filename).map do |uri|
      Concurrent::Promise.execute do
        uri.strip!
        yield uri
        on_progress.call
      end.rescue { |err| puts err.message }
    end.map(&:wait!)
  end
end
