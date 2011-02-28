class Asset < ActiveRecord::Base
  has_attached_file :session_asset, :styles => { :thumb => "64x64#" }
  belongs_to :instructor
  has_and_belongs_to_many :events

  validates_attachment_presence :session_asset
  validates_attachment_size :session_asset, :less_then => 20.megabytes

  # Prevent processing for non-image files.
  # Referenced from blog post:
  # http://awesomeful.net/posts/33-attach-non-image-files-in-rails-with-paperclip
  before_post_process :image?
  def image?
    !(session_asset_content_type =~ /^image.*/).nil?
  end

  def icon_url
    "/unknown.jpg"
  end
end
