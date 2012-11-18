#!/usr/bin/env rake

require "bundler/gem_tasks"
require "rake/testtask"
require "appraisal"
require "yard"

Rake::TestTask.new do |t|
  t.libs.concat %w(keynote spec)
  t.pattern = "spec/*_spec.rb"
end

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
end

task :default => [:test]
