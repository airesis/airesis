class Quorum < ActiveRecord::Base
  
  has_one :group_quorum, :class_name => 'GroupQuorum'
  has_one :group, :through => :group_quorum, :class_name => 'Group'
  
  scope :public, { :conditions => ["public = ?",true]}
  scope :active, { :conditions => ["active = ?",true]}
end
