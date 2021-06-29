class AddReferencesToComments < ActiveRecord::Migration[6.1]
  def change
    add_reference :comments, :diary, null: false, foreign_key: true
  end
end
