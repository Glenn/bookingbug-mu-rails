BBUG_URL = "localhost:3000"
BOOKINGBUG_ROOT = Pathname.new(RAILS_ROOT).realpath.to_s

unless defined?(BBUG_CONFIG)
  BBUG_CONFIG = BbugWidget::Config.read_config("#{BOOKINGBUG_ROOT}/config/bookingbug.yml")
end

module Bookingbug
  
  attr_accessor :bbug_host
  
  def link_to_bookingbug(options = {})
    Bookingbug.set_bbug_host(request.host_with_port)
    if !BBUG_CONFIG.blank? && !BBUG_CONFIG[:bookingbug].blank? && !BBUG_CONFIG[:bookingbug][:bookingbug_affid].blank?
      user = BbugCompany.find_user(options[:id])
      if user.blank?
        render :partial => "bookingbug/signup", :locals => {:bbug_link_txt  => options.blank? ? nil : options[:signup],
                                                            :affid          => BBUG_CONFIG[:bookingbug][:bookingbug_affid],
                                                            :refid          => options[:id],
                                                            :email          => options[:email],
                                                            :name           => options[:name],
                                                            :country        => options[:country],
                                                            :address1       => options[:address1],
                                                            :address2       => options[:address2],
                                                            :address3       => options[:address3],
                                                            :address4       => options[:address4],
                                                            :postcode       => options[:postcode],
                                                            :homephone      => options[:homephone],
                                                            :mobilephone    => options[:mobilephone] }
      else
        render :partial => "bookingbug/login", :locals => {:bbug_link_txt   => options.blank? ? nil : options[:signin],
                                                           :comp_id         => user.bbug_company_id }
      end
    end
  end
  
  def bookingbug_cancel_callback(options = {})
    Bookingbug.set_bbug_host(request.host_with_port)
    if !BBUG_CONFIG.blank? && !BBUG_CONFIG[:bookingbug].blank? && !BBUG_CONFIG[:bookingbug][:bookingbug_apikey].blank? && !options[:id].blank?
      bbug_user = BbugCompany.find(:first, :conditions => ["affiliate_user_id = ?", options[:id]])
      return "Failed to communicate with BookingBug - User with this id does not exist" if bbug_user.blank?
      begin
        url = URI.parse("http://" + "#{BBUG_URL}" + "/affiliate/api/cancel") # http://www.bookingbug.com/affiliate/api/cancel?affiliate_key='.$key.'&bb_id='.$id)
        req = Net::HTTP::Post.new(url.path + "?" + url.query.to_s)
        req.set_form_data({:affiliate_key => BBUG_CONFIG[:bookingbug][:bookingbug_apikey], :bb_id => bbug_user.bbug_company_id})
        res = Net::HTTP.new(url.host, url.port).start {|http|
           http.request(req)
        }
        # warn if not successfull - but there's really nothing else we can do about it!
        if res.class != Net::HTTPSuccess && res.class != Net::HTTPOK
          return "Failed to communicate with BookingBug - Please try again later"
        else
          return "success"
        end
      rescue
        return "Failed to communicate with BookingBug - Please try again later"
      end
    else
      return "Failed to communicate with BookingBug - You must provide correct information"
    end
  end
  
  def set_bbug_host(host_address)
    Bookingbug::bbug_host = host_address
  end
  
  def is_bookingbug_user?(id)
    bbug_user = BbugCompany.find(:first, :conditions => ["affiliate_user_id = ?", id])
    bbug_user.blank? ? false : true
  end
  
  def render_bbug_widget(values = {})
    Bookingbug.set_bbug_host(request.host_with_port)
    BbugWidget::Widget.render(values)
  end

end

%w{ models controllers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end

include Bookingbug