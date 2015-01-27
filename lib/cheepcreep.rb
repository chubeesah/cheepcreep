require "cheepcreep/version"
require "cheepcreep/init_db"
require "httparty"
require "pry"

module Cheepcreep
  class User < ActiveRecord::Base
    validates :login, presence: true
  end
end
class Github
  include HTTParty
    base_uri 'https://api.github.com'
    basic_auth ENV['GITHUB_USER'], ENV['GITHUB_PASS']

    #resp = HTTParty.get(base_uri + '/users/redline6561')

    def get_user(user = 'redline6561')
      result = self.class.get("/users/#{user}")
      puts "#{result.headers['x-ratelimit-remaining']} requests left!"
      json = JSON.parse(result.body)
    end

    def get_followers(user = 'redline6561', page=1, per_page=20)
      options = {:query => {:page => page, :per_page => per_page}}
      result = self.class.get("/users/#{user}/followers", options)
      puts "#{result.headers['x-ratelimit-remaining']} requests left!"
      json = JSON.parse(result.body)
      followers_array
    end

    #def sort_users(screen_name)
    #  self.class.get("/users/#{screen_name}")
    #  #json = JSON.parse(result.body)
    #  User.order(followers: :asc)
    #end
end  
def add_user(screen_name)
  github = Github.new
  result = github.class.get("/users/#{screen_name}")
  json = JSON.parse(result.body)
  user = github.get_user(screen_name)
  Cheepcreep::User.create(:login => json['login'], 
                          :name => json['name'], 
                          :blog => json['blog'], 
                          :public_repos => json['public_repos'], 
                          :followers => json['followers'], 
                          :following => json['following'])
end 


#add_user('redline6561')

#followers = github.get_followers('redline6561', 1, 100)
#followers.map { |x| x['login'] }.sample(20).each do |username|
 # add_github_user(username)
 # end

binding.pry



