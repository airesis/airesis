RSpec.configure do |config|
  config.before do
    # disable creation of tutorials during tests
    allow_any_instance_of(User).to receive(:assign_tutorials)
  end
end
