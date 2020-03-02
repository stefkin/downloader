# Usage

run `bundle` to install dependencies first

then `ruby ./main.rb pics.txt` to download files from pics.txt to ./downloads folder

you can specify download destination `ruby ./main.rb pics.txt ~/Downloads` for example


# Overview

[main.rb](./main.rb ) is the entry point script of the downloader. It processes command line
args and ties other modules together.


[ChunkedDownload](./chunked_download.rb) downloads individual files in chunks
using net/http and writes it in chunks to the destination file.
It avoids reading the whole file into memory reducing memory footprint.


[ReadLines](./read_lines.rb) reads file with links and parallelizes its'
processing using `Concurrent::Promise` from `concurrent-ruby`.


 [LineCount](./line_count.rb) calculates number of lines in a text file. It's
 used to create progress bar. I chose to use `wc -l` to calculate it. It is more
 efficient than `IO.foreach` for example. It's main drawback
 is that it's usable only in Unix-like environments.

