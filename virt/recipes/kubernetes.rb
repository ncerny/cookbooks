#
# Cookbook:: virt
# Recipe:: kubernetes
#
# Copyright:: 2018, Nathan Cerny
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

bond0_ipv4 = node['network']['interfaces']['bond0']['addresses'].each { |k, v| k if v['family'].eql?('inet') }
bond1_ipv4 = node['network']['interfaces']['bond1']['addresses'].each { |k, v| k if v['family'].eql?('inet') }

systemd_service 'kube-apiserver' do
  action [:create, :enable]
  unit do
    description 'Kubernetes API Server'
    documentation 'https://github.com/kubernetes/kubernetes'
  end
  service do
    exec_start <<-EOF
/opt/bin/kube-apiserver \
  --advertise-address=#{bond1_ipv4} \
  --allow-privileged=true \
  --apiserver-count=3 \
  --audit-log-maxage=30 \
  --audit-log-maxbackup=3 \
  --audit-log-maxsize=100 \
  --audit-log-path=/var/log/audit.log \
  --authorization-mode=Node,RBAC \
  --bind-address=0.0.0.0 \
  --client-ca-file=/var/lib/kubernetes/ca.pem \
  --enable-admission-plugins=Initializers,NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \
  --enable-swagger-ui=true \
  --etcd-servers=http://172.16.20.31:2379,http://172.16.20.32:2379,http://172.16.20.33:2379 \
  --event-ttl=1h \
  --experimental-encryption-provider-config=/var/lib/kubernetes/encryption-config.yaml \
  --kubelet-certificate-authority=/var/lib/kubernetes/ca.pem \
  --kubelet-client-certificate=/var/lib/kubernetes/kubernetes.pem \
  --kubelet-client-key=/var/lib/kubernetes/kubernetes-key.pem \
  --kubelet-https=true \
  --runtime-config=api/all \
  --service-account-key-file=/var/lib/kubernetes/service-account.pem \
  --service-cluster-ip-range=10.32.0.0/24 \
  --service-node-port-range=30000-32767 \
  --tls-cert-file=/var/lib/kubernetes/kubernetes.pem \
  --tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem \
  --v=2
EOF
    restart 'on-failure'
    restart_sec 5
  end
  install_wanted_by 'multi-user.target'
  only_if { %w(virt01 virt02 virt03).include?(node['hostname']) }
end

systemd_service 'kube-controller-manager' do
  action [:create, :enable]
  unit do
    description 'Kubernetes Controller Manager'
    documentation 'https://github.com/kubernetes/kubernetes'
  end
  service do
    exec_start <<-EOF
/opt/bin/kube-controller-manager \
  --address=0.0.0.0 \
  --allocate-node-cidrs=true \
  --cluster-cidr=10.200.0.0/16 \
  --cluster-name=kubernetes \
  --cluster-signing-cert-file=/var/lib/kubernetes/ca.pem \
  --cluster-signing-key-file=/var/lib/kubernetes/ca-key.pem \
  --kubeconfig=/var/lib/kubernetes/kube-controller-manager.kubeconfig \
  --leader-elect=true \
  --root-ca-file=/var/lib/kubernetes/ca.pem \
  --service-account-private-key-file=/var/lib/kubernetes/service-account-key.pem \
  --service-cluster-ip-range=10.32.0.0/24 \
  --use-service-account-credentials=true \
  --v=2
EOF
    restart 'on-failure'
    restart_sec 5
  end
  install_wanted_by 'multi-user.target'
  only_if { %w(virt01 virt02 virt03).include?(node['hostname']) }
end

systemd_service 'kube-scheduler' do
  action [:create, :enable]
  unit do
    description 'Kubernetes Scheduler'
    documentation 'https://github.com/kubernetes/kubernetes'
  end
  service do
    exec_start <<-EOF
/opt/bin/kube-scheduler \
  --config=/var/lib/kubernetes/kube-scheduler-config.yaml \
  --v=2
EOF
    restart 'on-failure'
    restart_sec 5
  end
  install_wanted_by 'multi-user.target'
  only_if { %w(virt01 virt02 virt03).include?(node['hostname']) }
end

systemd_service 'kube-router' do
  action [:enable, :start]
  unit do
    description 'Kubernetes Router'
    after 'kube-apiserver.service'
  end
  service do
    exec_start <<-EOF
/opt/bin/kube-router \
  --kubeconfig=/var/lib/kubernetes/kube-router.kubeconfig \
  --run-firewall=true \
  --run-service-proxy=true \
  --run-router=true
EOF
    restart 'on-failure'
  end
  install_wanted_by 'multi-user.target'
end

systemd_service 'kubelet' do
  action [:enable, :start]
  unit do
    description 'Kubernetes Kubelet'
    documentation 'https://github.com/kubernetes/kubernetes'
    after 'docker.service'
    requires 'docker.service'
  end
  service do
    exec_start <<-EOF
/opt/bin/kubelet \
  --config=/var/lib/kubelet/kubelet-config.yaml \
  --container-runtime=docker \
  --image-pull-progress-deadline=2m \
  --kubeconfig=/var/lib/kubelet/kubeconfig \
  --network-plugin=cni \
  --register-node=true \
  --v=2
EOF
    restart 'on-failure'
    restart_sec 5
  end
  install_wanted_by 'multi-user.target'
end
