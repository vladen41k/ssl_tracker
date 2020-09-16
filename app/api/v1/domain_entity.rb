module V1
  class DomainEntity < Grape::Entity
    expose :name
    expose :status
    expose :description
  end
end