class Asset < ActiveRecord::Base
  has_attached_file :session_asset, :styles => { :thumb => "64x64#" }
  belongs_to :instructor

  # Prevent processing for non-image files.
  # Referenced from blog post:
  # http://awesomeful.net/posts/33-attach-non-image-files-in-rails-with-paperclip
  before_post_process :image?
  def image?
    !(data_content_type =~ /^image.*/).nil?
  end
end
