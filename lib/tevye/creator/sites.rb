class Tevye::Creator::Sites < Tevye::Creator
  resources_name :sites
  
  def scope
	  Locomotive::Site.where({})
  end
end
