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

    # Default scope to return only items that have not been soft deleted in normal queries
    default_scope { where(deleted_at: nil) }
end
