get 'openid_connect', :to => 'redmine_oauth#openid_connect'
get 'oauth2callback', :to => 'redmine_oauth#openid_connect_callback', :as => 'openid_connect_callback'
