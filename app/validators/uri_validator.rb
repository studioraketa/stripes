class UriValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    uri = URI.parse(value)

    add_error(record, attribute) if invalid_scheme?(uri)
  rescue URI::InvalidURIError
    add_error(record, attribute)
  end

  private

  def add_error(record, attribute)
    record.errors[attribute] << I18n.t('errors.messages.invalid')
  end

  def invalid_scheme?(uri)
    return false if uri.scheme.blank?

    uri.scheme != 'http' && uri.scheme != 'https'
  end
end
