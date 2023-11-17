# Ruby on Rails: Item model with soft_delete, restore, and scope

### Follow the steps below to clone the respository, create the database, run the RSpec tests, and run the dev server to see implementation in the app.

### I will also explain my code below the cloning instructions
Ruby version 3.2.2
Rails version 7.1.2

**Clone the repository:**
```bash
git clone https://github.com/chasetmartin/RoR_softDelete.git
```
```bash
cd RoR_softDelete
```
**Install the dependencies**
```bash
bundle install
```
**Setup and seed the SQLite3 database**
```bash
rails db:setup
```
**Run all three RSpec test files that test soft_delete, restore, and the active scope**
```bash
bundle exec rspec -f documentation
```
**Precompile assets so TailwindCSS works on first app build**
```bash
rails assets:precompile
```
**Run the Puma server to see the Item and its methods implemented**
```bash
rails server
```
## Navigate to localhost:3000 in your web browser, app is basically styled with TailwindCSS
# Code Review
## Model Creation
#### Used the Rails scaffolding tool to generate an Item model with name(string) and deleted_at(datetime) attributes and scaffold the necessary views and controller actions. The first migration file being:
```rb
class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
```
## Soft Delete, Restore, and Scope
#### Added the following methods and scope to my Item model:
- soft_delete to update the delete_at time to the current time
- restore to update the delte_at time to nil
- created a default scope called "active" to only return items where deleted_at is nil
```rb
class Item < ApplicationRecord
    validates :name, presence: true

    # Soft delete method to update deleted_at column to the current time soft_delete is called
    def soft_delete
        update(deleted_at: Time.current)
    end

    # Restore method to set deleted_at column to nil
    def restore
        update(deleted_at: nil)
    end

    # Default scope to return only items that have not been soft deleted
    scope :active, -> { where(deleted_at: nil) }
end
```
## RSpec Testing
#### Added three RSpec test files, one to test each new method and scope:
#### Each file is commented to explain the test reasoning
##### softDelete_spec.rb
```rb
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
```
##### restore_spec.rb
```rb
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
```
##### activeScope_spec.rb
```rb
require 'rails_helper'

RSpec.describe Item, type: :model do
    # Testing active scope by creating an item, soft deleting it, and checking that Item.active does not include item
    it 'returns only active items' do
        item = Item.create(name: 'Test Orange')
        item.soft_delete
        #Active item that active scope should include
        activeitem = Item.create(name: 'Test Banana')

        expect(Item.active).not_to include(item)
        #This is like a double check to make sure .active does include what should be an active item
        expect(Item.active).to include(activeitem)
    end
end
```
# Next Step
#### After testing I quickly added the methods and scope to my items.controller so that I could implement them with my CRUD views
##### New/changed sections of my items.controller
```rb
  # Update index method to only return active items useing the active scope from Item model
  def index
    @items = Item.active
  end

  # DELETE /items/1 or /items/1.json
  # Update destroy method to soft_delete item
  def destroy
    @item = Item.find(params[:id])
    @item.soft_delete

    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully soft-deleted." }
      format.json { head :no_content }
    end
  end

  # PUT /items/1/restore
  # Add restore method to restore soft-deleted item
  def restore
    @item = Item.find(params[:id])
    @item.restore

    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully restored." }
      format.json { head :no_content }
    end
  end

  # GET /items/deleted or /items/deleted.json
  # Added controller action to GET soft-deleted trash can items
  def deleted
    @items = Item.where.not(deleted_at: nil)
  end
```
#### I implemented a simple "trash can" so that the user can access the soft-deleted items, and I updated the show.html.erb file to include either the restore or soft_delete button based on the deleted_at attribute.
##### show.html.erb
```erb
<div class="flex flex-col items-center justify-center min-h-screen bg-gray-100">
  <p class="text-green-500"><%= notice %></p>

  <div class="w-full max-w-md p-4 bg-white rounded shadow-md">
    <%= render @item %>

    <div class="mt-4">
      <%= link_to "Edit this item", edit_item_path(@item), class: "mr-2 text-blue-500 hover:underline" %> |
      <%= link_to "Back to items", items_path, class: "text-blue-500 hover:underline" %>

      <%# Check if deleted_at is present, if so display restore button, else display soft delete button %>
      <% if @item.deleted_at.present? %>
        <%= button_to "Restore this item", restore_item_path(@item), method: :put, class: "ml-2 px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600" %>
        <p>Soft deleted at <%= @item.deleted_at %></p>
      <% else %>
        <%= button_to "Soft Delete", @item, method: :delete, class: "ml-2 px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600" %>
      <% end %>
    </div>
  </div>
</div>
```
