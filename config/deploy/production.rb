set :branch,        'deploy_setting'
set :stage,         'production'
set :rails_env,     'production'
set :migration_role, 'db'

role :app, %w{deploy@nutfes}
role :web, %w{deploy@nutfes}
role :db,  %w{deploy@nutfes}, :primary => true

server 'nutfes', user: 'deploy', roles: %w{web app db}

set :ssh_options, {
    keys: %w('~/.ssh/deploy_group_manager'),
    forward_agent: true,
}
