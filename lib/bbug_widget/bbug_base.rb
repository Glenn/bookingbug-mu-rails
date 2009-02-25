module BbugWidget
  class Base
    attr_accessor :scheme, :style, :background_color, :affiliate_id, :affiliate_key
    
    def initialize(values)
      if !values.blank?
        @style = values[:style].blank? ? Base.get_style : values[:style]
        @scheme = values[:scheme].blank? ? Base.get_scheme : values[:scheme]
        @background_color = values[:background_color].blank? ? Base.get_bg_color : values[:background_color]
        @affiliate_id = Base.get_affiliate_id
        @affiliate_key = Base.get_affiliate_key
      elsif !BBUG_CONFIG.blank? && !BBUG_CONFIG[:bookingbug].blank?
        @style = BBUG_CONFIG[:bookingbug][:style].blank? ? "basic" : BBUG_CONFIG[:bookingbug][:style]
        @scheme = BBUG_CONFIG[:bookingbug][:scheme].blank? ? 1 : BBUG_CONFIG[:bookingbug][:scheme]
        @background_color = BBUG_CONFIG[:bookingbug][:background_color].blank? ? "FFF" : BBUG_CONFIG[:bookingbug][:background_color]
        @affiliate_id = BBUG_CONFIG[:bookingbug][:bookingbug_affid]
        @affiliate_key = BBUG_CONFIG[:bookingbug][:bookingbug_apikey]
      else
        @style = "basic"
        @scheme = 1
        @background_color = "FFFFFF"
      end
    end
    
    def self.validate_affiliate
      !BBUG_CONFIG.blank? && !BBUG_CONFIG[:bookingbug].blank? && !BBUG_CONFIG[:bookingbug][:bookingbug_affid].blank? ? true : false
    end
    
    def self.get_scheme
      return !BBUG_CONFIG.blank? && !BBUG_CONFIG[:bookingbug].blank? && !BBUG_CONFIG[:bookingbug][:scheme].blank? ? BBUG_CONFIG[:bookingbug][:scheme] : 1
    end
    
    def self.get_style
      return !BBUG_CONFIG.blank? && !BBUG_CONFIG[:bookingbug].blank? && !BBUG_CONFIG[:bookingbug][:style].blank? ? BBUG_CONFIG[:bookingbug][:style] : "basic"
    end
    
    def self.get_bg_color
      return !BBUG_CONFIG.blank? && !BBUG_CONFIG[:bookingbug].blank? && !BBUG_CONFIG[:bookingbug][:background_color].blank? ? BBUG_CONFIG[:bookingbug][:background_color] : "FFFFFF"
    end
    
    def self.get_affiliate_id
      return !BBUG_CONFIG.blank? && !BBUG_CONFIG[:bookingbug].blank? ? BBUG_CONFIG[:bookingbug][:bookingbug_affid] : nil
    end
    
    def self.get_affiliate_key
      return !BBUG_CONFIG.blank? && !BBUG_CONFIG[:bookingbug].blank? ? BBUG_CONFIG[:bookingbug][:bookingbug_apikey] : nil
    end
    
    def get_params_string(values= {})
      params = ""
      count = 0
      values.each do |value|
        count == 0 ? (params = "?#{value[0]}=#{value[1]}") : (params += "&#{value[0]}=#{value[1]}")
        count += 1
      end
      return params
    end
    
    def show_error
      return "<div style='border: 1px solid #AAAAAA; font-weight: bold; padding: 5px;'>Something went wrong. We are unable to render BookingBug widget. This is probably due to invalid or missing credentails.</div>"
    end
    
  end
  
end

