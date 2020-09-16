require 'rails_helper'

RSpec.describe CheckSslCertificate, type: :service do

  context 'when domain is all right' do
    let!(:domain) { create :domain }

    before do
      CheckSslCertificate.new.call(domain)
    end

    it 'return array without' do
      expect(domain.status).to eq 'всё хорошо'
    end
  end

  context 'when domain is all bad' do
    let!(:domain) { create :domain, :naim_with_error }

    before do
      CheckSslCertificate.new.call(domain)
    end

    it 'return array without' do
      expect(domain.status).to eq 'всё плохо'
    end
  end
end
