class SiteMapperController < ApplicationController
  
  def show_chunk
    @chunk_version, @rf_params = SiteMapping.find_chunk_and_mapping_params(@params[:path])
    
    if @chunk_version then
      @chunk_content = @chunk_version.content
    
      # options for sending chunk content back to user
      data_options = {:disposition => 'inline'}
      
      if @chunk_version.chunk.mime_type then
        mime_type = @chunk_version.chunk.mime_type.mime_type
      else
        mime_type = "text/html"
      end
      
      data_options[:type] = mime_type
      data_options[:filename] = @params[:path].last
      
      if mime_type.include?("image") then
        data = @chunk_content
      else # it is not image, then render our data inside the layout
        layout_name = @rf_params['layout']
        rendering_options = {}
        if layout_name then
          if layout_name.include?("chunk:") then
            id = layout_name.delete("chunk:").to_i
            rendering_options[:inline] = Chunk.find_version(id).content
            @rf_params["chunk_content"] = @chunk_content
          else
            rendering_options[:partial] = "chunk_content"
            rendering_options[:layout] = layout_name
          end
        else
          rendering_options[:partial] = "chunk_content"
          rendering_options[:layout] = 'default'
        end
        
        rendering_options[:locals] = {:rf_params => @rf_params}

        data = render_to_string rendering_options
      end
      
      send_data data, data_options
    else 
      render :partial => "notfound", :status => 404
    end
  end
end
