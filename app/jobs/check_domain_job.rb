class CheckDomainJob < ApplicationJob

  def perform
    Domain.find_in_batches do |batch|
      batch.each do |domain|
        CheckSslCertificate.new.call(domain)
      end
    end
  end

end