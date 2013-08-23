require 'crake/util'
require 'crake/project'

# CRake's module. You may include it in classes or in main
module CRake
  # Version info
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 0

    STRING = [MAJOR, MINOR, PATCH].join('.')
  end
  
  ######################################
  # Module constants
  
  # Default filename for the CMake output
  DEFAULT_OUTPUT_FILE = 'CMakeLists.txt'
  
  ######################################
  # Module class variables
  
  # The data to be written to the generated CMakeLists.txt (or other output)
  @@data = "cmake_minimum_required(VERSION 2.8)\n"
  
  # Shows whether to show a detailed log when generating
  @@verbose = false
  
  # projects at root level
  @@root_projects = []

  ######################################
  # Module methods
  
  # Generates the CMake code
  # Returns the generated code
  def gen_cmake_code
    @@root_projects.each(&:build)
    @@data
  end

  # Writes the cmake code to a CMakeLists.txt file
  def write_cmake_lists(output_file = DEFAULT_OUTPUT_FILE)
    File.open(output_file, 'w') do |f|
      f.write(@@data)
    end
  end

  # Runs cmake with the appropriate arguments plus optional user arguments
  def call_cmake(user_args='')
    system("cmake . #{user_args}")
  end
  
  # Adds a project to the root projects
  def add_project(project)
    @@root_projects << project
  end

  # Creates a new root project
  def project(name, &code)
    new_project = Project.new(name)
    new_project.instance_eval(&code) if code
    add_project new_project
    new_project
  end
end
