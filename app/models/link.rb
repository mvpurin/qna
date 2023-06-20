class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  def gist?
    self.url[0..23].match?("https://gist.github.com/")
  end

  def gist_url
    self.url.split('/').last
  end
end
