module CRake
  # A class that represents a source file in the project
  class SourceFile

    # construcst a SourceFile by its path
    def initialize(path)
      @path = File.expand_path(path)
    end

    # returns teh file path
    def to_s
      @path
    end

    def <=>(other)
      to_s <=> other.to_s
    end

  end
end
