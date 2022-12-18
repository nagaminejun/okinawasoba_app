class LineLoginApiController < ApplicationController
    require 'json'
    require 'typhoeus'
    require 'securerandom'

    def login
        # CSRF対策用の固有な英数字の文字列
        # ログインセッションごとにWebアプリでランダムに生成する
        session[:state] = SecureRandom.urlsafe_base64

        # ユーザーに認証と認可を要求する
        # https://developers.line.biz/ja/docs/line-login/integrate-line-login/#making-an-authorization-request

        base_authorization_url = 'https://access.line.me/oauth2/v2.1/authorize'
        response_type = 'code'
        client_id = '1657559843' #LINEログインチャネルのチャネルID、本番環境では環境変数などに保管する
        redirect_uri = CGI.escape('https://shielded-chamber-20925.herokuapp.com/line_login_api/callback') #CGI.escape(line_login_api_callback_url)
        state = session[:state]
        scope = 'profile%20openid' #ユーザーに付与を依頼する権限

        authorization_url = "#{base_authorization_url}?response_type=#{response_type}&client_id=#{client_id}&redirect_uri=#{redirect_uri}&state=#{state}&scope=#{scope}"
        #debugger
        redirect_to authorization_url, allow_other_host: true
    end

    def callback
        # CSRF対策のトークンが一致する場合のみ、ログイン処理を続ける
        if params[:state] == session[:state]

        line_user_id = get_line_user_id(params[:code])
        #debugger
        user = User.find_by(line_user_id: line_user_id)#User.find_or_initialize_by(line_user_id: line_user_id)
        #debugger
            if  user.present?
                #debugger
              if  line_user_id == user.line_user_id
                log_in (user)
                flash[:success] = "Lineでログインしました"
                redirect_to root_path and return
              else
                flash[:success] = 'Lineログインに失敗しました'
                redirect_to root_path
              end
            else
                #debugger
                #session[:line_user_id] = line_user_id
                flash[:success] = "ユーザー情報を新規作成してください"
                redirect_to line_login_api_new_path(line_user_id: line_user_id)
              end
            #else
                #flash[:success] = 'Lineログインに失敗しました'
                #redirect_to root_path
            #end

        else
        redirect_to root_path, notice: 'Lineログインに失敗しました'
        end

    end

    def new
        @user = User.new
        #debugger
        @line_user_id = params[:line_user_id]
    end

    #def create
        ###
        #user = User.new(user_params)
        #debugger
        #if user.save
        #user.update_attributes(line_user_id: line_user_id)
        #log_in @user # 保存成功後、ログインします。
        #debugger
        #if user.line_user_id.present?
            #flash[:success] = 'Lineログインで新規作成しました。'
            #redirect_to user 
            #session.delete(:line_user_id)
        #else
            #flash[:success] = '新規作成に成功しました。'
            #redirect_to user
        #end
        #else
        #render :new
        #end
    #end

    private

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :line_user_id)
    end

    def get_line_user_id(code)

        # ユーザーのIDトークンからプロフィール情報（ユーザーID）を取得する
        # https://developers.line.biz/ja/docs/line-login/verify-id-token/

        line_user_id_token = get_line_user_id_token(code)

        if line_user_id_token.present?

        url = 'https://api.line.me/oauth2/v2.1/verify'
        options = {
            body: {
            id_token: line_user_id_token,
            client_id: '1657559843' #LINEログインチャネルのチャネルID、本番環境では環境変数などに保管する
            }
        }

        response = Typhoeus::Request.post(url, options)

        if response.code == 200
            JSON.parse(response.body)['sub']
        else
            nil
        end
        
        else
        nil
        end

    end

    def get_line_user_id_token(code)

        # ユーザーのアクセストークン（IDトークン）を取得する
        # https://developers.line.biz/ja/reference/line-login/#issue-access-token

        url = 'https://api.line.me/oauth2/v2.1/token'
        redirect_uri = 'https://shielded-chamber-20925.herokuapp.com/line_login_api/callback' #line_login_api_callback_url

        options = {
        headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
        },
        body: {
            grant_type: 'authorization_code',
            code: code,
            redirect_uri: redirect_uri,
            client_id: '1657559843', #LINEログインチャネルのチャネルID、本番環境では環境変数などに保管する
            client_secret: '8d72eda335ec78f4082004df1f607321' #LINEログインチャネルのチャネルシークレット、本番環境では環境変数などに保管
        }
        }
        response = Typhoeus::Request.post(url, options)

        if response.code == 200
        JSON.parse(response.body)['id_token'] # ユーザー情報を含むJSONウェブトークン（JWT）
        else
        nil
        end
    end
end

