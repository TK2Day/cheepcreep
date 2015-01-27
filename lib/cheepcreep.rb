require "cheepcreep/version"
require "cheepcreep/init_db"
require "httparty"
require "pry"

module Cheepcreep
  class GithubUser < ActiveRecord::Base
end

class Github
  include HTTParty
  base_uri 'https://api.github.com'
end

  def initialize
    #ENV["FOO"] is like echo $FOO
    @auth = {:username => ENV['GITHUB_USER'], :password => ENV['GITHUB_PASS']}
  end

  def get_followers(input = [], options = [])
    options.merge!({:basic_auth => @auth})
    resp = self.class.get("/users/#{input}/followers", options)
    data = JSON.parse(resp.body)
    user_info = []
    data.sample(20).each do |x|
      users_info << get_user_info(x['login'])
    end
    return users_info

  end


  def user_input_for_followers
    print "Please enter a Username you wish to view their stalkers : "
    gets.chomp
  end

  def get_username
    print "Please enter a username you wish to view : "
    gets.chomp
  end

  def insert_database(users = [])
    users.each do |x|
      Cheepcreep::GithubUser.create
      #TODO all of the integers should come after that^
    end
    puts "Database updated successfully."
    gets
  end

  def show_users
    system 'clear'
    puts "All users in database: "
    Cheepcreep::GithubUser.order(followers: :desc).each do |x|
      puts "Followers: #{x.followers} \t\t User: #{x.login}"
    end
    gets
  end


def get_gists(screen_name)
  result = self.class.get("/users/#{screen_name}/gists")
  json = JSON.parse(result.body)
end



github = Github.new
resp = github.get_followers(username<)
followers = JSON.pare(resp.body)
Cheepcrep::GitUser.create
