module Puppet::Parser::Functions
    newfunction(:random_mac,:type=>:rvalue) do |args|
       virtual_prefix='02:'
       suffix=(1..5).map{"%0.2X"%rand(256)}.join(":").downcase
       rv=virtual_prefix+suffix
    end
end
