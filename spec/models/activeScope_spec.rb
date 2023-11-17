require 'rails_helper'

RSpec.describe Item, type: :model do
    # Testing active scope by creating an item, soft deleting it, and checking that the active scope returns nothing since the only item was soft deleted
    it 'returns only active items' do
        item = Item.create(name: 'Test Orange')
        item.soft_delete
        #Active item that active scope should include
        activeitem = Item.create(name: 'Test Banana')

        expect(Item.active).not_to include(item)
        expect(Item.active).to include(activeitem)
    end
end