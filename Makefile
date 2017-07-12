# Copyright 2017 SwingDev.
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

HASTEN_K8S_VERSION := $(shell cat ./hasten_k8s/VERSION)
HASTEN_SSH_TUNNEL_VERSION := $(shell cat ./hasten_ssh_tunnel/VERSION)

KUBECTL_VERSION := $(shell cat ./kubectl/VERSION)
OPENSSH_VERSION := $(shell cat ./openssh/VERSION)

test:
	echo "No tests"

build: build_openssh build_kubectl build_hasten_ssh_tunnel build_hasten_k8s

push: push_openssh push_kubectl push_hasten_ssh_tunnel push_hasten_k8s

build_kubectl:
	docker build \
		--pull \
		--build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) \
		--tag hastenio/kubectl:$(KUBECTL_VERSION) \
		./kubectl

push_kubectl:
	docker push hastenio/kubectl:$(KUBECTL_VERSION)

build_openssh:
	docker build \
		--pull \
		--tag hastenio/openssh:$(OPENSSH_VERSION) \
		./openssh

push_openssh:
	docker push hastenio/openssh:$(OPENSSH_VERSION)

build_hasten_k8s: build_kubectl
	docker build \
		--build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) \
		--tag hastenio/hasten_k8s:$(HASTEN_K8S_VERSION) \
		./hasten_k8s

push_hasten_k8s: push_kubectl
	docker push hastenio/hasten_k8s:$(HASTEN_K8S_VERSION)

build_hasten_ssh_tunnel: build_openssh
	docker build \
		--build-arg OPENSSH_VERSION=$(OPENSSH_VERSION) \
		--tag hastenio/hasten_ssh_tunnel:$(HASTEN_SSH_TUNNEL_VERSION) \
		./hasten_ssh_tunnel

push_hasten_ssh_tunnel: push_openssh
	docker push hastenio/hasten_ssh_tunnel:$(HASTEN_SSH_TUNNEL_VERSION)
