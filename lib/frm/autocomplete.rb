module Frm
  module Autocomplete
    def forem_autocomplete(term)
      where("#{Frm.autocomplete_field} LIKE ?", "%#{term}%").
      limit(10).
      select("#{Frm.autocomplete_field}, id").
      order("#{Frm.autocomplete_field}")
    end

  end
end
