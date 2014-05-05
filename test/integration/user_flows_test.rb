require 'test_helper'

class ActionController::TestCase
  include Devise::TestHelpers
end
 
class UserFlowsTest < ActionDispatch::IntegrationTest
  fixtures :users
 
  test "login and browse site" do    
    #procedo come utente non autenticato e scorro tutte le pagine che devo essere in grado di visitare
    #la root
    get "/"
    assert_response :success, "Hei man! I can't access root anymore! What's happening?"
    
    #elenco delle proposte
    get proposals_path
    assert_response :success, "Can't access proposals list"
    #ogni singola proposta
    Proposal.all.each do |proposal|
      puts "Accessing proposal " + proposal.id.to_s
      get proposal_path(proposal)  
      assert_response :success, "Can't access proposal #{proposal.id}"
    end
    #elenco dei gruppi
    get "/groups"
    assert_response :success, "Can't access groups list"
    #ogni singolo gruppo
    Group.all.each do |group|
      puts "Accessing group " + group.id.to_s
      get group_path(group)  
      assert_response :success, "Can't access group #{group.id}"
    end

    #elenco utenti
    get "/users"
    assert_response :success, "Can't access users list"
    #le pagine dei singoli utenti
    User.all.each do |user|
      puts "Accessing user " + user.id.to_s
      get user_path(user)
      assert_response :success, "Can't access user page #{user.id}"
    end
    
    #elenco blog e post
    get "/blogs"
    assert_response :success, "Can't access blogs list"
    #le pagine dei singoli blog
    Blog.all.each do |blog|
      puts "Accessing blog " + blog.id.to_s
      get blog_path(blog)
      assert_response :success, "Can't access blog page #{blog.id}"
      blog.posts.each do |post|
        get blog_blog_post_path(blog,post)
        assert_response :success, "Can't access blog post page #{post.id}"
      end
    end
    
    #pagina degli eventi
    get events_path
    assert_response :success, "Can't access events list"
    
    #chiedo la pagina delle notifiche ma mi bloccherà dicendo che devo fare login
    get alerts_path
    assert_response :redirect
    
    #faccio login e mi trovo nella mia pagina delle notifiche
    coorasse = login(:coorasse)
    
    #procedo alla root e mi ritrovo nella pagina delle proposte
    get "/"
    #assert_redirect_to proposals_path
    
    #procedo alla pagina di inserimento proposte
    get "/proposals/new" 
    assert_response :success
    puts "i can go proposal new page!"
    
    #cerco di fare un po' di operazioni sulle proposte
    Proposal.all.each do |proposal|
      get proposal_path(proposal)
      assert_response :success
      
      puts "passing proposal #{proposal.id}"
      #request.env["HTTP_REFERER"] = proposals_path
      setup do
        @request.env['HTTP_REFERER'] = proposals_path
        get edit_proposal_path(proposal)
        if (proposal.users.include? coorasse)
          assert_response :success
          puts "Uao! I can edit this!"
        else
          assert_response :redirect, "Hei! I can access proposal #{proposal.id}?"
          #assert_redirect_to proposals_path
        end
      end
            
    end
    
    
    
    #assert_redirect_to controller:
  end
 
  private
  
  def browse(user=nil)
    
    
  end
  
   module CustomDsl
    def browses_site
      get "/proposals"
      assert_response :success
      assert assigns(:proposals)
    end
  end
 
  def login(user)
    open_session do |sess|
     # sess.extend(CustomDsl)
    # u = users(user)
     # sess.https!
      response = post_via_redirect user_session_path, 'user[login]' => 'coorasse', 'user[password]' => 'coorasse'       
      puts response
      assert_equal alerts_path, path
      return users(:coorasse)
      #sess.https!(false)
    end
  end
 
end