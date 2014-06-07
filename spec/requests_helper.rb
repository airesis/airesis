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


def fill_tokeninput(locator, opts)
  content = opts.fetch(:with)
  content.each do |tag|
    page.execute_script <<-SCRIPT
      $('#{locator}').tokenInput('add', {id: '#{tag}', name: '#{tag}'});
    SCRIPT
  end
end