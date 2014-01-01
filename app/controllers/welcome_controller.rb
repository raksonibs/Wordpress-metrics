require 'open-uri'
require 'nokogiri'
Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium
  config.app_host = 'https://www.wordpress.com' 
end

class WelcomeController < ApplicationController
	include Capybara::DSL
	@largeposts=[]
	@that=nil
	@thatval=nil
	@uniqueposts={}
 def index
  	a = Mechanize.new
	a.get('http://www.wordpress.com') do |page|
	  # Click the login link
	  login_page = a.click(page.link_with(:text => /Sign In/))
	  # login_page = a.click(page.link_with(:text => /Log In/))
	  #p a.click(page.link_with(:text=>/Sign In/))
	  # # Submit the login form
	  my_page = login_page.forms.first
	  my_page.fields.each do |field|
	  	if field.type=="email"
	  		field.value=""
	  	elsif field.type=="password"
	  		field.value=""
	  	end
	  end
 #should make into a function because repetitive
	  logged_in= my_page.click_button
	  my_blog=nil
	  logged_in.links.each do |wlink|
	  	#p wlink
	  	my_blog=wlink.click if wlink.text[/My Blog/]
	  	
	  end
	  posts=nil
	  my_blog.links.each do |wlink|
	  	posts=wlink.click if wlink.text[/Posts/]
	  end
	  wlink= posts.links.find {|wlink| wlink.href if wlink.text=="»"}
	  numofpages=(wlink.href[/\d+/].to_i)-1
	  that=nil
	  thatval=nil
	  
	  # posts.links.each do |wlink|
	  # 	@thatval=wlink if wlink.text=="Smudge"
	  # 	@that=wlink.click if wlink.text=="Smudge" 
	  # end
	  @largeposts=[]
	  numofpages.times do
		  posts.links.each do |wlink|
		  	@largeposts << posts
		  	posts=wlink.click if wlink.text[/›/]

		 end
	  end
	  @uniqueposts={}
	  @largeposts.each do |post|
	  	post.links.each do |link|

	  		unless link.href==nil
	  			

		  		if link.text!="Edit" && link.href[/&action=edit/]

		  			@uniqueposts[link.text]=link.href if @uniqueposts==nil || !@uniqueposts.include?(link.text) 

		  		end
		  	end
	  	end
	  end

	end
	@total=0
	@once||=true
	@count=0
	@uniqueposts.each do |k,v|
	    visit(v)
	    if @once
		    fill_in 'Email', :with => '' 
	    	fill_in 'Password', :with => ''

	    	click_button 'wp-submit'
    		@once=false
    	end
    	val=page.body
	    number=val[/<span class=\"word-count\">\d+<\/span>/]
	    @total+=number[/\d+/].to_i
	    @count+=1
	end
    @total
    @count
    
      
      
	  # data=Nokogiri::HTML(open(thatval.href.to_s).read)
	  # puts data -> blocks you out even if logged in through
	  #mechanize
	  # posts2=nil
	  # largerposts=[]
	  # numofpages.times do
		 #  posts.links.each do |wlink|
		 #  	largerposts << posts
		 #  	posts=wlink.click if wlink.text[/›/]

		 # end
	  # end

	  # largerposts.each do |pageofposts|
	  # 	pageofposts.each do |post|
	  # 		if post
	  # 	end
	  # end
	   
	  #now have posts need to locate the value for going to the next page, and until there 
	  #are no more pages and all posts on the last page are done, tehen return value
	  #so while still pages
	  		# while stil values on this page
	  		   #vist page
	  		   #add total words
	  		   #new page
	  		#new page
	  #posts contain how many pages, and the current page, so should first get
	  #a list of all the pages, posts being the first, eight more
  end
end
