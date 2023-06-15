require 'net/http'

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  def gist
    if self.url[0..23].match?("https://gist.github.com/")
      url = self.url.split(/^https:\/\/gist.github.com\/[aA-zZ0-9]+\//).last

      response = Octokit.gist(url)
      response.description
      response.files.first[1].content
    end
  end
end
