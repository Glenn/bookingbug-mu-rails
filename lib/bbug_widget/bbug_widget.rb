module BbugWidget
  
  class Widget < BbugWidget::Base
    
    attr_accessor :affiliate_user_id
    
    def initialize(values = {})
      super(values)
      if !values.blank?
        bbug_user = BbugCompany.find(:first, :conditions => ["affiliate_user_id = ?", values[:id]])
        @affiliate_user_id = bbug_user.bbug_company_id if !bbug_user.blank?
      end
    end
    
    def self.render(values = {})
      if BbugWidget::Base.validate_affiliate
        widget = BbugWidget::Widget.new(values)
        script = "<script type=\"text/javascript\" src=\"http://#{BBUG_URL}/widget/affiliate"
        script += widget.get_params_string(:bb_id => widget.affiliate_user_id, :bgcol => widget.background_color, :scheme => widget.scheme, :style => widget.style, :dynamic => 1, :resize => 1, :affiliate_id => widget.affiliate_id)
        script += "\">"
        script += "</script>"
        return script
      else
        return widget.show_error
      end
    end
    
    def self.is_bookingbug_user?(id)
      bbug_user = BbugCompany.find(:first, :conditions => ["affiliate_user_id = ?", id])
      bbug_user.blank? ? false : true
    end
    
  end
  
end
