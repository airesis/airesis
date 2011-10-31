class BlogComment < ActiveRecord::Base
	include BlogKitModelHelper
	
	unloadable
	
	belongs_to :user
	belongs_to :blog_post
	
	validates_presence_of :body

	before_save :check_for_spam
  
  attr_accessor :collapsed

  
  def after_initialize     
     @collapsed = false     
  end
 
 #quando sto per inserire un commento verifico che non ne sia già stato 
 #inserito uno per lo stesso post dallo stesso utente entro 5 minuti
	def validate
    comments =  self.blog_post.blog_comments.find_all_by_user_id(self.user_id, :order => "created_at DESC")
    comment = comments.first
  #  if comment and (((Time.now - comment.created_at)/60) < 5)
  #      self.errors.add(:created_at,"Devono passare almeno cinque minuti tra un commento e l'altro.")
  #  end
	end

	def formatted_created_at
		self.created_at.strftime('%m/%d/%Y alle %I:%M%p')
	end
	
	def parsed_body
		# # Going to add markdown/html support later for comments
		# self.code_highlight_and_markdown(self.body, {:escape_html => true})
		
		self.body
	end
	
	def user_name
		name = self.user ? self.user.name : self.name
		if !self.site_url.blank?
			return "<a href=\"#{self.site_url}\">#{name}</a>"
		else
			return name
		end
	end
	
	# Used to set more tracking for akismet
	def request=(request)
		self.user_ip    = request.remote_ip
	  self.user_agent = request.env['HTTP_USER_AGENT']
	  self.referrer   = request.env['HTTP_REFERER']
	end
	
	def check_for_spam
		if BlogKit.instance.settings['akismet_key'] && BlogKit.instance.settings['blog_url']
		  if Akismetor.spam?(akismet_attributes)
				self.errors.add_to_base('This comment has been detected as spam')
				return false
			else
				return true
			end
		end
	  true
	end

	def akismet_attributes
	  {
	    :key                  => BlogKit.instance.settings['akismet_key'],
	    :blog                 => BlogKit.instance.settings['blog_url'],
	    :user_ip              => user_ip,
	    :user_agent           => user_agent,
	    :comment_author       => name,
	    :comment_author_email => email,
	    :comment_author_url   => site_url,
	    :comment_content      => body
	  }
	end
	
  
  
  
end