require 'crake/util'
require 'crake/source_group'
require 'crake/target'

module CRake
  # Class that describes a project
  # a CRake project can hold settings, files and targets
  # it has no direct CMake representation
  class Project
    def initialize(name)
      @name = name
      
      @root_group = SourceGroup.new(nil) # root unnamed souce group

      @children = [] # child projects
      @literal = '' # literal CMake string to be appended
      @languages = [] # languages for a project
    end

    def add_project(project)
      @children << project
    end

    def project(name, &code)
      new_project = Project.new(name)
      new_project.instance_eval(&code) if code
      add_subproject new_project
      new_project
    end

    def add_file(file)
      @root_group.add_file file
    end

    def file(path)
      @root_group.file path
    end

    def add_source_group(group)
      @root_group.add_source_group(group)
    end

    def source_group(name, &code)
      @root_group.source_group(name, &code)
    end

    def set_target(target)
      @target = target
    end

    def target(type, name = nil)
      name = @name if !name

      case type
        when :executable then set_target Target::Executable.new(name)
        when :library then set_target Target::Library.new(name)
        else raise 'Invalid target'
      end
    end

    def add_literal(text)
      @literal << text << "\n"
    end

    def build(root = true, files = [])
      # add a project command only if root
      if root
        @@has_project = true
        @@data << "project(\"#{@name}\" #{@languages.join(' ')})\n"
      end

      @root_group.build

      files += @root_group.get_files true
      files.uniq! # remove duplicate files

      # build children but don't add a project command for them
      @children.each do |child|
        child.build(false, files)
      end

      # if there is a target add it
      if @target
        @target.files = files
        @target.build
      end

      @@data << @literal << "\n"
    end

    attr_accessor :languages
  end
end
