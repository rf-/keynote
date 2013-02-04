# encoding: UTF-8

require "rake/testtask"
require "minitest/rails/testing"
require "minitest/rails/tasks/sub_test_task"

MiniTest::Rails::Testing.default_tasks << "presenters"

namespace "minitest" do
  unless Rake::Task.task_defined? "minitest:presenters"
    desc "Runs tests under test/presenters"
    MiniTest::Rails::Tasks::SubTestTask.new("presenters" => "test:prepare") do |t|
      t.libs.push "test"
      t.pattern = "test/presenters/**/*_test.rb"
      t.options = MiniTest::Rails::Testing.task_opts["presenters"] if MiniTest::Rails::Testing.task_opts["presenters"]
    end
  end
end
