require 'facter'
require 'puppet'
require 'json'

dmp_data = Hash.new
dmp_data['hostenv'] = Puppet[:environment]
dmp_data['certname'] = Puppet[:certname]
dmp_data['classfile'] = Puppet[:classfile]
dmp_data['statedir'] = Puppet[:statedir]
#dmp_data['envname'] = "pve"
#dmp_data['nodetype'] = "sentinel"

personal_metadata = Hash.new

personal_metadata = JSON.parse(File.read('/etc/metadata.json'))
personal_metadata.each do |key, val|
  Facter.add("#{key}") { setcode { val } }
end

#case Facter.value(:virtual)
#when 'gce'
#  dmp_data['hosting'] = 'gce'
#  dmp_data['dmpprojectid'] = %x(/usr/bin/get_metadata_value project-id)
#  dmp_data['envname'] = %x(/usr/bin/get_metadata_value attributes/envname)
#  dmp_data['nodetype'] = %x(/usr/bin/get_metadata_value attributes/nodetype)
#  dmp_data['virtual_network_id'] = %x(/usr/bin/get_metadata_value network-interfaces/0/network)
#  dmp_data['externalip'] = %x(/usr/bin/get_metadata_value network-interfaces/0/access-configs/0/external-ip)
#  dmp_data['dmphostname'] = Facter.value(:fqdn)
#when 'xen', 'xenhvm', 'xenu'
#  dmp_data['hosting'] = 'aws'
#  #dmp_data['dmpprojectid'] = Facter.value(:ec2_tag_application).split(':')[4]
#  dmp_data['dmpprojectid'] = JSON.parse(Facter.value(:ec2_metadata)['iam']['info'])['InstanceProfileArn'].split(':')[4]
#  dmp_data['envname'] = Facter.value(:ec2_tag_envname)
#  dmp_data['nodetype'] = Facter.value(:ec2_tag_nodetype)
#  dmp_data['virtual_network_id'] = Facter.value(:ec2_metadata)['network']['interfaces']['macs'].values.first['vpc-id']
#  dmp_data['externalip'] = Facter.value(:ec2_metadata)['public-ipv4']
#  dmp_data['dmphostname'] = Facter.value(:ec2_metadata)['public-hostname']
#  dmp_data['nameserver'] = %x(/bin/grep ^nameserver /etc/resolv.conf | sed -E 's/nameserver| //g')
#end

dmp_data.each do |key, val|
  Facter.add("#{key}") { setcode { val } }
end
