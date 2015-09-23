# check for errors on a model. it explicitly validates the model and check for errors on a specific field
def expect_errors_on_model_field(model, field, count)
  model.valid?
  expect(model.errors[field].count).to eq count
end

def to_slug_format(string)
  string.downcase.gsub(' ', '-').gsub(',', '').gsub('.', '')
end
