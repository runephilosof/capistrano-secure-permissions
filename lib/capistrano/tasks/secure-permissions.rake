namespace :deploy do
  desc 'Secure app with file permissions'
  task :secure_permissions do
    on roles(:all) do
      web_user = fetch(:web_user)
      app_user = fetch(:app_user)
      execute :setfacl, "-m", "u:www-data:x", "#{release_path}", "#{shared_path}", "#{shared_path}/public"
      execute :setfacl, '--logical', '--recursive', '-m', "u:#{web_user}:rX,d:u:#{web_user}:rX,u:#{app_user}:rwX,d:u:#{app_user}:rwX", "#{release_path}/public"
      execute :setfacl, '--logical', '--recursive', '-m', "d:u:#{app_user}:rX,u:#{app_user}:rX", "#{release_path}", "#{shared_path}"
      execute :setfacl, '--logical', '--recursive', '-m', "d:u:#{app_user}:rwX,u:#{app_user}:rwX", "#{release_path}/log", "#{release_path}/tmp"
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
