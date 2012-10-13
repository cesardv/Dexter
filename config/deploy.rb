#require 'bundler/capistrano'
set :user, 'deploy'

puts "Deploying to Production"

set :environment, 'production'
set :domain, '198.74.58.232'

set :scm, 'git'
set :repository,  "git@github.com:railsrumble/Dexter.git"
set :branch, 'master'
set :scm_verbose, true

# roles (servers)
role :web,    domain
role :app,    domain
role :db,     domain, :primary => true
role :worker, domain

# deploy config
set :deploy_to, "/var/www/dexter"
set :deploy_via, :remote_cache
set :keep_releases, 1

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows

ruby_binary_path = '/home/deploy/local/1.9.3-p194/bin'
set :default_environment, {
  'PATH' => "#{ruby_binary_path}:$PATH"
}


namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :migrate do
    run "cd #{release_path} && RAILS_ENV=#{environment} bundle exec rake db:migrate"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{release_path} && RAILS_ENV=#{environment} bundle exec rake assets:precompile"
    sudo "sh -c 'cd #{release_path} && ENV=#{environment} bundle exec bash unicorn_exec stop && ENV=#{environment} bundle exec bash unicorn_exec start'"
  end
end



namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(release_path, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
    
    # This line used to correct errors that happened as a result of Syck bugs.
    # Haven't needed to run it since updating to 1.9.2, but that doesn't mean
    # it doesn't need to be adjusted to support that.
    # run("perl -p -i -e 's/ 00:00:00.000000000Z//' /var/lib/gems/1.8/specifications/*.gemspec")
  end

  task :install, :roles => :app do
    run "cd #{release_path} && (bundle check || bundle install --local)"

    on_rollback do
      if previous_release
        run "cd #{previous_release} && bundle install --local"
      else
        logger.important "no previous release to rollback to, rollback of bundler:install skipped"
      end
    end
  end

  task :bundle_new_release, :roles => :db do
    bundler.create_symlink
    bundler.install
  end
end

after "deploy:rollback:revision", "bundler:install"
after "deploy:update_code", "bundler:bundle_new_release"

#after "deploy:create_symlink", "deploy:restart_workers"

def run_remote_rake(rake_cmd)
  rake_args = ENV['RAKE_ARGS'].to_s.split(',')

  cmd = "cd #{fetch(:latest_release)} && bundle exec #{fetch(:rake, "rake")} RAILS_ENV=#{environment} #{rake_cmd}"
  cmd += "['#{rake_args.join("','")}']" unless rake_args.empty?
  run cmd
  set :rakefile, nil if exists?(:rakefile)
end

namespace :deploy do
  desc "Restart Resque Workers"
  task :restart_workers, :roles => :worker do
    run_remote_rake "resque:restart_workers"
  end
end

