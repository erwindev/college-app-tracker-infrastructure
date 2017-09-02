import sys
import json
from string import Template



def inventory(env):

	with open("../%s/terraform.tfstate" % env) as json_file:
		json_data = json.load(json_file)
		bastion = json_data['modules'][0]['outputs']['bastion_instance_ip']['value']
		ci_master_servers = '\n'.join(json_data['modules'][0]['outputs']['ci_master_private_instance_ips']['value'])
		ci_worker_servers = '\n'.join(json_data['modules'][0]['outputs']['ci_worker_private_instance_ips']['value'])		
		web_server_list = json_data['modules'][0]['outputs']['web_private_instance_ips']['value']
		web_servers = '\n'.join(web_server_list)
		swarm_leader = web_server_list[0]
		swarm_node = '\n'.join(web_server_list[1:])	

	inventory_data = {
						'bastion': bastion, 
						'ci_master_servers': ci_master_servers, 
						'ci_worker_servers': ci_worker_servers, 						
						'web_servers': web_servers,
						'swarm_leader': swarm_leader,
						'swarm_node': swarm_node
					}	

	filein = open( 'inventory.tpl' )
	src = Template( filein.read() )
	result = src.substitute(inventory_data)
	print(result)

def ansible_ssh_cfg(env):

	with open("../%s/terraform.tfstate" % env) as json_file:
		json_data = json.load(json_file)
		bastion = json_data['modules'][0]['outputs']['bastion_instance_ip']['value']

	ssh_cfg_data = {'bastion': bastion}	
	filein = open( 'ansible_ssh_cfg.tpl' )
	src = Template( filein.read() )
	result = src.substitute(ssh_cfg_data)
	print(result)	

def ssh_config(env):

	with open("../%s/terraform.tfstate" % env) as json_file:
		json_data = json.load(json_file)
		bastion = json_data['modules'][0]['outputs']['bastion_instance_ip']['value']

	ssh_cfg_data = {'bastion': bastion}	
	filein = open( 'ssh_config.tpl' )
	src = Template( filein.read() )
	result = src.substitute(ssh_cfg_data)
	print(result)		

def main(env, type):
	if type == 'inventory':
		inventory(env)

	if type == 'ansible_ssh_cfg':
		ansible_ssh_cfg(env)	

	if type == 'ssh_config':
		ssh_config(env)


if __name__ == "__main__":

	if (len(sys.argv) < 3):
  		print('code_generator.py <env> <type>')
  		sys.exit(2)  		

	env = sys.argv[1]
	type = sys.argv[2]

	main(env, type)