# config valid only for current version of Capistrano
lock "3.7.2"

server '10.10.1.160', roles: [:web, :app, :db], primary: true

set :application, "capistrano.kendallhunt.com"
set :repo_url, "git@github.com:mkroenckekh/drupal_sandbox.git"
set :user,		"deploy"
set :app_path, "html"
set :linked_files, fetch(:linked_files, []).push('html/sites/default/settings.php')
set :linked_dirs, fetch(:linked_dirs, []).push('html/sites/default/files', 'private-files')

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :staging
set :deploy_via,      :remote_cache
set :deploy_to,       "/var/www/#{fetch(:application)}"
set :ssh_options,     { forward_agent: false, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }


# Map Composer and Drush
Rake::Task['deploy:updated'].prerequisites.delete('composer:install')
SSHKit.config.command_map[:composer] = "#{deploy_to}/shared/composer.phar"
SSHKit.config.command_map[:drush] = "#{deploy_to}/shared/vendor/bin/drush"
