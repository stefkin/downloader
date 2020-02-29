require 'ruby-progressbar'
require 'concurrent-ruby'

module ReadLines
  module_function

  def call(filename)
    progressbar = ProgressBar.create total: line_count(filename)

    IO.foreach(filename).map do |uri|
      Concurrent::Promise.execute do
        uri.strip!
        yield uri
        progressbar.increment
      end.rescue { |err| puts err.message }
    end.map(&:wait!)
  end

  def line_count(filename)
    `wc -l "#{filename}"`.strip.split(' ')[0].to_i + 1
  end
end
