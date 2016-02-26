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
end