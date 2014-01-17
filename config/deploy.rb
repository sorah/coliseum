unless ENV['DEPLOY_TO'] && ENV['APP_SERVERS']
  abort 'To deploy, you must specify DEPLOY_TO and APP_SERVERS env'
end
# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'coliseum'
set :repo_url, 'git@github.com:sorah/coliseum.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, ENV['DEPLOY_TO']

set :pty, true

set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system tmp/puma}

set :default_env, { path: "/usr/local/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute '/etc/init.d/puma.coliseum', 'restart'
    end
  end
  after :publishing, :restart
end
