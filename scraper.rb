require 'Nokogiri'
require "open-uri"
require 'fileutils'

def base?
  File.exist?("base.html")
end

def changed?(file)
  return true unless base?

  f1 = IO.readlines(file).map(&:chomp)
  f2 = IO.readlines('base.html').map(&:chomp)

  f1.size != f2.size
end

def date
  Time.now.strftime('%d%m%Y_%I%M%S')
end

def write_page(link)
  detail_page = link

  File.open("base.html", 'w') { |file| file.write(detail_page) }
end

def scrape(file)
  raise "The input file has not changed based on our base." unless changed?(file)

  page = Nokogiri::HTML(open(file))
  content = page.at("html")

  write_page(content) if changed?(file)
end

scrape("test.html")
