class Tag < ActiveRecord::Base
	def as_json(options={})    
   { :id => self.text, :name => self.text }
  end
end