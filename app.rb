$: << File.dirname(__FILE__) + "/config"
require 'environment'

class CeApiClient < Sinatra::Base
  def url_for(path)
    File.join('https://ce-api.herokuapp.com/', path)
    # File.join('http://localhost:9292/', path)
  end

  def apt_number
    Random.rand
  end

  get '/' do
    id = ENV['CE_API_ID']
    secret = ENV['CE_API_SECRET']

    # response = HTTParty.get( url_for('test') )
    
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
      :query => { :street => "1234 Main st. Apt #{apt_number}", :"zipcode" => "92109", :city => "San Diego", :state => "CA", 
                  :bedrooms => 7, :bathrooms => 1, :usecode => "singlefamily", :finished_sqft => 2300, :yearbuilt => 1984, :heatingfuel => "elec" },
      :headers => {"Authorization" => "Bearer #{token.access_token}"}
    )
    response.body
  end

  get '/score' do
    # 'a6d97805fb30396f4970eeddbd160e3a'
    response = HTTParty.get("https://ce-api.herokuapp.com/score?ceapikey=8ad7e79505edb2f2abeb37642622b153&street=1234 Main st. Apt #{apt_number}&zipcode=92109&city=Denver&state=CO&bedrooms=5&bathrooms=4&usecode=singlefamily&finished_sqft=2300&yearbuilt=1983&heatingfuel=elec",
      :query => { :ceapikey => '8ad7e79505edb2f2abeb37642622b153', :street => "1234 Main st. Apt #{apt_number}", :"zipcode" => "92109", :city => "San Diego", :state => "CA", 
                  :bedrooms => 7, :bathrooms => 1, :usecode => "singlefamily", :finished_sqft => 2300, :yearbuilt => 1984, :heatingfuel => "elec" })
    response.body
  end
end