class Group < ActiveRecord::Base
  include ImageHelper 
  REQ_BY_PORTAVOCE = 'p'
  REQ_BY_VOTE = 'v'
  REQ_BY_BOTH = 'b'
  
  validates_presence_of     :name
  validates_length_of       :name,    :within => 3..60
  validates_uniqueness_of   :name
  
  validates_presence_of     :description
  validates_length_of       :name,    :within => 10..2000
  validates_length_of       :image_url,    :within => 1..255, :allow_blank => true
  validates_length_of       :facebook_page_url,    :within => 10..255, :allow_blank => true
  validates_length_of       :title_bar,    :within => 1..255, :allow_blank => true
  validates_presence_of     :interest_border_id
  
  #has_many :meeting_organizations, :class_name => 'MeetingsOrganization'
  attr_accessible :partecipant_tokens, :name, :description, :accept_requests, :portavoce, :porta_id, :facebook_page_url, :group_partecipations, :interest_border_tkn, :title_bar, :image_url
  
  has_many :group_partecipations, :class_name => 'GroupPartecipation', :dependent => :destroy
  has_many :group_follows, :class_name => 'GroupFollow', :dependent => :destroy
  has_many :post_publishings, :class_name => 'PostPublishing', :dependent => :destroy
  has_many :partecipants,:through => :group_partecipations, :source => :user, :class_name => 'User'
  has_many :followers,:through => :group_follows, :source => :user, :class_name => 'User'
  has_many :posts,:through => :post_publishings, :source => :blog_post, :class_name => 'BlogPost'
  has_many :partecipation_requests, :class_name => 'GroupPartecipationRequest', :dependent => :destroy
  has_many :partecipation_roles, :class_name => 'PartecipationRole', :dependent => :destroy
  #has_many :partecipation_roles, :class_name => 'PartecipationRole'
  belongs_to :interest_border, :class_name => 'InterestBorder', :foreign_key => :interest_border_id
  
  has_many :meeting_organizations, :class_name => 'MeetingOrganization', :foreign_key => 'group_id', :dependent => :destroy
  
  has_many :events,:through => :meeting_organizations, :class_name => 'Event', :source => :event
  
  has_many :proposal_supports, :class_name => 'ProposalSupport', :dependent => :destroy
  has_many :proposals, :through => :proposal_supports, :class_name => 'Proposal'
  belongs_to :image, :class_name => 'Image', :foreign_key => :image_id
  
  has_many :action_abilitations, :class_name => 'ActionAbilitation'

  
  attr_reader :partecipant_tokens
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
    elsif (read_attribute(:image_url) != nil)
      return read_attribute(:image_url)
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
     return self.interest_border.territory_type + "-" + self.interest_border.territory_id.to_s if self.interest_border
  end
  
  def interest_border_tkn=(tkn)
    if !tkn.blank?
      ftype = tkn[0,1] #tipologia (primo carattere)
      fid = tkn[2..-1]  #chiave primaria (dal terzo all'ultimo carattere)
      found = InterestBorder.table_element(tkn)      
      if (found)  #se ho trovato qualcosa, allora l'identificativo è corretto e posso procedere alla creazione del confine di interesse
        interest_b = InterestBorder.find_or_create_by_territory_type_and_territory_id(InterestBorder::I_TYPE_MAP[ftype],fid)
        puts "New Record!" if (interest_b.new_record?)
        self.interest_border = interest_b
      end
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
