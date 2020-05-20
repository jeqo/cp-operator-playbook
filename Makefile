CP_VERSION := 5.5.0
VM_DRIVER  := hyperkit
NAMESPACE  := confluent-operator

all:

download:
	wget -O confluent-operator-${CP_VERSION}.tar.gz https://platform-ops-bin.s3-us-west-1.amazonaws.com/operator/confluent-operator-${CP_VERSION}.tar.gz
	mkdir -p cp-operator/
	tar -xf confluent-operator-${CP_VERSION}.tar.gz -C cp-operator/

minishift-start:
	minishift start --vm-driver=${VM_DRIVER} --memory=20G --cpus=6

minishift-login:
	oc login -u system:admin

minishift-project: minishift-login
	oc new-project ${NAMESPACE}

minishift-policy: minishift-login
	oc project ${NAMESPACE}
	oc adm policy add-scc-to-user privileged -z default -n ${NAMESPACE}

kubectl-crds:
	kubectl apply -f cp-operator/resources/crds

kubectl-rbac:
	kubectl apply -f cp-operator/resources/rbac

local-install: kubectl-crds kubectl-rbac 
	./cp-operator/scripts/operator-util.sh -n ${NAMESPACE} -r co -f providers/local.yml

local-uninstall:
	./cp-operator/scripts/operator-util.sh --delete -n ${NAMESPACE} -r co -f providers/local.yml

c3-port-forward:
	kubectl port-forward svc/controlcenter 9021:9021 -n ${NAMESPACE}