class UserSettings < ActiveRecord::Migration
  include TutorialAssigneesHelper
  def up
    Step.reset_column_information
    remove_column :tutorials, :description
    Tutorial.reset_column_information
    t = Tutorial.create(action: 'show', controller: 'users', name: 'Setting Tutorial - Personal Info')
    t.steps.create(index: 0, title: 'Settings', required: false, fragment: 'users_show', format: 'js')
    User.all.each do |user|
      assign_tutorial(user,t)
    end

    t = Tutorial.create(action: 'alarm_preferences', controller: 'users', name: 'Setting Tutorial - Alarm Preferences')
    t.steps.create(index: 0, title: 'Alarm Preferences', required: false, fragment: 'users_alarm_preferences', format: 'js')
    User.all.each do |user|
      assign_tutorial(user,t)
    end

    t = Tutorial.create(action: 'border_preferences', controller: 'users', name: 'Setting Tutorial - Border Preferences')
    t.steps.create(index: 0, title: 'Border Preferences', required: false, fragment: 'users_border_preferences', format: 'js')
    User.all.each do |user|
      assign_tutorial(user,t)
    end

    t = Tutorial.create(action: 'privacy_preferences', controller: 'users', name: 'Setting Tutorial - Privacy Preferences')
    t.steps.create(index: 0, title: 'Privacy Preferences', required: false, fragment: 'users_privacy_preferences', format: 'js')
    User.all.each do |user|
      assign_tutorial(user,t)
    end

    t = Tutorial.create(action: 'statistics', controller: 'users', name: 'Statistics - Personal Info')
    t.steps.create(index: 0, title: 'Statistics', required: false, fragment: 'users_statistics', format: 'js')
    User.all.each do |user|
      assign_tutorial(user,t)
    end
  end

  def down
    Tutorial.find_by_action_and_controller('show','users').destroy
    Tutorial.find_by_action_and_controller('alarm_preferences','users').destroy
    Tutorial.find_by_action_and_controller('border_preferences','users').destroy
    Tutorial.find_by_action_and_controller('privacy_preferences','users').destroy
    Tutorial.find_by_action_and_controller('statistics','users').destroy
    add_column :tutorials, :description, :string
  end
end
