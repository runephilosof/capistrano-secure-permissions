namespace :deploy do
  desc 'Secure app with file permissions'
  task :secure_permissions do
    on roles(:app) do |server|
      web_user = fetch(:web_user)
      app_user = fetch(:app_user)
      deploy_user = server.user
      linked_dirs = fetch(:linked_dirs)

      # Set parent folders accessable by web_user.
      parent_folders = [
        release_path,
        shared_path,
      ]
      parent_folders << "#{shared_path}/public" if linked_dirs.any? { |d| d.start_with?('public') }
      execute :setfacl, "-m", "u:#{web_user}:x,u:#{deploy_user}:rx", *parent_folders
      # Set all except public, tmp, and log readable by app_user.
      execute :find, release_path, '-regex', '\./\(public\|tmp\|log\)', '-prune', '-o', '-user', deploy_user, '-print0', '|', 'xargs', '-0', '--no-run-if-empty', 'setfacl', '-m', "u:#{app_user}:rX"
      # Set log and tmp writable by app_user.
      execute :find, '-L', "#{release_path}/log", "#{release_path}/tmp", '-user', deploy_user, '-print0', '|', 'xargs', '-0', '--no-run-if-empty', 'setfacl', '-m', "u:#{app_user}:rwX"
    end
  end

  after 'deploy:updated', 'deploy:secure_permissions'
end

namespace :secure_permissions do
  task :validate do
    on roles(:app) do
      if fetch(:app_user).nil?
        error "secure_permissions: app_user is not set"
        exit 1
      end
    end
  end

  desc 'Sets permissions on the public folder, only needs to be done once, not on every deploy. And there might be a lot of files, so it might take a while.'
  task :setup do
    on roles(:app) do |server|
      web_user = fetch(:web_user)
      app_user = fetch(:app_user)
      deploy_user = server.user

      # Set permissions for files in public, readable by web_user and writable by app_user.
      execute :find, '-L', "#{release_path}/public", '-user', deploy_user, '-not', '-type', 'l', '-print0', '|', 'xargs', '-0', '--no-run-if-empty', 'setfacl', '-m', "u:#{web_user}:rX,u:#{app_user}:rwX"
      # Set defaults for directories in public (that is permissions for new files made by the app).
      execute :find, "#{shared_path}/public", '-user', deploy_user, '-type', 'd', '-print0', '|', 'xargs', '-0', '--no-run-if-empty', 'setfacl', '-m', "d:u:#{web_user}:rX,d:u:#{app_user}:rwX"
    end
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'secure_permissions:validate'
end

namespace :load do
  task :defaults do
    set :web_user, 'www-data'
  end
end
