#cat lib/puppet/parser/functions/alternative_template.rb
#
# for example if you were using :
#    content => template('bind9/resolv.conf');
# you could now choose to write :
#    content => alternative_template('bind9', 'resolv.conf');
#
# This will try to load bind9/resolv.conf.$hostname bind9/resolv.conf.$hostfamily ... and finally bind9/resolv.conf
#
# The facts will be prefered in the order defined
# in the file alternative_source.rb.

module Puppet::Parser::Functions
  newfunction(:alternative_template, :type => :rvalue) do |args|
    modulename = args[0]
    filename   = args[1]

    if filename.end_with? ".erb"
      suffix = ".erb"
      filename.sub!(/\.erb$/, '')
    end

    Puppet::Parser::Functions.autoloader.loadall
    sources = function_alternative_source ["#{lookupvar('settings::modulepath')}/#{modulename}/templates/#{filename}"]

    sources.map! {|source| "#{source}#{suffix}"}
    available = sources.select {|source| File.exists?(source)}

    if !available.empty?
      function_template [available.first]
    else
      function_template ["#{modulename}/#{filename}#{suffix}"]
    end
  end
end
