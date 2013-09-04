module Frm
  class FrmTable < ActiveRecord::Base
    self.abstract_class = true
    self.table_name_prefix = 'frm_'
  end
end