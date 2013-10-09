require 'rubygems'
require 'watir-webdriver'

browser = Watir::Browser.new

Given(/^I am on the root page$/) do
  browser.goto 'http://localhost:3000'
  #pending # express the regexp above with the code you wish you had
end

Given(/^I type in email and password$/) do
  #User.create!(:email=>"psygon@roar.com",:password=>"bidyut123",:name=>"psygon",:surname=>"psygon",:login=>"psygon",:receive_newsletter=>false,:sys_locale_id=>1)
  browser.text_field(:id => 'user_login').when_present.set 'fakeemailaddress+55@fake.fake'
  browser.text_field(:id => 'user_password').when_present.set 'rakesh123'
  #pending # express the regexp above with the code you wish you had
end

Given(/^I click on login button "(.*?)"$/) do |arg1|
  browser.button(:class => 'btn btn-success btn-large').when_present.click
  #pending # express the regexp above with the code you wish you had
end

Then(/^I should be on the home page$/) do
  browser.url.should == "http://localhost:3000/home"
  #pending # express the regexp above with the code you wish you had
end

When(/^I click on link Groups$/) do  
  browser.span(:text=>"GROUPS").when_present.click
  #pending # express the regexp above with the code you wish you had
end

When(/^I click on link PROPOSALS$/) do
  browser.div(:class=>"p2").link(:text=>"PROPOSALS").when_present.click
  #pending # express the regexp above with the code you wish you had
end


Then(/^I should be on the proposals page$/) do
  browser.url.should ==  'http://localhost:3000/proposals'
  #pending # express the regexp above with the code you wish you had
end


When(/^I click on button Create a proposal$/) do
  browser.div(:id=>"menu-left").link(:id=>"nuova_proposta").when_present.click  
  #pending # express the regexp above with the code you wish you had
end

Then(/^Initial information tab must be active on pop up$/) do
  browser.li(:class=>"bread-crumb-active").div(:class=>"first step_title").exists?
  #pending # express the regexp above with the code you wish you had
end

When(/^I Provide Title$/) do    
  browser.text_field(:placeholder=>"ex. 'Facilitate bike transport on trains'").when_present.set "#{(0...8).map { (65 + rand(26)).chr }.join}"
  #browser.input(:name=>"proposal[title]").set "#{(0...8).map { (65 + rand(26)).chr }.join}"
  #browser.text_field(:id=>"proposal_title").set "#{(0...8).map { (65 + rand(26)).chr }.join}"
  #pending # express the regexp above with the code you wish you had
end

When(/^I select a category$/) do
  browser.link(:class=>"dd-selected").label(:class=>"dd-selected-text").when_present.click
  browser.label(:text=>"Uncategorized").when_present.click   
  #pending # express the regexp above with the code you wish you had
end

When(/^click button Next$/) do
  browser.button(:id=>"form-wizard-next").when_present.click
  #pending # express the regexp above with the code you wish you had
end

Then(/^Problems and objectives tab must be active on pop up$/) do  
  browser.li(:class=>"bread-crumb-active").div(:text=>"Problems and objectives").exists?
  #pending # express the regexp above with the code you wish you had
end

When(/^I Type into the text editor$/) do
browser.frame(:id,'proposal_sections_attributes_0_paragraphs_attributes_0_content_ifr').send_keys "testing"
  #pending # express the regexp above with the code you wish you had
end

Then(/^Creation of the proposal tab must be active$/) do
  browser.li(:class=>"bread-crumb-active").div(:text=>"Creation of the proposal").exists?
  #pending # express the regexp above with the code you wish you had
end

Then(/^I click on select a quorum drop down$/) do
  browser.label(:text=>"Select quorum").when_present.click
end

Then(/^I click on Create the proposal button$/) do  
  browser.label(:text=>"1 giorno").when_present.click
  browser.input(:value=>"Create the proposal").when_present.click
  #pending # express the regexp above with the code you wish you had
end

Then(/^I should be asked to update the proposal$/) do
  browser.h1(:text => /^Edit the proposal/).wait_until_present
  browser.input(:value=>"Update").when_present.click
  #pending # express the regexp above with the code you wish you had
end

Then(/^I should see the new proposal$/) do
  sleep 5
  browser.close
  #pending # express the regexp above with the code you wish you had
end



