# require 'content_type_finder'
class Tevye::Render::Preview
  def initialize(a,b,c)
  end
  
  def html
    "HI"
  end
end
# module Revelator
#   module Render
#     class Preview < Base
#       Environment = 'preview'

#       def initialize(theme_id, page_id, entry_id=nil)
#         @entry_id = entry_id
#         @page_id  = page_id
#         @theme_id = theme_id
#       end

#       def context
#         ::Liquid::Context.new({}, registers, {})
#       end

#       def html
#         page.template.render(context)
#       end

#       def page
#         @page ||= PageFinder.new(@theme_id).find(@page_id)
#       end

#       def content_type
#         @type ||= ContentTypeFinder.new(@theme_id).find(page.content_type_id)
#       end

#       def content_entry
#         @entry ||= ContentEntryFinder.new(@theme_id, page.content_type_id).find(@entry_id)
#       end

#       def templatized_model
#         return {} unless page.templatized?
#         { 'content_type' => content_type.to_liquid }.merge(@entry_id.present? ?
#             { 'content_entry' => content_entry.to_liquid } :
#             { 'content_entry' => content_type.ordered.first.to_liquid })
#       end

#       def registers
#         ::Hashie::Mash.new(templatized_model.merge({
#           environment: Environment,
#           path: page.path,
#           page: page.to_liquid,
#           theme: page.theme.to_liquid,
#           content_types: Revelator::Liquid::Drops::ContentTypes.new
#         }))
#       end

#     end
#   end
# end
