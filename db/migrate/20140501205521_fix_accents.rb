#encoding: utf-8
class FixAccents < ActiveRecord::Migration
  def change
    execute "update comunes
      set description = replace(description,'i''','ì')
      where description like '%i''%'"
  end
end