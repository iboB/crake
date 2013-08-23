module CRake
  # Target classes
  module Target
    # Base target class encompassing the needed functionality
    class TargetBase
      def initialize(name)
        @files = []
        @name = name
      end

      def code
        "#{cmake_command}(\"#{@name}\" #{options} #{Util.join_qn(@files)})"
      end

      def build
        @@data << code
      end

      attr_accessor :files
    end

    class Executable < TargetBase
      def cmake_command
        'add_executable'
      end

      def options
        ''
      end
    end

    class Library < TargetBase
      def cmake_command
        'add_library'
      end

      def options
        ''
      end
    end

  end
end