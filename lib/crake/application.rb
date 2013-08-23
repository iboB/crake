require 'trollop'
require 'crake'

include CRake

module CRake
  # An application class used in for the command line tool
  class Application
    def initialize
      prepare_args_parser
    end

    # create the parser for the command line arguments
    def prepare_args_parser
      @args_parser = Trollop::Parser.new do
        banner "CRake #{Version::STRING} command-line tool"
        banner "\nusage: crake [path] [options]"
        banner "\nOptions:"

        opt :generator, "Project generator (see the list of supported generators below). If no generator is given, internally the generator will be set to Unknown and there might be generation errors.",
          :type => String
        opt :version, "Show CRake version"
        opt :input, "Set a specific input file", :type => String, :default => 'CRakefile'
        opt :output, "Set a specific output file", :type => String, :default => 'CMakeLists.txt'
        opt :cmakeopts, "Set some specific command options as a string literal to be passed to CMake"
        opt :nocmake, "Dont call CMake. Only generate the output file"
        opt :verbose, "Verbose generation output"
        opt :help, "Show this help message"

        banner "\nGenerators:"
        banner "gen 1"
      end
    end

    # run the application with a given command line
    def run(argv)
      # parse and analyze the command line
      options = Trollop::with_standard_exception_handling @args_parser do
        opts = @args_parser.parse(argv)

        raise Trollop::CommandlineError.new "Too many arguments" if argv.length > 1
        
        opts
      end
      
      path = (argv.shift or '.')
      
      Dir.chdir(path) do
        #include CRake
        load(options.input)
      end
      
      code = gen_cmake_code
      
      puts code # tem for debugging
      
      write_cmake_lists
      
      puts 'Calling CMake...'
      call_cmake
    end

  end
end
