[web]
%{ for ip in split(",", node_ips) ~}
node${tonumber(index(split(",", node_ips), ip))+1}    ansible_host=${ip}
%{ endfor ~}

[control]
ansible ansible_host=${control_ip}
