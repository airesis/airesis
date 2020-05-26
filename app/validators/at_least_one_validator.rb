class AtLeastOneValidator < ActiveModel::Validator
  def validate(record)
    options[:associations].each do |assoc|
      if record.send(assoc).all?(&:marked_for_destruction?)
        record.errors[record.class.name] << 'La proposta deve contenere almeno una soluzione'
      end
    end
  end
end
