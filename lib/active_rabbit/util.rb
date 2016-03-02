# Because we don't want to import ActiveSupport
module ActiveRabbit::Util
  def self.hash_only_keys(hash, *only_keys)
    new_hash = {}
    union_keys = hash.keys | only_keys
    union_keys.each do |key|
      new_hash[key] = hash[key]
    end
    return new_hash
  end

  def self.hash_except_keys(hash, *except_keys)
    new_hash = {}
    new_keys = hash.keys - except_keys
    new_keys.each do |key|
      new_hash[key] = hash[key]
    end
    return new_hash
  end

  def self.string_underscore(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end

  def self.string_camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    else
      lower_case_and_underscored_word.first + camelize(lower_case_and_underscored_word)[1..-1]
    end
  end

  def self.string_constantize(camel_cased_word)
    unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ camel_cased_word
      raise NameError, "#{camel_cased_word.inspect} is not a valid constant name!"
    end

    Object.module_eval("::#{$1}", __FILE__, __LINE__)
  end
end
