#  Scrapes https://www.freethink.com/articles for the following datas
# - Title
# - Image link
# - News page link
# - Timestamp
# - First paragraph of the content

require "nokogiri"
require "open-uri"

def main()
  results = []

  url = "https://www.freethink.com/articles"
  html = URI.open(url)
  doc = Nokogiri::HTML(html)

  # iterating through all loop-item classes
  doc.search(".loop-item").each do |element|
    image_link = element.search("img").attr("src").value
    title = element.search(".loop-item__title").text
    news_page_link = element.search(".loop-item__title").attr("href").value

    # scraping deeper inside news page
    news_page_html = URI.open(news_page_link)
    news_page_doc = Nokogiri::HTML(news_page_html)

    time_stamp = news_page_doc.search(".meta__date").search("time").attr("datetime").value
    first_paragraph = news_page_doc.search("p").first.text

    # adding results to array
    results.push({
      "title" => title,
      "image_link" => image_link,
      "news_page_link" => news_page_link,
      "time_stamp" => time_stamp,
      "first_paragraph" => first_paragraph,
    })
  end

  puts results
end

main()
