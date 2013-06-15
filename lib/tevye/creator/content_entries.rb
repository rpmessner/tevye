class Tevye::Creator::ContentEntries < Tevye::Creator
  resources_name :content_entries
  
  def scope
    content_type.entries
  end
end
