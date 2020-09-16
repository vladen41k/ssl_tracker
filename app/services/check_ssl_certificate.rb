require 'socket'
require 'openssl'

class CheckSslCertificate
  SECOND_IN_DAY = 86_400
  ALL_RIGHT = 'всё хорошо'.freeze
  ALL_BAD = 'всё плохо'.freeze
  BEFORE_NOT = 'Срок действия SSL сертификата еще не начался'.freeze
  AFTER_NOT = 'Срок действия SSL сертификата истёк'.freeze
  LESS_THEN_2_WEEKS = 'Сертификат истекает менее чем через 2 недели'.freeze
  LESS_THEN_1_WEEK = 'Сертификат истекает менее чем через 1 неделю'.freeze

  def initialize
    @today = Time.now.utc
  end

  def call(domain)
    check_domain(domain)
  end

  private

  def check_domain(domain)
    Timeout.timeout(5) do # raise exception if expires of 5 second
      @tcp_client = TCPSocket.new(domain.name, 443)
    end
    ssl_socket = OpenSSL::SSL::SSLSocket.new(@tcp_client)
    ssl_socket.connect
    certificate = OpenSSL::X509::Certificate.new(ssl_socket.peer_cert)
    ssl_socket.sysclose
    @tcp_client.close
    # count days
    days_to_start = (certificate.not_before - @today) / SECOND_IN_DAY
    days_to_end = (certificate.not_after - @today) / SECOND_IN_DAY

    domain.update(status: ALL_BAD, description: AFTER_NOT) && return if days_to_end <= 0
    domain.update(status: ALL_BAD, description: BEFORE_NOT) && return if days_to_start >= 0

    if days_to_start <= 0 && days_to_end < 7
      domain.update(status: ALL_RIGHT, description: LESS_THEN_1_WEEK)
      return
    elsif days_to_start <= 0 && days_to_end < 14
      domain.update(status: ALL_RIGHT, description: LESS_THEN_2_WEEKS)
      return
    end

    domain.update(status: ALL_RIGHT, description: ALL_RIGHT)
  rescue OpenSSL::X509::CertificateError, OpenSSL::SSL::SSLError => e # SSL Error
    domain.update(status: ALL_BAD, description: e.message)
  rescue Timeout::Error, SocketError => e # Connection setup error not related to SSL
    domain.update(status: ALL_BAD, description: e.message)
  end
end