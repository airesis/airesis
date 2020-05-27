module Frm
  class FrmTable < ApplicationRecord
    self.abstract_class = true
    self.table_name_prefix = 'frm_'
  end
end
