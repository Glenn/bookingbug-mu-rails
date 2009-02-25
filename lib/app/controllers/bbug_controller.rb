class BbugController < ActionController::Base
  
  def link
    BbugCompany.add_company(params) if request.post?
    render :text => "New company added" and return false
  end
  
  def cancel
    BbugCompany.remove_company(params) if request.post?
    render :text => "Cancelled link with Affiliate site" and return false
  end
  
end
