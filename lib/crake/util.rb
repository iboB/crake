module CRake
  # methods and classes for internal use
  module Util
    # join an array with newlines by having each element in quotes
    def self.join_qn(ar)
      "\"#{ar.join("\"\n\"")}\""
    end
  end
end