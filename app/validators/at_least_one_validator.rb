class AtLeastOneValidator < ActiveModel::Validator
  def validate(record)
    options[:associations].each do |assoc|
      record.errors[record.class.name] << 'La proposta deve contenere almeno una soluzione' if record.send(assoc).all?(&:marked_for_destruction?)
    end
  end
end
