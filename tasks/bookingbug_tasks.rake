namespace :bookingbug do
  
  desc 'Setup BookingBug in your rails application'
  task :setup do
    puts 'Setup BookingBug in your rails application'
    Rake::Task['bookingbug:bbug_migration'].invoke
    Rake::Task['bookingbug:copy_partials'].invoke
    Rake::Task['bookingbug:copy_bookingbug_config_file'].invoke
    Rake::Task['bookingbug:copy_resize_file'].invoke
  end
  
  desc 'Generate a migration for the Bookingbug table.'
  task :bbug_migration => :environment do
    raise "Task unavailable to this database (no migration support)" unless ActiveRecord::Base.connection.supports_migrations?
    ActiveRecord::Migration.create_table :bbug_companies do |t|
      t.string :affiliate_user_id, :limit => 50, :null => false
      t.string :bbug_company_id,  :limit => 50, :null => false
      t.string :bbug_company_name
      t.timestamp
    end
  end
  
  task :copy_partials do
    puts "Copying BookingBug view files."
    mkdir(File.join(RAILS_ROOT, "app/views/bookingbug")) unless File.exist?(File.join(RAILS_ROOT, "app/views/bookingbug"))
    view_file = '_signup.erb'
    FileUtils.cp_r(
      File.join(File.dirname(__FILE__), "../views/_signup.erb"),
      File.join(RAILS_ROOT, "app/views/bookingbug/", view_file)
    )

    view_file = '_login.erb'
    FileUtils.cp_r(
      File.join(File.dirname(__FILE__), "../views/_login.erb"),
      File.join(RAILS_ROOT, "app/views/bookingbug/", view_file)
    )
    
    puts "================================DONE==========================================="
  end
  
  task :copy_bookingbug_config_file do
    puts "Copying BookingBug YML file."
    config_file = 'bookingbug.yml'
    FileUtils.cp_r(
      File.join(File.dirname(__FILE__), "../bookingbug.yml"),
      File.join(RAILS_ROOT, "config/", config_file)
    )
  end
  
  task :copy_resize_file do
    puts "Copying Resize.html to public folder."
    resize_file = 'resize.html'
    FileUtils.cp_r(
      File.join(File.dirname(__FILE__), "../resize.html"),
      File.join(RAILS_ROOT, "public/", resize_file)
    )
  end
  
end
