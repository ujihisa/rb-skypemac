require 'rubygems'
require 'appscript'
include Appscript

module SkypeMac  

  # Represents Skype internal grouping of contacts; https://developer.skype.com/Docs/ApiDoc/GROUP_object
  class Group
    attr_reader :gtype, :gid
    
    # Gets the type of a group by id
    def Group.get_type(id)
      r = Skype.send_ :command => "get group #{id} type"
      r.sub(/.*TYPE\b/, "").strip
    end

    # Returns an array of your Skype instance's supported group types
    def Group.types
      groups = Group.groups
      groups.map { |g| g.gtype }
    end  
  
    # Returns array of skype names of users in this group
    def member_user_names
      r = Skype.send_ :command => "get group #{@gid} users"
      r.sub(".*USERS\b", "").split(", ")
    end

    # Returns array of Users in this Group
    def users
      # TODO
    end

    # Returns hash of symols (group types) => Group objects
    def Group.groups
      r = Skype.send_ :command => "search groups hardwired", :script_name => ""
      r.gsub!(/^\D+/, "")
      group_ids = r.split ", "
      groups = []
      group_ids.each do |id|
        groups <<  Group.new(id, Group.get_type(id))
      end
      groups
    end
    
    private 
      def initialize(id, type)
        @gid = id
        @gtype = type
      end
  end  
end