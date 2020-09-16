module V1
  class SslApi < Grape::API
    version 'v1', using: :header, vendor: 'ssl'
    format :json

    desc 'Return a public timeline.'
    get '/status' do
      statuses = Domain.all
      present statuses, with: V1::DomainEntity
    end

    desc 'Create domain.'
    params do
      requires :name, type: String
    end
    post '/domain' do
      res = CreateDomainContract.new.call(params)
      res.success? ? Domain.create(res.to_h) : res.errors.to_h
    end
  end
end