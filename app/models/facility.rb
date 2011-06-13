class Facility < ActiveRecord::Base
  validates_presence_of :name

  def agenda_color
    return "#36c" if self[:agenda_color].blank?
    return (self[:agenda_color] =~ /^#/) ? self[:agenda_color] : "##{self[:agenda_color]}"
  end
end
