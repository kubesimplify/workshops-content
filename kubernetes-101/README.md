## Complete 4 hours of workshop recording is up on my YouTube channel 

[Link to the video](https://youtu.be/PN3VqbZqmD8)

<iframe width="560" height="315" src="https://www.youtube.com/embed/PN3VqbZqmD8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Simple pod imperative way

`kubectl run nginx --image=nginx --port 80 --dry-run=oclient -oyaml`

Declarative way 

## namespace 
```
kubectl create ns dev
kubectl create ns testing
kubectl create deploy saiyam --image=nginx
kubectl create deploy saiyam --image=nginx -n dev

```
switch the context

`kubectl config set-context --current --namespace=dev`

## Labels selectors

```
kubectl run nginx --image=nginx
kubectl create deploy nginx --image=nginx
kubectl label pod nginx app=demo

kubectl get pods -l run=nginx
kubectl get pods -l 'app in (demo,nginx)'
```


# What happens when a pod runs - namespace 

```
apiVersion: v1
kind: Pod
metadata:
  name: shared-namespace
spec:
  containers:
    - name: p1
      image: busybox
      command: ['/bin/sh', '-c', 'sleep 10000']
    - name: p2
      image: nginx
```

### check the network namespace (this gives list of all network namespaces)
`ls -lt /var/run/netns`

### exec into the namespace or into the pod to see the IP links

```
IP netns exec <namespace> IP link
kubectl exec -it shared-namespace -- IP addr 
```
Now you will see `eth@9` -> after `@` there will be a number and you can then search its corresponding link on the node using 
`ip link | grep -A1 ^9`
you will be able to see the same network namespace after link
These are the veth pairs or based on the CNI 

### how to check pause container 
```
kubectl run nginx --image=nginx
lsns | grep nginx
```
copy the process IP from above and run 
```
lsns -p <pid>

```

## Services 

```
kubectl run nginx --image=nginx
kubectl run nginx2 --image=nginx
kubectl label pod nginx2 run=nginx --overwrite

kubectl expose pod nginx --port 80 --dry-run=client -oyaml
kubectl expose pod nginx --port 80  
kubectl get ep

```

## init container

```
apiVersion: v1
kind: Pod
metadata:
  name: init-demo1
spec:
  containers:
  -  name: nginx
     image: nginx
     ports:
     - containerPort: 80
     volumeMounts:
     -  name: shared
        mountPath: /usr/share/nginx/html
# These containers are run during pod
  initContainers:
  -  name: install
     image: busybox
     command:
     - wget
     - "-O"
     - "/shared/index.html"
     - https://kubesimplify.com/
     volumeMounts:
     -  name: shared
        mountPath: /shared
  volumes:
  - name: shared
    emptyDir: {}
```

exec into the post and curl localhost to see if the HTML got changed

multiple init containers 


```
apiVersion: v1 
kind: Pod 
metadata:
  name: init-demo2
  labels:
    app: myapp 
spec:
  containers: 
  -  name: app-container
     image: busybox:1.28
     command: ['sh', '-c', 'echo The app is running! && sleep 3600'] 
  initContainers:
  -  name: init-myservice
     image: busybox:1.28
     command: ['sh', '-c', "until nslookup appservice.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for appservice; sleep 2; done"] 
  -  name: init-mydb
     image: busybox:1.28
     command: ['sh', '-c', "until nslookup dbservice.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for dbservice; sleep 2 ; done"]
```

```
apiVersion: v1
kind: Service
metadata:
  name: appservice
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80

---
apiVersion: v1
kind: Service
metadata:
  name: dbservice
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
```

## multi container

```
apiVersion: v1 
kind: Pod 
metadata:
  name: multi-container
spec:
  volumes:
  - name: shared-data
    emptyDir: {}

  containers: 
  -  name: nginx-container
     image: nginx
     volumeMounts:
     - name: shared-data
       mountPath: /usr/share/nginx/html
  - name: alpine-container
    image: alpine
    volumeMounts:
    - name: shared-data
      mountPath: /mem-info
    command: ["/bin/sh" , "-c"]
    args:
    - while true; do
        date >> /mem-info/index.html ;
        egrep --color 'Mem|Cache|Swap|' /proc/meminfo >> /mem-info/index.html ;
        sleep 2;
      done
```

`kubectl exec -it multi-container -c nginx-container -- curl localhost`

## container probes

```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    livenessProbe:
      httpGet:
        path: /
        port: 80
    ports:
    - containerPort: 80
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
demo with path to `demo` for failure and also change httpGet to `tcpSocket`
```
tcpSocket:
  port: 8080
```
change the port to 80 for success scenario 

## Resource request demo

`kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml`
add`- --kubelet-insecure-tls` flag to above yaml to work properly

```
apiVersion: v1
kind: Pod
metadata:
  name: limit-test
spec:
  containers:
  -  name: cpu-mem
     image: saiyam911/stress
     resources:
       limits:
         cpu: "1"
         memory: "200Mi"
       requests:
         cpu: "500m"
         memory: "100Mi"
     command: ["stress"]
     args: ["--cpu", "2"] 
     #args: ["--vm","1","--vm-bytes", "250M", "--vm-hang", "1"] 
```
In the above you are asking for 2 but you will the throttled and it will be under the limit which is 1
change CPU to 3

##deployments
```
kubectl create deploy demo --image=nginx 
kubectl set image deployment/nginx nginx=nginx:1.15.2 --record
kubectl rollout history deployment demo 
kubectl rollout undo deployment demo --to-revision 2 
```

## Statefulset

local path provisioner
```
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.22/deploy/local-path-storage.yaml
```

```
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: k8s.gcr.io/nginx-slim:0.8
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      storageClassName: local-path
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi

```

```
kubectl exec -it web-0 -- bash
echo "Hello from Saiyam" >> /usr/share/nginx/html/index.html
kubectl exec -it web-2 -- bash
echo "Hello from Saiyam" >> /usr/share/nginx/html/index.html

```




## Config Maps and secrets
```
kubectl create configmap test --from-literal=live=demo
```

```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: busybox
  name: busybox
spec:
  containers:
  - image: busybox
    name: busybox
    command: ["/bin/sh","-c","printenv"]
    env:
      - name: LOOK
        valueFrom:
          configMapKeyRef:
            name: test
            key: live
```
example 2 - mount config map as volume

```
apiVersion: v1
metadata:
  name: demo-vol
kind: ConfigMap
data:
  fileA: |-
    hello: saiyam
    learn: kubernete
  fileB: test2
```

```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: busybox
  name: busybox2
spec:
  volumes:
  - name: demo
    configMap:
      name: demo-vol
  containers:
  - image: busybox
    name: busybox
    command: ["sleep", "3600"]
    volumeMounts:
    - name: demo
      mountPath: /home/config
```
exec and cat the files `kubectl exec -it busybox2 -- sh`


SECRETS

```
kubectl create secret generic test --from-literal=live=demo
```
```

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: busybox
  name: busybox
spec:
  containers:
  - image: busybox
    name: busybox
    command: ["/bin/sh","-c","printenv"]
    env:
      - name: LOOK
        valueFrom:
          secretKeyRef:
            name: test
            key: live
```

for volumes same as config maps 
```
volumes:
  - name: demo
    secret:
      secretName: demo-sec
```

## Authentication 

```
kubectl config view
find the cluster name from the kubeconfig file
export CLUSTER_NAME=

export APISERVER=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}')
curl --cacert /etc/kubernetes/pki/ca.crt $APISERVER/version
```

```
curl --cacert /etc/kubernetes/pki/ca.crt $APISERVER/v1/deployments
```
The above didn't work and we need to authenticate, so let's use the first client cert

`curl --cacert /etc/kubernetes/pki/ca.crt --cert client --key key $APISERVER/apis/apps/v1/deployments`
above you can have the client and the key from the kubeconfig file

```sh
echo "<client-certificate-data_from kubeconfig>" | base64 -d > client
echo "<client-key-data_from kubeconfig>" | base64 -d > key
```

Now using the sA Token 
1.24 onwards you need to create the secret for the SA 
```
TOKEN=$(kubectl create token default)
curl --cacert /etc/kubernetes/pki/ca.crt $APISERVER/apis/apps/v1 --header "Authorization: Bearer $TOKEN"
```
from inside pod you can use `var/run/secrets/kubernetes.io/serviceaccount/token` path for the token to call the kubernetes service

proxy

```
kubectl proxy --port=8080 &s
curl localhost:8080/apis/apps/v1/deployments
```
