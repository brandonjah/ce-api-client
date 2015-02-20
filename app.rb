$: << File.dirname(__FILE__) + "/config"
require 'environment'

class CeApiClient < Sinatra::Base
  def url_for(path)
    File.join('https://ce-api.herokuapp.com/', path)
  end

  get '/' do
    id = '8eea94464969021f753b749d0d6507e2'
    secret = 'QDaB5k1a4Q4MdvbnkZ64v++AD9+izqJIxHR64jkef5jXDjRfOFdatizPuC7v5jby4AHIHAk/09WuWK1NB08mJA=2'

    response = HTTParty.get( url_for('test') )
    
    client = Rack::OAuth2::Client.new(
      identifier: id,
      secret: secret,
      redirect_uri: url_for(""),
      token_endpoint: url_for("oauth2/token")
    )

    token = client.access_token!

    token = Rack::OAuth2::AccessToken::Bearer.new(
      :access_token => token.access_token
    ) 
    # response = token.get "https://ce-api.herokuapp.com/test_authenticated"
    response = HTTParty.post("https://ce-api.herokuapp.com/score_by_address",
      :query => { :address => { :street => "1234 Main st. Apt 2", :"zipcode" => "92109", :city => "San Diego", :state => "CA" }, :attributes => { :bedrooms => 7, :bathrooms => 1} },
      :headers => {"Authorization" => "Bearer #{token.access_token}"}
    )
    response.body
  end
end