class Chunk < ActiveRecord::Base
  has_many :chunk_versions
  
  def find_version(version = nil)
    Chunk.find_version(self.id, version)
  end

  def self.find_version(id, version = nil)
    chunk = find(id)
    version = chunk.live_version unless version 
    chunk.chunk_versions.find(:first, :conditions => ["version = ?", version])
  end
end