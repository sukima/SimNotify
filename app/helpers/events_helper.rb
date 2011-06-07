module EventsHelper
  def session_description(event)
    ret = dt event.start_time
    ret += " (#{distance_of_time_in_words(event.start_time, event.end_time)})"
    ret += " - #{pluralize(event.scenarios.count, "senario")}"
    ret += h event.need_flags_as_words if event.collective_has_needs
    return ret
  end

  def asset_image_tag(asset)
    base_dir = "/images/attachments"
    if asset.image?
      url = asset.session_asset.url(:thumb)
    else
      url = "#{base_dir}/icon.#{asset.session_asset_content_type.sub('/', '.')}.png"
      if !File.exists? "#{RAILS_ROOT}/public/#{url}"
        url = "#{base_dir}/icon.default.png"
      end
    end
    image_tag url, :class => "thumbnail"
  end
end
