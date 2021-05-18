class CreateMediaLibraryTables < ActiveRecord::Migration<%= migration_version %>
  def change

    # create Media Object table
    create_table :media_objects do |t|
      t.string     :name, null: false
      t.text       :alt_text, null: false

      t.timestamps
    end

    # create Media Directory table
    create_table :media_directories do |t|
      t.string     :name, null: false

      t.timestamps
    end

    # Directories point to a parent directory (or null)
    add_reference :media_directories, :parent_directory, index: true, null: true

    # Directories with the same parent directory cannot have the same name
    add_index :media_directories, [:name, :parent_directory], unique: true

    # Media Objects [can] live in a directory :)
    add_reference :media_objects, :media_directory, null: true, foreign_key: true

  end
end
