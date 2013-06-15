class Tevye::Finder::Sites < Tevye::Finder
  resources_name :sites
  def scope
    Locomotive::Site.where({}) 
  end
end