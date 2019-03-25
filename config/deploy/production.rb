server 'nutfes_np', port: 41639, roles: %w[web app db], primary: true
set :branch,        'deploy_setting'
set :stage,         :production
set :rails_env,     :production
set :ssh_options, {
    user:           'deploy',
    keys:           %w('~/.ssh/deploy_group_manager'),
    forward_agent:  true,
}
