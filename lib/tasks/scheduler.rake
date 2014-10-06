desc "TODO"
task :daily_digest => :environment do
	Group.all.each do |group|
		unless group.requests.empty?
			facebook(group.auth_token)
			find_posts_and_create_results(group)
		end
	end

	User.with_results.each do |user|
		UserMailer.daily_digest(user).deliver
	end
end

def facebook(token)
	@facebook = Koala::Facebook::API.new(token)
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

def find_posts_and_create_results(group)
	users_hash = {}
	feed = get_todays_feed(group)
	feed.each do |post|
		group.keywords.each do |keyword|
			if !post["message"].nil? && post["message"].include?(keyword.name)
				p = find_or_create_post(post)
				keyword.users.each do |user|
					result = Result.where(user_id: user.id, post_id: p.id).first_or_create
					result.save
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
