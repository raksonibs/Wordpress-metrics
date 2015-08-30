#!/usr/bin/env ruby

require 'capybara'
require 'capybara/poltergeist'
require 'pry'

include Capybara::DSL
Capybara.default_driver = :poltergeist

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {js_errors: false})
end

  def wait_for_ajax
    Timeout.timeout(6) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').nil?
  end

visit "https://www.wordpress.com/"

click_link('Log In')

fill_in('Email or Username', :with => "")
fill_in('Password', :with => "")
click_button('Log In')

# wait_for_ajax


visit('https://kacperniburski.wordpress.com/wp-admin/edit.php?post_status=publish&post_type=post')

# while there are still posts on the page, or while the count is under 22, that doesn't work, he publishes too fast, 
# basically, while the last arrow is still visbile, keep searching, let's try the first page
# once visit, go back to previous page? damm... they do pages in url ?paged=2 so can use that if know what page I am on
# the amount of posts are the 410 items though, that is easy. the amount of words is more difficult. basically visit each page, add the words

amountOfWords = 0
amountOfPosts = 0
pageCount = find("li.publish a span.count", match: :first)
amountOfPosts = pageCount.text().gsub('(','').gsub(')','').to_i
totalPages = find("span.total-pages", match: :first).text().to_i
posts = {}
currentPage = find('input.current-page').value().to_i

# while currentPage < totalPages
# loop through current page posts
# visit('https://kacperniburski.wordpress.com/wp-admin/edit.php?post_status=publish&post_type=post&paged=<count>')
# end
# {'hinde legs': 23}

# all('.iedit.author-self')


while currentPage <= totalPages
  totalPostsOnPage = all('.iedit.author-self').count - 1
  currentPost = 0

  while currentPost <= totalPostsOnPage
    visit("https://kacperniburski.wordpress.com/wp-admin/edit.php?post_status=publish&post_type=post&paged=#{currentPage}")
    post = all('.iedit.author-self')[currentPost]
    link = post.find('a.row-title')
    postTitle = post.find('a.row-title').text()
    visit(link[:href])
    wordCount = find('#wp-word-count span.word-count').text().to_i
    posts[postTitle] = wordCount
    amountOfWords += wordCount
    currentPost += 1

    # binding.pry

  end

  currentPage += 1
  visit("https://kacperniburski.wordpress.com/wp-admin/edit.php?post_status=publish&post_type=post&paged=#{currentPage}") unless currentPage > totalPages
end
  # current page, count of the actual post we are loopin in, then go to next link

  # may need to revisit page here as DOM changes
  # binding.pry

binding.pry