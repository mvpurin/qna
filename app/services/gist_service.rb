require 'octokit'

class GistService
  def initialize
    @client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  end

  def call
    @client.gist
  end
  
end