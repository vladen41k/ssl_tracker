class Base < Grape::API
  mount V1::SslApi
end
