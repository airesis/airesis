class  ParagraphHistory < ActiveRecord::Base
  belongs_to :section, class_name: 'SectionHistory'


  #we remove title and username
  def parsed_content(anonimous=true)
    #parsed = self.content.gsub(/data-username="([^".]+)"/) do |match| #.gsub(/title="[^".]+"/,'')
    #  anonimous ?
    #  "data-username=\"anonimo\"" :
    #  match
    #end
    self.content.gsub(/title="([^".]+)"/) do |match| #
      #id = User.decode_id($1)
      anonimous ?
          "title=\"anonimo\"" :
          match
    end
  end
end