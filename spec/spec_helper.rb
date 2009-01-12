require 'spec'
require 'spec/rails'

def require_all_files_in_folder(folder, extension = "*.rb")
  for file in Dir[File.join(RAILS_ROOT, folder, "**/#{extension}")]
    require file
  end
end

require_all_files_in_folder "spec/spec_helpers"

