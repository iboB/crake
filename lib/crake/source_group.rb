require 'crake/util'
require 'crake/source_file'

module CRake
  # A source group containing source files
  # Each project has at least one default unnamed source group
  class SourceGroup
    def initialize(name)
      @name = name
      @files = []
      @subgroups = []
    end

    # add a by the already created object
    def add_file(file)
      @files << file
    end

    # add a single file to the group
    def file(path)
      new_file = SourceFile.new(path)
      add_file(new_file)
      new_file
    end

    def files(paths)
      paths.each do |path|
        file(path)
      end
    end

    def add_source_group(group)
      @subgroups << group
    end

    def source_group(name, &code)
      new_group = SourceGroup.new(name)
      new_group.instance_eval(&code) if code
      add_source_group(new_group)
      new_group
    end

    def uniq!
      @files.uniq!
      @subgroups.each &:uniq!
    end

    # the cmake code for the group
    def code(parent_name_in_code = nil)
      name_in_code = parent_name_in_code ? parent_name_in_code + '\\\\' + @name : @name;

      #if this group has no name then by definition it's the default unspecified group
      result = @name ? "source_group(#{name_in_code} FILES #{CRake::Util.join_qn(@files)})\n" : ''

      @subgroups.each do |subgroup|
        result << subgroup.code(name_in_code)
      end

      result
    end

    def build
      uniq!
      @@data << code
    end

    def get_files(recursive=false)
      if recursive
        result = @files.clone
        @subgroups.each do |subgroup|
          result += subgroup.get_files(true)
        end
        result
      else
        @files
      end
    end

  end
end
