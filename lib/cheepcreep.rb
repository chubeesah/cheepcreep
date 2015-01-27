require "cheepcreep/version"
require "cheepcreep/init_db"
require "httparty"
require "pry"

module Cheepcreep
end

  class User
  end

  class Github
    include HTTParty
    base_uri 'https://api.github.com'
  
    resp = HTTParty.get(base_uri + '/users/redline6561')
  
    def initialize
      # ENV["FOO"] is like echo $FOO
      @auth = {:username => ENV['GITHUB_USER'], :password => ENV['GITHUB_PASS']}
    end

    def get_followers(screen_name)
      result = self.class.get("/users/#{screen_name}/followers")
      json = JSON.parse(result.body)
    end

    def get_user(screen_name)
      result = self.class.get("/users/#{screen_name}")
      json = JSON.parse(result.body)
    end

    def sort_users(screen_name)
      self.class.get("/users/#{screen_name}")
      json = JSON.parse(result.body)

    end
  end

binding.pry

#github = Github.new
#resp = github.get_followers('redline6561')
#followers = JSON.parse(resp.body)
#Cheepcreep::GithubUser.create
