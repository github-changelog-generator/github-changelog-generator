# frozen_string_literal: true
class Hash
  def stringify_keys_deep!
    new_hash = {}
    keys.each do |k|
      ks = k.respond_to?(:to_s) ? k.to_s : k
      new_hash[ks] = if values_at(k).first.is_a?(Hash) || values_at(k).first.is_a?(Array)
                       values_at(k).first.send(:stringify_keys_deep!)
                     else
                       values_at(k).first
                     end
    end

    new_hash
  end
end
