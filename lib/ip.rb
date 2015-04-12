require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'capybara-webkit'
require 'nokogiri'

require_relative 'tr'

@router_url = 'http://192.168.0.1/'

class IP
  include Capybara::DSL

  def ls
    Capybara.run_server = false
    Capybara.default_driver = :webkit
    Capybara.app_host = @router_url

    page.driver.allow_url 'http://192.168.0.1'
    page.driver.allow_url 'http://192.168.0.1/'
    page.driver.allow_url 'http://192.168.0.1/*.*'
      
    visit 'http://192.168.0.1/'
    within '#form1' do
      fill_in 'log_pass', with: password
    end
    click_button 'Log In'

    visit 'http://192.168.0.1/lan.asp'
    doc = Nokogiri::HTML page.html
    client_table_rows = doc.css '#dhcpd_list #table1 tbody tr'
    for i in 1..client_table_rows.length - 1 do
      puts pretty client_table_rows[i]  
    end
  end

  def username
    'admin'
  end

  def password
    pw = ENV['LSIP_PASSWORD']
    raise 'Authentication failed. Set LSIP_PASSWORD and try again' unless pw
  end
  def pretty(tr)
    from_content = tr.css 'center'
    TR.new(from_content).to_s
  end
end