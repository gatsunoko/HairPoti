module MunicipalityWhere
  def municipality_where(address, prefecture)
    Municipality.all.each do |municipality|
      if address.include?(prefecture+municipality.name)
        return municipality.id
      end
    end
    return nil
  end

  def prefecture_where(address)
    Prefecture.all.each do |prefecture|
      if address.include?(prefecture.name)
        return prefecture.id
      end
    end
    return nil
  end
end