#name, sell_in, quality
require_relative '../lib/gilded_rose'

describe "#update_quality" do

  context "with a single item" do
    let(:item) { Item.new('item', 5, 10) }
    let(:item_to_be_corrected) { Item.new('item', 4, 100) }

    it "While sell_in is greater than 0, sell_in and quality degrade by 1 per day" do
      update_quality([item])
      expect(item.sell_in).to eq(4)
      expect(item.quality).to eq(9)
    end

    it "After sell_in is less than 0, quality degrades by 2 per day" do
      6.times { update_quality([item]) }
      expect(item.sell_in).to eq(-1)
      expect(item.quality).to eq(3)
    end

    it "quality can not drop below 0" do
      8.times { update_quality([item]) }
      expect(item.sell_in).to eq(-3)
      expect(item.quality).to eq(0)
    end

    it "except for Sulfaras, quality cannot exceed 50" do
      update_quality([item_to_be_corrected])
      expect(item_to_be_corrected.sell_in).to eq(3)
      expect(item_to_be_corrected.quality).to eq(50)
    end

  end

  context 'with conjured items' do
    let(:conjured_item) { Item.new('Conjured item', 1, 8) }

    it "While sell_in is greater than 0, sell_in and quality degrade by 2 per day" do
      update_quality([conjured_item])
      expect(conjured_item.sell_in).to eq(0)
      expect(conjured_item.quality).to eq(6)
    end

    it "After sell_in is less than 0, quality degrades by 4 per day" do
      2.times { update_quality([conjured_item]) }
      expect(conjured_item.sell_in).to eq(-1)
      expect(conjured_item.quality).to eq(2)
    end

  end

  context 'with Sulfaras, Hand of Ragnaros' do
    let(:sulfaras) { Item.new('Sulfaras, Hand of Ragnaros', 5, 80) }

    it "sulfaras quality is always 80; quality and sell_in never degrade" do
      2.times { update_quality([sulfaras]) }
      expect(sulfaras.sell_in).to eq(5)
      expect(sulfaras.quality).to eq(80)
    end

  end

  context 'with backstage passes' do
    let(:backstage_passes) { Item.new('Backstage passes to a TAFKAL80ETC concert', 12, 12) }

    it "While sell_in is greater than 10, quality increases by 1 per day" do
      update_quality([backstage_passes])
      expect(backstage_passes.sell_in).to eq(11)
      expect(backstage_passes.quality).to eq(13)
    end

    it "While sell_in is greater than or equal to 10 and less than 5, quality increases by 2 per day" do
      3.times { update_quality([backstage_passes]) }
      expect(backstage_passes.sell_in).to eq(9)
      expect(backstage_passes.quality).to eq(16)
    end

    it "While sell_in is less than or equal to 5 and greater than 0, quality increases by 3 per day" do
      8.times { update_quality([backstage_passes]) }
      expect(backstage_passes.sell_in).to eq(4)
      expect(backstage_passes.quality).to eq(27)
    end

    it "When sell_in is less than 0, quality drops to 0" do
      13.times { update_quality([backstage_passes]) }
      expect(backstage_passes.sell_in).to eq(-1)
      expect(backstage_passes.quality).to eq(0)
    end

  end

  context 'with aged brie' do
    let(:aged_brie) { Item.new('Aged Brie', 3, 48) }

    it "quality increased by one per day" do
      update_quality([aged_brie])
      expect(aged_brie.sell_in).to eq(2)
      expect(aged_brie.quality).to eq(49)
    end

    it "quality cannot increase past 50" do
      3.times { update_quality([aged_brie]) }
      expect(aged_brie.sell_in).to eq(0)
      expect(aged_brie.quality).to eq(50)
    end

  end

  context "with multiple items" do
    let(:items) {
      [
        Item.new("Aged Brie", 3, 10),
        Item.new("NORMAL ITEM", 5, 10),
      ]
    }

    before { update_quality(items) }

    it "processes multiple items normally when they're passed in as an array" do
      expect(items[1].sell_in).to eq(4)
      expect(items[1].quality).to eq(9)
      expect(items[0].sell_in).to eq(2)
      expect(items[0].quality).to eq(11)
    end
  end

end
