require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  mount Base => '/'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    user_name = ::Digest::SHA256.hexdigest('user')
    user_password = ::Digest::SHA256.hexdigest('qwerty')
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), user_name) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), user_password)
  end
  mount Sidekiq::Web, at: "/sidekiq"
end
