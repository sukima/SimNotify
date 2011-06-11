class Facility < ActiveRecord::Base
  validates_presence_of :name

  def agenda_color
    return "#369" if self[:agenda_color].blank?
    return (self[:agenda_color] =~ /^#/) ? self[:agenda_color] : "##{self[:agenda_color]}"
  end
end
