namespace :deploy do
  desc 'Secure app with file permissions'
  task :secure_permissions do
    on roles(:app) do |server|
      web_user = fetch(:web_user)
      app_user = fetch(:app_user)

      execute :setfacl, '-m', "u:#{web_user}:x", release_path
      # This is before symlinking, so we can do this recursively.
      execute :setfacl, '-R', '-m', "u:#{web_user}:rx", release_path.join('public')
      execute :setfacl, '-R', '-m', "u:#{app_user}:rx,d:u:#{app_user}:rx", release_path
    end
  end

  before 'deploy:symlink:shared', 'deploy:secure_permissions'
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

  desc 'Sets permissions on the shared folders, only needs to be done once, not on every deploy. And there might be a lot of files, so it might take a while.'
  task :setup do
    on roles(:app) do |server|
      web_user = fetch(:web_user)
      app_user = fetch(:app_user)
      deploy_user = server.user
      # Public is writable by app_user by default, so exclude that one.
      # To avoid going through the files twice.
      writable_dirs = fetch(:writable_dirs, fetch(:linked_dirs)).
        map { |dir| shared_path.join(dir) }.
        delete_if { |dir| dir.start_with?('public/') }
      # All of shared readable by app_user.
      readable_dirs = shared_path.children().map(&:basename) - writable_dirs

      execute :setfacl, '-m', "u:#{web_user}:x,d:u:#{web_user}:x,u:#{app_user}:rx,d:u:#{app_user}:rx", shared_path
      execute :setfacl, '-R', '-m', "u:#{app_user}:rx,d:u:#{app_user}:rx", *readable_dirs
      # Set permissions for files in public, readable by web_user and writable by app_user.
      # Also make sure that deploy_user retains access, to the files that app_user creates.
      execute :setfacl, '-R', '-m', "u:#{web_user}:rx,u:#{app_user}:rwx,u:#{deploy_user}:rwx,d:u:#{deploy_user}:rwx,d:u:#{web_user}:rx,d:u:#{app_user}:rwx", shared_path.join('public')
      # Allow app_user access to writable_dirs in shared
      # Also make sure that deploy_user retains access, to the files that app_user creates.
      execute :setfacl, '-R', '-m', "u:#{app_user}:rwx,d:u:#{app_user}:rwx", *writable_dirs
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
