class Group < ActiveRecord::Base
  
  REQ_BY_PORTAVOCE = 'p'
  REQ_BY_VOTE = 'v'
  REQ_BY_BOTH = 'b'
  
  validates_presence_of     :name
  validates_length_of       :name,    :within => 3..100
  validates_uniqueness_of   :name
  
  validates_presence_of     :description
  validates_presence_of     :interest_border_id
  
  #has_many :meetings_organizations, :class_name => 'MeetingsOrganization'
  attr_accessible :partecipant_tokens, :name, :description, :accept_requests, :portavoce, :porta_id, :facebook_page_url, :group_partecipations, :interest_border_tkn
  
  has_many :group_partecipations, :class_name => 'GroupPartecipation', :dependent => :destroy
  has_many :group_follows, :class_name => 'GroupFollow', :dependent => :destroy
  has_many :post_publishings, :class_name => 'PostPublishing', :dependent => :destroy
  has_many :partecipants,:through => :group_partecipations, :source => :user, :class_name => 'User'
  has_many :followers,:through => :group_follows, :source => :user, :class_name => 'User'
  has_many :posts,:through => :post_publishings, :source => :blog_post, :class_name => 'BlogPost'
  has_many :partecipation_requests, :class_name => 'GroupPartecipationRequest', :dependent => :destroy
  #has_many :partecipation_roles, :class_name => 'PartecipationRole'
  belongs_to :interest_border, :class_name => 'InterestBorder', :foreign_key => :interest_border_id
  
  has_many :meetings_organizations, :class_name => 'MeetingsOrganization', :foreign_key => 'group_id'
  
  has_many :events,:through => :meetings_organizations, :class_name => 'Event', :source => :event
  
  attr_reader :partecipant_tokens, :image_url
  attr_accessor :portavoce, :porta_id
    
  def partecipant_tokens=(ids)
    self.partecipant_ids = ids.split(",")
  end
  
   def porta_id
    partecipation = self.group_partecipations.first(:conditions => {:partecipation_role_id => 2})
    if (partecipation)
      return partecipation.user_id
    end
  end
  
   def image_url
    if (self.image_id)
      return self.image.image.url    
    else
      return ""      
    end
  end
    
  
  def portavoce
    partecipation = self.group_partecipations.first(:conditions => {:partecipation_role_id => 2})
    if (partecipation)
      return partecipation.user
    end
  end
  
   def interest_border_tkn
     return self.interest_border.ftype + "-" + self.interest_border.foreign_id.to_s if self.interest_border
  end
  
  def interest_border_tkn=(tkn)
    if !tkn.blank?
      ftype = tkn[0,1] #tipologia (primo carattere)
      fid = tkn[2..-1]  #chiave primaria (dal terzo all'ultimo carattere)
      interest_b = InterestBorder.find_or_create_by_ftype_and_foreign_id(ftype,fid)
      puts "New Record!" if (interest_b.new_record?)
      self.interest_border = interest_b
    end
  end
  
  def request_by_vote?
    return true if self.accept_requests == REQ_BY_VOTE
    return false
  end
  
  def request_by_portavoce?
    return true if self.accept_requests == REQ_BY_PORTAVOCE
    return false
  end
  
  def request_by_both?
    return true if self.accept_requests == REQ_BY_BOTH
    return false
  end
  
end
