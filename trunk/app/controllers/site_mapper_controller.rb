class SiteMapperController < ApplicationController
  layout 'default'
  
  # Unit tests are required for different urls:
  # '', 'aaa', 'aaa/bbb', etc.
  def show_chunk
    @chunk_version, @layout = SiteMapping.find_chunk_and_layout(@params[:path])
    redirect_to :action => 'notfound' unless @chunk_version
  end
  
  # 404 action
  def notfound
  end
end
