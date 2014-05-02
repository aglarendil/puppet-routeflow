module Puppet::Parser::Functions
    newfunction(:getports,:type=>:rvalue) do |args|
      vms=args[0]
      resources={}
      vms.each do |vm_name,vm|
         Puppet::debug("#{vm_name}")
         interfaces=vm['quagga_interfaces']
         interfaces.each do |iface|
           resources[iface['pair']] = {:ensure=>"present", :bridge=>iface['dp']}
         end
      end
     return resources
    end
end
