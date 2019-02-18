server '153.126.171.228', port: 41639, roles: %w[web app db], primary: true
set :branch,        'develop'
set :stage,         :production
set :rails_env,     :production
set :ssh_options, {
    user:           'deploy',
    keys:           %w('~/.ssh/deploy_group_manager'),
    forward_agent:  true,
}

