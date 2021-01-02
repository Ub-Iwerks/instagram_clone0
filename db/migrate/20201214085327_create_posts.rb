class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :posts, [:user_id, :created_at] #ここ！！綴りミス。ただもう全部pushしてる。これを直して。developでpushするしかないかなー
  end
end
