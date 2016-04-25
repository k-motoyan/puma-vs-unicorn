class ProxyController < ApplicationController
  def index
    render html: Net::HTTP.get(URI('https://example.com/')).html_safe
  end
end
