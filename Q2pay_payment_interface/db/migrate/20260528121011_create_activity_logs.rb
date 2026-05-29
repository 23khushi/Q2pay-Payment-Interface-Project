class CreateActivityLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_logs do |t|
      t.references :user,type: :uuid,  null: false, foreign_key: true
      t.string :action
      t.references :loggable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
