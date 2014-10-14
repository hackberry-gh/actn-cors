require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/test*.rb']    
end

task :default => :test

ENV['DATABASE_URL'] ||= "postgres://localhost:5432/actn_#{ENV['RACK_ENV'] ||= "development"}" 

require 'actn/db'
require 'actn/jobs'
require 'actn/api'

load "actn/db/tasks/db.rake"
load "actn/jobs/tasks/jobs.rake"
