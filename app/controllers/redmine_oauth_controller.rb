require 'account_controller'
require 'json'

class RedmineOauthController < AccountController
  include Helpers::MailHelper
  include Helpers::Checker

  def openid_connect
    if Setting.plugin_redmine_omniauth_openid_connect[:oauth_authentication]
      session[:back_url] = params[:back_url]
      redirect_to oauth_client.auth_code.authorize_url(:redirect_uri => openid_connect_callback_url, :scope => settings[:scope])
    else
      password_authentication
    end
  end

  def openid_connect_callback
    if params[:error]
      flash[:error] = l(:notice_access_denied)
      redirect_to signin_path
    else
      token = oauth_client.auth_code.get_token(params[:code], :redirect_uri => openid_connect_callback_url)
      result = token.get(settings[:api_url])
      info = JSON.parse(result.body)
      puts(info)
      puts("email : " + info["email"])
      if info && info["email"]
        if allowed_domain_for?(info["email"])
          try_to_login info
        else
          flash[:error] = l(:notice_domain_not_allowed, :domain => parse_email(info["email"])[:domain])
          redirect_to signin_path
        end
      else
        flash[:error] = l(:notice_unable_to_obtain_openid_connect_credentials)
        redirect_to signin_path
      end
    end
  end

  def try_to_login info
    params[:back_url] = session[:back_url]
    session.delete(:back_url)
    user = User.joins(:email_addresses).where(:email_addresses => {:address => info["email"]}).first_or_create
    if user.new_record?
      # Self-registration off
      redirect_to(home_url) && return unless Setting.self_registration?
      # Create on the fly
      user.firstname, user.lastname = info["name"].split(' ') unless info['name'].nil?
      user.firstname ||= info[:given_name]
      user.lastname ||= info[:family_name]
      user.mail = info["email"]
      user.login = info["username"]
      user.random_password
      user.register

      case Setting.self_registration
        when '1'
          register_by_email_activation(user) do
            onthefly_creation_failed(user)
          end
        when '3'
          register_automatically(user) do
            onthefly_creation_failed(user)
          end
        else
          register_manually_by_administrator(user) do
            onthefly_creation_failed(user)
          end
      end
    else
      # Existing record
      if user.active?
        successful_authentication(user)
      else
        # Redmine 2.4 adds an argument to account_pending
        if Redmine::VERSION::MAJOR > 2 or
            (Redmine::VERSION::MAJOR == 2 and Redmine::VERSION::MINOR >= 4)
          account_pending(user)
        else
          account_pending
        end
      end
    end
  end

  def oauth_client
    @client ||= OAuth2::Client.new(settings[:client_id], settings[:client_secret],
                                   :token_method => :post,
                                   :authorize_url => settings[:authorize_url],
                                   :token_url => settings[:token_url]
    )
  end

  def settings
    @settings ||= Setting.plugin_redmine_omniauth_openid_connect
  end

end
