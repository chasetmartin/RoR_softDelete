require 'rails_helper'

RSpec.describe Item, type: :model do
    # Testing restore method by creating an item, soft deleting it then restoring it, and checking that the deleted_at column is once again nil
    it 'restores a soft deleted item' do
        item = Item.create(name: 'Test Pear')
        item.soft_delete

        expect {
            item.restore
    }.to change { item.reload.deleted_at }.from(be_a(Time)).to(nil)
    end
end