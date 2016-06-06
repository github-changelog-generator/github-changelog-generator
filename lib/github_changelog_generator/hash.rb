class Hash
  def stringify_keys_deep!
    new_hash = {}
    keys.each do |k|
      ks    = k.respond_to?(:to_s) ? k.to_s : k
      if values_at(k).first.kind_of? Hash or values_at(k).first.kind_of? Array
        new_hash[ks] = values_at(k).first.send(:stringify_keys_deep!)
      else
        new_hash[ks] = values_at(k).first
      end
    end

    new_hash
  end
end