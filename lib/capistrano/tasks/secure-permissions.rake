namespace :deploy do
  desc 'Secure app with file permissions'
  task :secure_permissions do
    on roles(:all) do |server|
      web_user = fetch(:web_user)
      app_user = fetch(:app_user)
      deploy_user = server.user

      # Set parent folders accessable by web_user.
      execute :setfacl, "-m", "u:#{web_user}:x", "#{release_path}", "#{shared_path}", "#{shared_path}/public"
      # Set all except public, tmp, and log readable by app_user.
      execute :find, release_path, '-regex', '\./\(public\|tmp\|log\)', '-prune', '-o', '-user', deploy_user, '-print0', '|', 'xargs', '-0', 'setfacl', '-m', "u:#{app_user}:rX"
      # Set permissions for files in public, readable på web_user and writable by app_user.
      execute :find, '-L', "#{release_path}/public", '-user', deploy_user, '-not', '-type', 'l', '-print0', '|', 'xargs', '-0', 'setfacl', '-m', "u:#{web_user}:rX,u:#{app_user}:rwX"
      # Set defaults for directories in public (that is permissions for new files made by the app).
      execute :find, "#{release_path}/public", '-user', deploy_user, '-type', 'd', '-print0', '|', 'xargs', '-0', 'setfacl', '-m', "d:u:#{web_user}:rX,d:u:#{app_user}:rwX"
      # Set log and tmp writable by app_user.
      execute :find, '-L', "#{release_path}/log", "#{release_path}/tmp", '-user', deploy_user, '-print0', '|', 'xargs', '-0', 'setfacl', '-m', "u:#{app_user}:rwX"
    end
  end

  after 'deploy:updated', 'deploy:secure_permissions'
end

namespace :secure_permissions do
  task :validate do
    on roles(:all) do
      if fetch(:app_user).nil?
        error "secure_permissions: app_user is not set"
        exit 1
      end
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
