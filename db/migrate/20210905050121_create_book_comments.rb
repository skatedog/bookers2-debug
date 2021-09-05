class CreateBookComments < ActiveRecord::Migration[5.2]
  def change
    create_table :book_comments do |t|
      t.text :body
      t.string :user_id
      t.string :book_id

      t.timestamps
    end
  end
end
