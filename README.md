## Redmine Omniauth OpenID Connect Plugin

This plugin is designed to authenticate Redmine users using an OpenID Connect provider.

This project was adapted from [redmine_omniauth_gitlab](https://github.com/applewu/redmine_omniauth_gitlab)

### Installation:

Download the plugin and install required gems:

```console
cd /path/to/redmine/plugins
git clone https://github.com/terah-digital/redmine_omniauth_openid_connect.git
cd /path/to/redmine
bundle install
```

Restart redmine
```console
/path/to/redmine/ctlscript.sh restart
```

### Configuration

* Login as a user with administrative privileges. 
* In top menu select "Administration".
* Click "Plugins"
* In plugins list, click "Configure" in the row for "Redmine Omniauth OpenID Connect Plugin"
* Enter the information as provided in your OpenID Connect provider.
* Check the box near "OAuth Authentication"
* Click Apply. 
 
Users can now to use their OpenID Connect Account to log in to your instance of Redmine.


### Other options

By default, all user email domains are allowed to authenticate through OpenID Connect.
If you wish to limit the email domains allowed to use the plugin, list them in "Allowed domains" text box.


### Authentication Workflow

1. An unauthenticated user requests the URL to your Redmine instance.
2. User clicks the "Login with OAuth" button.
3. The plugin redirects them to the OpenID Connect Provider sign in page (if they are not already signed in to their openid_connect account).
4. OpenID Connect will then redirect the user back to Redmine and log them in.