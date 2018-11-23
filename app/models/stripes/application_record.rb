# :nocov:
module Stripes
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
# :nocov: