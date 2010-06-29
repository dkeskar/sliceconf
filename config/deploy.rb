# Server-specific roles and settings for deployment
# Example
# role :app, "a1.example.com",  "a2.example.com" 
# role :web, "web.example.com"
# role :storage, "db.example.com"
load 'config/server_roles'

set :user, "app"

# In some cases (e.g. apt commands) capistrano invokes sh -c sudo -p 
# We need to suppress the "sudo_password" string. 
set :sudo_prompt, ""

# Sometimes, cap or sprinkle prompts for password. Need to figure out how to 
# suppress it. This does not happen for all commands
# set :use_sudo, false

set :user_home, "/home/app"
default_run_options[:pty] = true
