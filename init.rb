require 'redmine'
require_dependency 'redmine_omniauth_openid_connect/hooks'

Redmine::Plugin.register :redmine_omniauth_openid_connect do
  name 'Redmine Omniauth OpenID Connect Plugin'
  author 'Elry'
  description 'This plugin enables login through OpenID Connect'
  version '1.0.2'
  url 'https://github.com/terah-digital/redmine_omniauth_openid_connect.git'
  author_url 'https://elry.com.au'

  settings :default => {
    :authorize_url => "",
    :token_url => "",
    :api_url => "",
    :client_id => "",
    :client_secret => "",
    :scope => "",
    :oauth_autentification => true,
    :allowed_domains => "",
    :login_button_text => "Login with OAuth",
  }, :partial => 'settings/openid_connect_settings'
end
