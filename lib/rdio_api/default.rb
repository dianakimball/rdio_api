require 'faraday'

module RdioApi
  module Default
    ENDPOINT = 'http://api.rdio.com/1/' unless defined? ENDPOINT #why do I need the 'unless defined?'?
    #do all of these headers apply? are all of them necessary?
    CONNECTION_OPTIONS = {
      :headers => {
        :accept => 'application/json',
        :user_agent => "Rdio Ruby Gem" #should add #{RdioApi::Version} once I have that
      },
      :open_timeout => 5,
      :raw => true,
      # :ssl => {:verify =>false} the Twitter API has an https endpoint, but not Rdio...so is this line irrelevant?
      :timeout => 10,
  } unless_defined? CONNECTION_OPTIONS
  MIDDLEWARE = Faraday::Builder.new do |builder|
    # Convert request params to "www-form-urlencoded"
    builder.use Faraday::Request::UrlEncoded
    # Handle 4xx server responses
    # builder.use Twitter::Response::RaiseError, Twitter::Error::ClientError
    # Parse JSON response bodies using MultiJson
    builder.use RdioApi::Response::ParseJson # added this file
    # Handle 5xx server responses
    # builder.use Twitter::Response::RaiseError, Twitter::Error::ServerError
    # Set Faraday's HTTP adapter
    builder.adapter Faraday.default_adapter
  end

  class << self

=begin
    # @return [Hash]
    def options
        Hash[Twitter::Configurable.keys.map{|key| [key, send(key)]}]
    end
=end

    # @return [String]
    def consumer_key
      ENV['RDIO_CONSUMER_KEY'] # from where in the ENV are these being grabbed? where are they set?
    end

    # @return [String]
    def consumer_secret
      ENV['RDIO_CONSUMER_SECRET']
    end

    # @return [String]
    def oauth_token
      ENV['RDIO_OAUTH_TOKEN']
    end

    # @return [String]
    def oauth_token_secret
      ENV['RDIO_OAUTH_TOKEN_SECRET']
    end

    def middleware
      MIDDLEWARE
    end

  end
end
