#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rake/testtask"
require "appraisal"

Rake::TestTask.new do |t|
  t.libs.concat %w(keynote spec)
  t.pattern = "spec/*_spec.rb"
end

task :default => [:test]
