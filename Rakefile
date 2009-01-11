$: << File.join(File.dirname(__FILE__), 'lib')
require 'rubygems'
require 'rake/gempackagetask'
# # If this require failes, try "gem install rspec"
require 'spec/rake/spectask'

file_list = FileList['spec/*_spec.rb']

Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = file_list
end

desc 'Default: run specs.'
task :default => 'spec'

namespace :pants do
  task :init do
    $: << File.join(File.dirname(__FILE__), 'lib')
    require 'pants/models'
#    require 'pants/calendar_helper'
    require File.dirname(__FILE__) + '/config/pants.rb'
  end

  task :setup => :init do
    DataMapper.auto_migrate!
    puts "Database reset"
    
  end

  task :create_admin => :init do
    %w[ LOGIN EMAIL NAME ].each do |w|
      raise "Need ENV[#{w}]" if ENV[w].to_s.size.zero?
    end
    Pants::User.create(:login => ENV['LOGIN'], :email => ENV['EMAIL'], :name => ENV['NAME'], :admin => true, :trusted => true)
  end
end
