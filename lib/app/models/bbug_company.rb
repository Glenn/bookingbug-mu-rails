class BbugCompany < ActiveRecord::Base
  
  def self.find_user(id)
    find(:first, :conditions => ["affiliate_user_id = ?", id])
  end
  
  def self.add_company(params)
    if !params.blank? && !params[:bb_id].blank? && !params[:ref_id].blank?
      company = BbugCompany.find(:first, :conditions => ["affiliate_user_id = ?", params[:ref_id]])
      BbugCompany.create(:bbug_company_id => params[:bb_id], :affiliate_user_id => params[:ref_id], :bbug_company_name => params[:bb_name]) if company.blank? && !BBUG_CONFIG.blank? && !BBUG_CONFIG[:bookingbug].blank? && BBUG_CONFIG[:bookingbug][:bookingbug_apikey].to_s == params[:affiliate_key]
    end
  end
  
  def self.remove_company(params)
    if !params.blank? && !params[:bb_id].blank? && !params[:ref_id].blank?
      company = BbugCompany.find(:first, :conditions => ["affiliate_user_id = ?", params[:ref_id]])
      company.destroy if !company.blank? && !BBUG_CONFIG.blank? && !BBUG_CONFIG[:bookingbug].blank? && BBUG_CONFIG[:bookingbug][:bookingbug_apikey].to_s == params[:affiliate_key]
    end
  end
  
end
