class CreateDomainContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
  end

  rule(:name) do # check unique name
    arr = values[:name].split('.')
    if arr[0] == 'www'
      arr.delete(arr[0])
      @new_name = arr.join('.')
    else
      @new_name = 'www.' + values[:name]
    end

    domains = Domain.where('name IN (?)', [values[:name], @new_name])
    key.failure('must be uniq') if domains.present?
  end
end