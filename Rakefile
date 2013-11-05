require 'rake/testtask'
require 'bundler/gem_tasks'

Rake::TestTask.new do |t|
  t.test_files = FileList['spec/unit/*_spec.rb']
  t.verbose = true
end

# TODO fix this because at the moment it fails. Mocks appear to be leaking
# into the integration tests, why I don't know
# Rake::TestTask.new do |t|
#   t.name = 'test:all'
#   t.test_files = FileList['spec/*/*_spec.rb']
#   t.verbose = true
# end

Rake::TestTask.new do |t|
  t.name = 'test:integration'
  t.test_files = FileList['spec/integration/*_spec.rb']
  t.verbose = true
end

# HACK work around the leaking mock problem by running integration tests
# before unit tests
task 'test:all' do
  Rake::Task['test:integration'].invoke
  Rake::Task['test'].invoke
end