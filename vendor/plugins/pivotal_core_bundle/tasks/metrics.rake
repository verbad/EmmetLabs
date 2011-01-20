namespace :metrics do
  desc "generate a coverage report for tests in log/coverage; see log/coverage/index.html afterwards"
  task :rails_coverage do
    require 'rake/clean'
    # TODO: couldn't get CLOBBER to work, just did a shell command instead...
    # output directory - removed with "rake clobber" (needs a "require 'rake/clean'" above)
    CLOBBER.include("log/coverage/**/*")
    sh "rm -rf log/coverage"
    sh "rcov --output log/coverage test/test_suite.rb"
  end

  desc "generate a selenium coverage report for tests in log/selenium-coverage; see log/selenium-coverage/index.html afterwards"
  task :selenium_coverage do
    require 'rake/clean'
    # TODO: couldn't get CLOBBER to work, just did a shell command instead...
    # output directory - removed with "rake clobber" (needs a "require 'rake/clean'" above)
    CLOBBER.include("log/selenium-coverage/**/*")
    sh "rm -rf log/selenium-coverage"
    sh "rcov --output log/selenium-coverage test/selenium/selenium_suite.rb"
  end
end

