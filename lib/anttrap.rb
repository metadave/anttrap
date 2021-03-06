# Copyright (c) 2011 Dave Parfitt

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'builder'


# A tiny Gem that can generate an Apache Ant build file from a Rakefile. 
# This allows a developer to use Rake as a build tool for Java based 
# projects, but integrate with any tool that supports Ant. The 
# generated build file simply executes the selected Rake task. 
#
# Requiring the AntTrap module in your rakefile automatically adds 
# the AntTrap rake task.
module AntTrap
  # these are just the defaults
  @@rake = "rake"
  @@antfile = "build.xml"
  @@antproject = "Rake Project"
  @@rakeargs = []

  # Get the full path (including executable name) to rake
  def self.rake
    @@rake
  end

  # Set the full path (including executable name) to rake
  def self.rake=(v)
    @@rake = v
  end
  
  # Get the name of the generated Ant file
  def self.antfile
    @@antfile
  end

  # Set the name of the generated Ant file
  def self.antfile=(v)
    @@antfile = v
  end

  # Get the name of the Ant project.
  def self.antproject
    @@antproject
  end

  # Set the name of the Ant project.
  def self.antproject=(v)
    @@antproject=v
  end
 
  # Get extra command line args to pass to the rake executable 
  def self.rakeargs
    @@rakeargs
  end

  # Set extra command line args to pass to the rake executable.
  # This property expects a list
  def self.rakeargs=(v)
    @@rakeargs = v
  end

  desc "Generate an Ant build file from this Rake file"
  task :AntTrap do |at|
    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.instruct! :xml, :encoding => "ASCII"  
    proj = xml.project("name" => AntTrap.antproject) do |p|
      Rake::Task.tasks().each do |task|
        p.target("name"=>task, "description"=>task.comment) do |t|
          t.exec("executable"=>AntTrap.rake) do |e|
            AntTrap.rakeargs.each do |arg|
              e.arg("value"=>arg)
            end
            e.arg("value"=>task)
          end
        end
      end
    end
    File.open(AntTrap.antfile,"w+") do |f|
      f.puts proj
    end
  end
  
end



