# This function load alternate template with a preference order driven by facts.
#
# for example if you were using :
#    source  =>  ["puppet:///modules/bind9/resolv.conf.$::hostname","puppet:///modules/bind9/resolv.conf.$::hostfamily","puppet:///modules/bind9/resolv.conf.$::hostdynasty","puppet:///modules/bind9/resolv.conf.$::hosting","puppet:///modules/bind9/resolv.conf.$::lsbdistcodename","puppet:///modules/bind9/resolv.conf.$::hostenv","puppet:///modules/bind9/resolv.conf"];
# you could now choose to write :
#    source => alternative_source('puppet:///modules/bind9/resolv.conf');
#
# This will try to load bind9/resolv.conf.$hostname bind9/resolv.conf.$hostfamily ... and finally bind9/resolv.conf
#
# Notice you must set in /etc/puppetlabs/code/environment/$env/environment.conf modulepath = modules
#
# The facts will be prefered in this order
# hostname virtual lsbdistcodename operatingsystem

module Puppet::Parser::Functions
  newfunction(:alternative_source, :type => :rvalue) do |args|
    #args
    #'puppet:///modules/bind9/resolv.conf'

    source        = args[0]
    modulespath   = lookupvar "settings::modulepath"
    if source =~ /^puppet:/
      modulename = source.split("/")[4]
      filepath   = source.split("/")[5..-1].join("/")
      fullpath   = "#{modulespath}/#{modulename}/files/#{filepath}"
    else
      fullpath = source
    end

    #--------------------------------------------------------------------------
    # Get all the alternatives
    #--------------------------------------------------------------------------
    alternatives = %w(hostname nodetype envname certname virtual lsbdistcodename operatingsystem).map do |f|
      lookupvar f
    end.compact

    #--------------------------------------------------------------------------
    # Check files existence
    #--------------------------------------------------------------------------
    rtn = alternatives.map do |a|
      if source =~ /^puppet:/
        "#{source}.#{a}" if File.exists?("#{fullpath}.#{a}")
      else
        "#{source}.#{a}"
      end
    end.compact


    rtn << source
    rtn
  end
end
