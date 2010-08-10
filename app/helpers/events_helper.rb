module EventsHelper
  def need_flags_as_words(event)
    needs = []
    needs_hash = event.collective_need_flags
    needs << "staff support" if needs_hash[:staff_support]
    needs << "moulage" if needs_hash[:moulage]
    needs << "video" if needs_hash[:video]
    needs << "mobile" if needs_hash[:mobile]
    return needs.to_sentence
  end
end
