class  ParagraphHistory < ActiveRecord::Base
  belongs_to :section, class_name: 'SectionHistory'
end