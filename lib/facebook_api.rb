class FacebookApi
	
	def initialize(request)
		facebook(request.user.auth_token)
		request.groups.each do |group|
			get_users_posts_hash(group)
		end
  end

	def facebook(token)
		@facebook ||= Koala::Facebook::API.new(token)
	end

	def get_feed(group)
		@facebook.get_connection(group.facebook_id,"feed")
	end

	def get_todays_feed(group)
		todays_feed = []
		feed = get_feed(group)
		loop do
			todays_feed.concat(feed.select {|post| 
				Date.parse(post["updated_time"]) == Date.today
			})
			break if todays_feed.last != feed.last
			feed = feed.next_page
		end
		todays_feed
	end

	def get_users_posts_hash(group)
		users_hash = {}
		feed = get_todays_feed(group)
		feed.each do |post|
			group.keywords.each do |keyword|
				if !post["message"].nil? && post["message"].include?(keyword.name)
					p = find_or_create_post(post)
					keyword.users.each do |user|
						user.posts << p unless user.posts.include? p
					end
				end
			end
		end
	end

	def find_or_create_post(post)
		group_id,post_id = post["id"].split("_")
		Post.find_by_facebook_id(post["id"]) || Post.create({
			facebook_id: post["id"],
			url: "https://www.facebook.com/#{group_id}/posts/#{post_id}"
		})
	end
end