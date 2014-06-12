def login(user, password)
  visit '/users/sign_in'
  within("#main-copy") do
    fill_in 'user_login', :with => user.email
    fill_in 'user_password', :with => password
    click_button 'Login'
  end
  expect(page.current_path).to eq('/')
  expect(page).to have_content(I18n.t('devise.sessions.user.signed_in'))
end

def fill_in_ckeditor(locator, opts)
  content = opts.fetch(:with).to_json
  page.execute_script <<-SCRIPT
    CKEDITOR.instances['#{locator}'].setData(#{content});
    $('textarea##{locator}').text(#{content});
  SCRIPT
end

def toastr_clear
  page.execute_script <<-SCRIPT
    toastr.clear();
  SCRIPT
end


def fill_tokeninput(locator, opts)
  content = opts.fetch(:with)
  content.each do |tag|
    page.execute_script <<-SCRIPT
      $('#{locator}').tokenInput('add', {id: '#{tag}', name: '#{tag}'});
    SCRIPT
  end
end


def page_should_be_ok
  expect(page).to_not have_content(I18n.t('error.error_500.title'))
  expect(page).to_not have_content(I18n.t('error.error_302.title'))
  expect(page).to_not have_content(I18n.t('error.error_404.title'))
end

def create_participation(user,group)
  group.participation_requests.build(user: user,group_participation_request_status_id: 3)
  group.group_participations.build(user: user,participation_role_id: group.participation_role_id)
  group.save
end

def create_public_proposal(user_id)
  create(:public_proposal, quorum: BestQuorum.public.first, current_user_id: user_id)
end

def activate_areas(group)
  group.enable_areas = true
  create(:group_area, group: group)
  create(:group_area, group: group)
  group.save
  group.reload
end

def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    loop until finished_all_ajax_requests?
  end
end

def finished_all_ajax_requests?
  page.evaluate_script('jQuery.active').zero?
end