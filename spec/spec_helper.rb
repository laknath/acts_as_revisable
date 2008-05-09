begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

if ENV['EDGE_RAILS_PATH']
  edge_path = File.expand_path(ENV['EDGE_RAILS_PATH'])
  require File.join(edge_path, 'activesupport', 'lib', 'active_support')
  require File.join(edge_path, 'activerecord', 'lib', 'active_record')
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'acts_as_revisable'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :projects do |t|
      t.string :name, :unimportant, :revisable_name, :revisable_type
      t.text :notes
      t.boolean :revisable_is_current
      t.integer :revisable_original_id, :revisable_branched_from_id, :revisable_number
      t.datetime :revisable_current_at, :revisable_revised_at, :revisable_deleted_at
      t.timestamps
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

def cleanup_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.execute("delete from #{table}")
  end
end