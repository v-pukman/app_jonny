lock '3.4.1'

set :application, 'app_jonny'
set :repo_url, 'git@gitlab.com:vctr_uniq/app_jonny2.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/home/deploy/app_jonny'

set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid,  "#{deploy_to}/shared/pids/unicorn.pid"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :keep_releases, 3

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
      execute "if [ -f #{fetch(:unicorn_pid)} ] && [ -e /proc/$(cat #{fetch(:unicorn_pid)}) ]; then kill -USR2 `cat #{fetch(:unicorn_pid)}`; else cd #{fetch(:deploy_to)}/current && bundle exec unicorn_rails -c #{fetch(:unicorn_conf)} -E #{fetch(:rails_env)} -D; fi"
    end
  end

  # desc "Update crontab with whenever"
  # task :update_cron do
  #   on roles(:app) do
  #     within current_path do
  #       execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)}"
  #     end
  #   end
  # end

  # desc "Create backup symlink"
  # task :create_backup_sym do
  #   on roles(:app) do
  #     within current_path do
  #       execute :ln, "-s /home/backup/app_jonny_backup /home/deploy/app_jonny/current/app_jonny_backup"
  #     end
  #   end
  # end


  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
  #after :finishing, 'deploy:update_cron'
  #after :finishing, 'deploy:create_backup_sym'
end
