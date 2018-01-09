def login(user, password)
  visit '/users/sign_in'
  within('#main-copy') do
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: password
    click_button 'Login'
  end
  expect(page.current_path).to eq('/')
  expect(page).to have_content(I18n.t('devise.sessions.user.signed_in'))
end

def fill_in_ckeditor(locator, opts)
  content = opts.fetch(:with).to_json
  page.execute_script <<-SCRIPT
    var ckeditor = CKEDITOR.instances['#{locator}'];
    ckeditor.setData(#{content});
    ckeditor.focus();
    ckeditor.updateElement();
    $('textarea##{locator}').text(#{content});
    console.log($('textarea##{locator}').text());
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

def scroll_to(element)
  script = <<-JS
      arguments[0].scrollIntoView({block: 'center', inline: 'center'});
  JS
  Capybara.current_session.driver.browser.execute_script(script, element.native)
end


def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    loop until finished_all_ajax_requests?
  end
end

def finished_all_ajax_requests?
  page.evaluate_script('jQuery.active').zero?
end

def expect_sign_in_page
  expect(page.current_path).to eq('/users/sign_in')
end

def expect_forbidden_page
  expect(page).to have_content(I18n.t('error.error_302.title'))
end

def expect_notifications(number = 1)
  expect(page.title).to have_content "(#{number})"
end

def expect_message(message)
  expect(page).to have_content(message)
end

def within_left_menu
  within('#menu-left') do
    yield
  end
end

def within_first_post
  within('#posts #post_1') do
    yield
  end
end

def within_second_post
  within('#posts #post_2') do
    yield
  end
end
