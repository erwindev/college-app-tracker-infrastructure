Host *
 AddKeysToAgent yes
 UseKeychain yes
 IdentityFile ~/.ssh/id_rsa

Host bastion
 Hostname $bastion
 User ubuntu

Host 10.*.*.*
 ProxyCommand ssh -W %h:%p bastion