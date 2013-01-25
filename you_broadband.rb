require 'mechanize'
require 'nokogiri'

class YouBroadBand

  attr_accessor :logged_in

  def initialize
    root_url = "http://www.youbroadband.in/"
    @agent = Mechanize.new
    @root_page = @agent.get(root_url.to_s)
    @logged_in = false
  end

  def login (username,password)
    login_form = @root_page.form('frmcust')
    login_form.login = username.to_s 
    login_form.password = password.to_s
    login_form.action = "http://itapps.youbroadband.in:8100/default/homeuser/login_sql.jsp"
    login_form.method = 'post'
    page = @agent.submit(login_form)
    @logged_in = true
  end

  def my_account_usage
    unless @logged_in
      raise  'Not logged, use login method first' 
    end
    my_account_page = @agent.get('http://itapps.youbroadband.in:8100/default/susage/mybalance.jsp')
    parsed_my_account_page = Nokogiri::HTML(my_account_page.content)
    parsed_data  = parsed_my_account_page.css(".table-border form table")[1].css("tr")
    append = ""
    parsed_data[2].css('td').each do |td|
      append = append + td.inner_html + "::"
    end
       append = append + "||"

    parsed_data[3].css('td').each do |td|
      append = append + td.inner_html + "::"
    end
    return append

  end 
end
