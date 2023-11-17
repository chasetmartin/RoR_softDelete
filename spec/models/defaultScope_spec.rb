require 'rails_helper'

RSpec.describe Item, type: :model do
    # Testing default scope by creating an item, soft deleting it, and checking that the Item.all query does not include item
    it 'returns only non-deleted items within default scope' do
        item = Item.create(name: 'Test Orange')
        item.soft_delete
        #Active item that default scope should include
        activeitem = Item.create(name: 'Test Banana')

        expect(Item.all).not_to include(item)
        expect(Item.all).to include(activeitem)
    end
end