require 'rails_helper'


RSpec.describe CreateDomainContract do

  context 'when valid params' do
    let!(:domain) { attributes_for :domain }

    subject { CreateDomainContract.new.call(domain) }

    it 'return success' do
      expect(subject.success?).to be_truthy
    end
  end

  context 'when invalid params' do
    let!(:domain) { create :domain }
    let!(:domain_params) { attributes_for :domain }

    subject { CreateDomainContract.new.call(domain_params) }

    it 'return failure' do
      expect(subject.failure?).to be_truthy
    end
  end
end
