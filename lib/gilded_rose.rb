#name, sell_in, quality
def update_quality(items)
  items.each do |item|
    name = item.name
    case
    when name == 'Sulfaras, Hand of Ragnaros' then next
    when name == 'Aged Brie' then update_aged_brie(item)
    when name.match(/Backstage passes/) then update_backstage_passes(item)
    when name.match(/Conjured/) then update_conjured_item(item)
    else update_item(item)
    end
    fix_illegal_values(item)
  end
end

def update_aged_brie(item)
  update_attributes(item, -1, 1)
end

def update_backstage_passes(item)
  case
  when item.sell_in > 10 then update_attributes(item, -1, 1)
  when item.sell_in > 5 then update_attributes(item, -1, 2)
  when item.sell_in > 0 then update_attributes(item, -1, 3)
  else update_attributes(item, -1, -item.quality)
  end
end

def update_conjured_item(item)
  item.sell_in <= 0 ? update_attributes(item, -1, -4) : update_attributes(item, -1, -2)
end

def update_item(item)
  item.sell_in <= 0 ? update_attributes(item, -1, -2) : update_attributes(item, -1, -1)
end

def update_attributes(item, sell_in_mod, quality_mod)
  item.sell_in += sell_in_mod
  item.quality += quality_mod
end

def fix_illegal_values(item)
  item.quality = item.quality > 50 ? 50 : item.quality < 0 ? 0 : item.quality
end

######### DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)
