module Stripes
  module LoginHelper
    def login_header
      {
        'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(
          Configuration.http_basic_auth_user,
          Configuration.http_basic_auth_password
        )
      }
    end
  end
end
