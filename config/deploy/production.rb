# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
#
servers = (ENV['APP_SERVERS'] || '').split(',').reject(&:empty?)
role :app, servers
role :web, servers
role :db,  servers
