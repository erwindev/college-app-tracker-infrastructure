Host 10.0.2.*
  ProxyCommand    ssh -W %h:%p ubuntu@$bastion

Host *
  ControlMaster   auto
  ControlPath     ~/.ssh/mux-%r@%h:%p
  ControlPersist  15m
