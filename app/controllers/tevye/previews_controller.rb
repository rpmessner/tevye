# class Tevye::PreviewsController < Tevye::BaseController
#   def show
#     @page    = Locomotive::Page.find(params[:page_id])
#     renderer = Tevye::Render::Preview.new(@page.site_id,
#                                           @page.id,
#                                           params[:content_entry_id])
#     render text: renderer.html
#   end
# end
