class Tevye::Finder::ContentEntries < Tevye::Finder
  resources_name :content_entries
  
  def scope
    content_type.entries
  end
end
