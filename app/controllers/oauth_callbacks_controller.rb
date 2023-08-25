class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def vkontakte
    if request.env['omniauth.auth'].info[:email].present?
      @user = User.find_for_oauth(request.env['omniauth.auth'])
    else
      redirect_to controller: :email_confirmations, action: :new
    end

    # @user = User.find_for_oauth(request.env['omniauth.auth'])
    # render json: request.env['omniauth.auth']
  end
end
