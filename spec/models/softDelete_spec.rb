# A RSpec to test the functionality of the Item model methods and scope

require 'rails_helper'

RSpec.describe Item, type: :model do
# Testing soft_delete method by creating an item, soft deleting it, and checking that the deleted_at column is set to a Time object    
    it 'soft deletes an item' do
        item = Item.create(name: 'Test Apple')

        expect {
            item.soft_delete
    }.to change { item.reload.deleted_at }.from(nil).to be_a(Time)
    # Used type checking for Time class to ensure that the deleted_at is set to a Time object.
    # Cannnot use eq(Time.current) because the time will be different when the test runs its check.
    end
end