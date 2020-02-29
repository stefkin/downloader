module LineCount
  module_function

  def call(filename)
    `wc -l "#{filename}"`.strip.split(' ')[0].to_i + 1
  end
end
