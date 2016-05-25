class Array
  def stringify_keys_deep!
    new_ar = []
    each do |value|
      new_value = value
      if value.is_a?(Hash) || value.is_a?(Array)
        new_value = value.stringify_keys_deep!
      end
      new_ar << new_value
    end
    new_ar
  end
end
