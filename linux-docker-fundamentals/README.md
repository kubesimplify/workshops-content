# Linux and Docker 

## PART ONE (one hour)

### Linux OS and file system

- The Operating system is the intermediary between the applications and the hardware running on your local machine
- An operating system can have a GUI or NOT (servers usually don't have GUI)
- Each OS takes up RAM, CPU & Storage
- RAM is used for running processes, if you run out, there's SWAP which turns disk storage into RAM
- CPU is running one application at a time (dual core or quad core)
- Storage is the files stored in directories
- Operating system has a kernel which manages the CPU, RAM, Storage
- Variation of the kernel is the distro (ubutnu, debian, redhat, fedora, etc.)
- POSIX
- GNU/Linux
- NOTE: you don't interact with these regularly, the package manager or executable will automatically store files in various locations for you
- There are hidden files that you don't see (start with a .)

```bash
/
/home # home directories and files from users
/bin # user command binaries (cat, echo, etc.)
/sbin # system binaries (need sudo)
/usr # user 
/usr/bin # primary executables that system needs in order to run
/usr/local # programs installed just for that user
/lib # when executables in /bin need additional library files in order to run
/var # variable data (temporary)
/var/log # logs are stored here usually for 30 days
/var/log/syslog # system logs
/var/cache # cached data from programs
/opt # programs that install everything in one direcotry (not separated in /bin and /lib)
/etc # system wide configurations
/etc/fstab # controls how different filesystems are treated each time they are introduced to a system
/etc/hosts # used to translate hostnames to IP-addresses. 
/etc/hostname # name of the machine
/etc/sudoers # who can act as the super user (sudo)
/tmp # temporary location for running processes
/boot # do not touch - for booting the system
/dev # devices configurations like mouse and keyboard
/media # devices like CD or usb drive auto mounts here
/mnt # temporary mount points for additional filesystems

```

#### CHALLENGE 1
- Using commands inside the terminal, Find out what operating system you are running
- Find where the system log (syslog) is in Linux. View the file once found.
- create new user named "chris" with bash as default shell
- create new group named "devops" and add "chris" to it

```bash
cd /
pwd
ls

# find the release info
lsb_release -a
cat /etc/os-release
uname -a
lscpu
lsmem

# find syslog
find / -name 'syslog'
find / -iname 'syslog'

# change directory to where syslog is
cd /var/log/

# view the syslog
cat /var/log/syslog
cat /var/log/syslog | less

# view default options for new users
# bash is command language interpreter
man useradd
useradd -D

# change from Bourne shell to Bourne Again SHell
useradd -D -s /bin/bash

# what shell am I running
echo $0
echo $SHELL

# all available shells
cat /etc/shells

# adduser chris # will prompt for password and other info
useradd -m chris

# create user and add a home directory
# useradd -m chad
# useradd -m newuser

# create password
passwd chris

# Add User to Sudo Group
usermod -aG sudo chris

# switch to user
su - chris

# add group
groupadd docker

# get group info
getent group docker

# add your user to the docker group
sudo usermod -aG docker $USER

# what groups user is in
groups chris
cat /etc/group

```




---




### COMMANDS & PACKAGE MANAGERS

```bash
# man pages for everything
man curl
man ping
man grep
man ls

# present working directory
pwd

# use bash shell
bash

# to user home dir
cd
cd ..
cd /usr/local/bin
cd ../..

# clear the terminal
clear

# ls
ls
ls -al
ls -R /home

# alias
alias
alias k=kubectl
alias d=docker

# find what user you are logged in as
whoami
echo $USER

hostname

# go to previous command up and down arrows
# use reverse search with cmd + R
# also see all history
history
history 10

groups 

# add group
sudo groupadd docker
sudo addgroup devops
getent group devops

# delete user
userdel chad

# delete user from group
gpasswd -d chad devops

# get numeric ID’s (UID or group ID) of the current user
id
id root

# You can find the UID in the /etc/passwd file
cat /etc/passwd

# from left to right
# Name, Password (indicated with the letter (x)), UID (User ID), GID (Group ID), Gecos – Contain general information about the user and can be empty, Home directory, Shell – The path to the default shell for the user.

# A UID (user identifier) is a number assigned by Linux to each user on the system. This number is used to identify the user to the system and to determine which system resources the user can access.
# UID 0 (zero) is reserved for the root.
# Groups in Linux are defined by GIDs (group IDs).
# GID 0 (zero) is reserved for the root group.


# change user
su - chad
su -



# bash history contains all command history

vim /etc/sudoers
sudo !!

# ENVIRONMENT VARIABLES
APP_VERSION=v2

# view all environment variables
env
printenv





```

#### CHALLENGE 2
- change the prompt for your user to "MyNewPrompt $ "
- 

```bash
# change prompt
vim .bashrc
PS1="MyNewPrompt $ "
source .bashrc

# create directory
cd ~
cd $HOME
cd
mkdir dir1
mkdir -p dir1

# move or rename
# mv dir1 mynewdirectory

# copy
cp -r dir1 dir2

# delete directory
rm -r dir2

# create file
# touch file1.txt
# touch file1.txt file3.txt
# touch dir1/{file4.txt,file3.txt}
touch dir1/file1.txt
cp dir1/file1.txt dir1/file2.txt
mv dir1/file2.txt dir1/file3.txt

# cat file
# cat file1.txt

# copy
# cp file1.txt file2.txt

# delete file
# rm file1.txt

# On Ubuntu and all other Debian based distributions, the apt software repositories are defined in the /etc/apt/sources.list file or in separate files under the /etc/apt/sources.list.d/ directory.
# The names of the repository files inside the /etc/apt/sources.list.d/ directory must end with .list.
cat /etc/apt/sources.list
ls /etc/apt/ # see sources.list.d

# update packages
# package manager helps with installing software and all dependencies
apt update
sudo !!

# apt search python
# apt install -y python3
# apt remove -y python3

# see the tree structure
# apt install tree && tree -L 1

# docker pre-requisites 
sudo apt install -y ca-certificates \
curl \
gnupg \
lsb-release

# GPG, or GNU Privacy Guard, is a public key cryptography implementation. This allows for the secure transmission of information between parties and can be used to verify that the origin of a message is genuine
# apt-key is a program that is used to manage a keyring of gpg keys for secure apt.
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# When installing packages using apt the packages are downloaded from one or more apt software repositories. 
# An APT repository is a network server or a local directory containing deb packages and metadata files that are readable by the APT tools.
# While there are thousands of application available in the default Ubuntu repositories, sometimes you may need to install software from a 3rd party repository.

# add docker 3rd party repository
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# pull down packages locally
apt search docker-ce
sudo apt update
apt search docker-ce

# install  Docker Engine, containerd, and Docker Compose
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# show docker-ce package metadata from repository
# madison is the name of the Debian archive management tool used for all debian and debian-like distros
# apt-cache madison docker-ce

# install a specific version
# sudo apt install -y docker-ce=5:20.10.17~3-0~ubuntu-focal docker-ce-cli=5:20.10.17~3-0~ubuntu-focal containerd.io docker-compose-plugin

# verify its all working
docker run hello-world

```




---



### VIM, PERMISSIONS & PIPES
- command mode
- insert mode

```bash
:q  # quit
:w  # write
:wq # write and quit
:q! # quit without saving
:wq! # write and quit by force
command + ^ # beginning of line
command + $ # end of line
gg   # top of file
G    # bottom of file (last line)
i	 # Insert at cursor (goes into insert mode)
A	 # Write at the end of line (goes into insert mode)
ESC	 # get out of insert mode
u	 # Undo last change
U	 # Undo all changes to the entire line
o	 # Open a new line (goes into insert mode)
dd	 # Delete line
D	 # Delete contents of line after the cursor
C	 # Delete contents of a line after the cursor and insert new text. Press ESC key to end insertion.
dw	 # Delete word
4dw	 # Delete 4 words
cw	# Change word
~	# Change case of individual character
:set nu # view line numbers
:set paste # paste without auto-indent
:set nopaste # paste with auto-indent

tail -5 $HOME/.bashrc
tail -5 /etc/passwd
head -5 $HOME/.bashrc
head -5 /etc/passwd


```



---



#### CHALLENGE 3

```bash
# pipe to less
# cat /var/log/syslog | less
# cat /var/log/syslog | grep file
cat /var/log/syslog | grep ubuntu | less

# pipe to a file
# history | grep ls > commands.txt
# history | grep history >> commands.txt

# create script
vim script.sh
# type bash

# change ownership of file
# chown chad:root file1.txt

# change just the user
# chown chad file1.txt

# change just the group
# chgrp root file1.txt

# take away write permissions for the group
# chmod g-w file1.txt

# give executable permission to the group
# chmod g+x file1.txt

# give owner permission to execute
ls -al # verify chris is owner
chmod u+x script.sh
ls -al # verify change

# give other permissions to execute
# chmod o+x script.sh

# give executable for all
# chmod +x script.sh

vim script.sh
# copy and paste from this 

./script.sh


```





---






### LINUX SERVICES & GIT

```bash
# running processes by user
ps -u chad | grep firefox
ps -u chris | grep bash

# find process for firefox
pgrep firefox
pgrep bash

# kill the firefox process (after running previous command)
kill 2376 # default SIGTERM

# see all kill signals
kill -l

# stop a process (SIGSTOP)
kill -19 2376

# interrupt a process (SIGINT)
kill -2 2376

# kill forcefully (SIGKILL)
kill -9 2376

# kill all the proccesses by name (SIGKILL)
pkill -9 firefox

# see running processes by cpu usage
top

# see running processes by cpu
htop

# stop a foreground process
ping -c 1000 google.com # hit enter, then while running press ctrl + z

# view the foreground process you stopped
jobs

# change foreground process into backgrond process
bg 1 # where 1 is the job number (from jobs command)

# change background process into a foreground process
fg 1 # where 1 is the job number (from jobs command)

# start a background process
ping -c 300 hackthebox.eu &

# running processes form all users
ps -aux

# process tree with systemd at the top
pstree

# systemd process is process #1
ps -aux | grep systemd

# stop ssh service
sudo systemctl stop sshd

# ssh status 
sudo systemctl status sshd

# start ssh service
sudo systemctl start sshd

# restart sshd
sudo systemctl restart sshd

# reload 
sudo systemctl reload sshd

# reload or restart (let system chose)
sudo systemctl reload-or-restart sshd

# stop ntp when system boots
sudo systemctl disable ntp

# start when system boots up
sudo systemctl enable ntp

# if ntp daemon is active
sudo systemctl is-active ntp

# check if enabled
sudo systemctl is-enabled ntp

# list active services
sudo systemctl list-units

# list only service type daemons
sudo systemctl list-units -t service

# list active and inactive daemons
sudo systemctl list-units --all

# list daemons NOT loaded into memory
sudo systemctl list-unit-files | grep nginx

# get status of nginx
sudo systemctl status nginx

# enable nginx
sudo systemctl enable nginx

# check if nginx is enabled
sudo systemctl is-enabled nginx

# start nginx
sudo systemctl start nginx

# check status of nginx.service (full name)
sudo systemctl status nginx.service

# check logs for nginx
sudo journalctl -xe

# check for journalctl unit (daemon)
sudo systemctl list-units | grep journal

# restart journald daemon
sudo systemctl restart systemd-journald


#########################################################
############### GIT #####################################
#########################################################

# Configuring user information used across all local repositories
git config --global user.name “[firstname lastname]”

# set an email address that will be associated with each history marker
git config --global user.email “[valid-email]”

# initialize an existing directory as a Git repository
git init

# retrieve an entire repository from a hosted location via URL
git clone [url]

# show modified files in working directory, staged for your next commit
git status

# add a file as it looks now to your next commit (stage)
git add [file]

# unstage a file while retaining the changes in working directory
git reset [file]

# diff of what is changed but not staged
git diff

# diff of what is staged but not yet commited
git diff --staged

# commit your staged content as a new commit snapshot
git commit -m “[descriptive message]”

# list your branches. a * will appear next to the currently active branch
git branch

# create a new branch at the current commit
git branch [branch-name]

# switch to another branch and check it out into your working directory
git checkout

# create branch and switch to it
git checkout -b newbranch

# merge the specified branch’s history into the current one
git merge newbranch

# show all commits in the current branch’s history
git log

# show the commit history for the currently active branch
git log

# show the commits on branchA that are not on branchB
git log branchB..branchA

# show the commits that changed file, even across renames
git log --follow [file]

# show the diff of what is in branchA that is not in branchB
git diff branchB...branchA

# show any object in Git in human-readable format
git show [SHA]

# delete the file from project and stage the removal for commit
git rm [file]

# change an existing file path and stage the move
git mv [existing-path] [new-path]

# add a git URL as an alias
git remote add origin [url]

# fetch down all the branches from that Git remote
git fetch origin

# merge a remote branch into your current branch to bring it up to date
git merge origin/main

# Transmit local branch commits to the remote repository branch
git push origin main

# fetch and merge any commits from the tracking remote branch
git pull

# apply any commits of current branch ahead of specified one
git rebase [branch]

# clear staging area, rewrite working tree from specified commit
git reset --hard [commit]

# Save modified and staged changes
git stash

# list stack-order of stashed file changes
git stash list

# write working from top of stash stack
git stash pop

# discard the changes from top of stash stack
git stash drop

```


#### CHALLENGE 4

```bash
# list services running for all users
ps -aux
ps -aux | grep chris

# list only service type daemons
sudo systemctl list-units -t service

# install nginx
sudo apt install nginx

# list daemons NOT loaded into memory
sudo systemctl list-unit-files | grep nginx

# get status of nginx
sudo systemctl status nginx

# enable nginx
# sudo systemctl enable nginx

# check if nginx is enabled
# sudo systemctl is-enabled nginx

# stop nginx
sudo systemctl stop nginx

# start nginx
sudo systemctl start nginx

sudo systemctl restart nginx

# journalctl is a command-line tool for viewing logs collected by systemd. 
# The systemd-journald service is responsible for log collection, 
# retrieves messages from the kernel, systemd services, and other sources.
sudo journalctl -xe

mkdir -p newrepo

cd newrepo 

git init

touch file1.txt

git add file1.txt

git commit -m "initial commit"

git status

```


---





## PART TWO (two hours)


---



### VMS & CONTAINERS

- you can install a hypervisor on your desktop/laptop (type 2 hypervisor)
- you can remove the OS layer and use ESXi or Hyper-V (type 1 hypervisor)

#### CHALLENGE 5

- Create a new cgroup, using cgroups limit the memory allowed for a container
- create a new namespace in UTS and PID. The the root filesystem for the system.

```bash

# types of cgroups on the system
ls /sys/fs/cgroup/

# look at memory cgroup
ls /sys/fs/cgroup/memory/

# all processes will use this cgroup by default
# to use a different cgroup beside the default, you must create a new and assign the process to it

# create a new cgroup and assign a process to it
cd /sys/fs/cgroup
mkdir memory/chad
ls memory/chad/

# the maximum a cgroup is allowed is 'memory.limit_in_bytes'

# use lscgroup utility to see cgroups from the host side

# compare memory cgroups before and after starting a new container with runc
# first, take a snapshot of before we make a change
cd
apt install -y cgroup-tools
lscgroup memory:/ > before.memory

# start a new container
docker container run --detach --name nginx nginx

# take an after snapshot
lscgroup memory:/ > after.memory

# compare
diff before.memory after.memory

# this is relative to the root of the memory cgroup
# inspect cgroup from the host
cd /sys/fs/cgroup/memory/
ls system.slice/docker-3076b152051a7543f4724f8950a55f84828387e30170f08e3804c03936566799.scope/

# from inside the container, the list of its own cgroups is aviailble from the /proc directory
docker exec -it nginx bash
# from inside run 'cat /proc/$$/cgroup'

# notice (on last line) that the memory cgroup is exactly what you found on the host
# once we have the cgroup name, we can modify the parameters

# see how the mem limit is 
cat system.slice/docker-3076b152051a7543f4724f8950a55f84828387e30170f08e3804c03936566799.scope/memory.limit_in_bytes

# by default, no limit, so this number represents all memory available to host machine (overall)

# this is a problem because a single container can use up all memory if it wants (if memory leak)

# limit the memory for a container
docker rm -f nginx
docker container run --detach -m 6MB --name nginx nginx
docker exec -it nginx bash
# from inside run 'cat /proc/$$/cgroup'
# exit

# cd
# lscgroup memory:/ > after.memory
# diff before.memory after.memory
# cd /sys/fs/cgroup/memory/

cat system.slice/docker-653e68c52719eff5aa7f6e29f7b17aa2a0a7a2cd6ab6375148e5502021fe121f.scope/memory.limit_in_bytes

# see the change in memory limit

# assign a process to a cgroup by write the process ID to the cgroups.procs file for that cgroup

# get the PID for the container
docker container top # 46981

# change memory limit for cgroup
cd chad
echo 6291456 > memory.limit_in_bytes
cat memory.limit_in_bytes

# assign PID to cgroup
echo 46981 > cgroup.procs

# cat out what memory cgroup is assinged to that process
cat /proc/46981/cgroup | grep memory

######################################################

# NAMESPACES


#######################################################

# by putting a process in a namespace, you can restrict the resources that are visible to that process

# a process has exactly one namespace of each type
# see the namespaces 
lsns

# for non-root users, ns list may be incomplete
sudo lsns

# use namespaces to create something that behaves like a container
# start with the UTS namespace (handles hostname and domain names)
# put a process in it's own UTS namespace, to change it's hostname (different than host)
hostname

# run a container to get a random ID for the hostname (not the name of the container)
docker container run --rm -it --name hello ubuntu bash
# inside container run 'hostname'
# inside container run 'exit'

# you can change the hostname of the container
# using the unshare command, you can create a process that has a UTS namespace of its own
sudo unshare --uts sh
hostname
hostname experiment
hostname
exit

# this ran a sh shell in a new process that has a new UTS namespace (not effect host)
hostname

# isolate process IDs
# run ps inside a container to get list of processes only running inside the container
docker container run --rm -it --name hello ubuntu bash
# inside container run 'ps -eaf'

# this is because of the process ID namespace
# PID namespace restricts the PIDs you can see

# use unshare to create new pid namespace
sudo unshare --pid sh
# run 'whoami'
# run 'whoami'
# run 'whoami'
# run 'ls'

# this did not work because it created a new PID with every command (following the process heirarchy)

# view process heirarchy by opening a new tab (second terminal) while the unshare cmd is running in the first
ps fa

# the sh process is a child of the sudo process
# get around this by using the --fork
sudo unshare --pid --fork sh
# run 'whoami'
# run 'whoami'

# no problem running the command multiple times

# view process heirarchy (in second terminal)
ps fa

# the fork version is a chile of unshare

# from the first terminal, run ps
ps
ps -eaf

# still showing processes on the entire host because it reads virtual files in /proc

# look at the /proc dir to see why
ls /proc

# every number refererences a different PID
# /proc/<pid>/exe is a symbolic link to the executable
ps
ls /proc/32440
ls -l /proc/32440/exe

# /proc is under root, so it's giving us PID under root (all of them instead of just for our namespace)
# this means that there needs to be a separate copy of /proc to return information only inside new namespace (because /proc is under root)

# change the root directory with chroot
# docker does this automatically 
# this moves the root directory for a process to point to a different location within the filesystem (not /proc)
# first, you must grab a filesystem to run /bin/bash and other command executables
cd
mkdir alpine
cd alpine
curl -o alpine.tar.gz http://dl-cdn.alpinelinux.org/alpine/v3.16/releases/x86_64/alpine-minirootfs-3.16.0-x86_64.tar.gz
tar -xvf alpine.tar.gz
rm alpine.tar.gz
cd ..

# you now have a copy of the alpine filesystem
# use chroot to move into the alpine directory
sudo chroot alpine ls

# only the child process 'ls' got it's own root directory 

# try again with running a shell as a child process
sudo chroot alpine sh
ls
ls /home
exit

# this changes the root for a process just like a container

# run chroot in a new namespace
sudo unshare --pid --fork chroot alpine sh

# ps will now show the processes just inside the PID namespace
# first mount proc as pseudofilesystem of type proc, independent from proc on host
mount -t proc proc proc
ps
exit


# Mount Namespaces





```



---



### DOCKER

```bash
# docker version
docker version

docker info 

docker # get a list of all commands, diff btwn mgmt commands

docker container run --detach --publish 8800:80 httpd

curl localhost:8800

docker container run --detach --publish 8801:80 httpd

docker container ls # two running containers

# each container has it's own netns

docker container stop <containerID>

docker container ls -a

docker container run --detach --publish 8080:80 --name web01 nginx

docker container logs web01

docker container top web01

docker container --help

docker container rm <container-id> <container-id> <container-ID> # 3 diff containers

# if one container is running, you'll get error

docker container ls

docker container rm -f <container-ID>

docker container ls -a

# a container is just a process

docker container run --name mongo --detach mongo

docker container ls

docker container top mongo # list running processes in container

ps -aux | grep mongod # look for mongod process

docker container stop mongo

docker container ls

docker container top mongo # container is not running

ps -aux | grep mongod # the process is no longer there

docker container top nginx

docker container inspect nginx

docker container stats # info for all containers

docker container stats --help

docker container ls

docker container run -it --name proxy nginx bash

# inside container run 'ls -al'

# inside container run 'exit'

docker container ls -a # command column says "bash"

docker container run -it --name ubuntu ubuntu

# inside container run 'apt update'

# inside container run 'apt install -y curl'

# inside container run 'exit'

docker container start -ai ubuntu # start a stopped container again

# 'a' is attach and 'i' is tty

# inside container run 'curl google.com'

# inside container run 'exit'

docker container start --help

docker container exec --help

docker container run --detach --publish 3306:3306 --name mysql --env MYSQL_RANDOM_ROOT_PASSWORD=yes mysql # docker container logs to find password

# get a shell to a container that's already running (previously only got a shell on startup)

docker container exec -it mysql bash

# inside container run 'ps -aux'

# inside container run 'exit'

docker container ls # didn't effect the running container (didn't stop it)

docker pull alpine

docker image ls # see size of images (alpine smaller than ubuntu)

docker container run -it alpine bash # will error because bash not found in container

docker container run -it alpine sh

# inside container run 'apk'

# inside container run 'exit'

docker container port nginx



docker container run --rm -it centos:7 bash
# in container run 'yum update curl'
# in container run 'curl --version'
# in container run 'exit'

docker container run --rm -it ubuntu:20.04 bash
# in container run 'apt update && apt install -y curl
# in container run 'curl --version'
# in container run 'exit'

docker container ls -a # they are both gone due to --rm

docker network create dude

docker container run -d --net dude --net-alias search elasticsearch:2

docker container run -d --net dude --net-alias search elasticsearch:2

docker container ls

docker container run --rm --net dude alpine:3.10 nslookup search

docker container run --rm --net dude centos curl -s search:9200

docker container run --rm --net dude centos curl -s search:9200 # should get a different response due to rount robin dns

docker image ls





```


#### CHALLENGE 6

- Run two containers together, one uses the image for apache and the other uses the image for nginx. stop and remove containers after.
- Run a container from the mysql image and use the environment variable on startup to set a db password. Retreive the password from the logs
- Get a bash shell to a container using the image centos:7. update the package manager. stop the container when you exit the bash shell.
- Run a container with mongo image. Get the running process ID for a container. Compare that PID to the PID on the local workstation. 


```bash

docker # get a list of all commands, diff btwn mgmt commands

docker version

docker info

docker container run --detach --name apache --publish 8080:80 httpd

docker container ls

# try 8080 again
docker container run --detach --name nginx --publish 80:80 nginx

curl localhost

curl localhost:8080

docker container stop apache nginx

docker container rm apache nginx

# run -it 
docker container run --rm -it centos:7 bash
# in container run 'yum update', then exit


docker container ls -a # they are both gone due to --rm

# a container is just a process
docker container run --name mongo --detach mongo

docker container ls

docker container top mongo # list running processes in container

ps -aux | grep mongod # look for mongod process

docker container stop mongo

docker container ls



```



---


### DOCKER IMAGES

```bash

docker pull nginx

# union file system - making layers 

docker history nginx:latest

# containers start with a layer called "scratch"

# copy on write - when changes to the base image, container updated in real time, but base image never changes
docker history mysql # see the copy on write 

docker image inspect nginx

docker image tag --help

# tag an image and uplaod it to dockerhub

docker pull mysql/mysql-server

docker image ls

docker pull nginx:mainline

docker image tag nginx:latest chadmcrowell/nginx:1.50

docker image tag --help

docker image ls

docker image push chadmcrowell/nginx:1.50

docker login

cat .docker/config.json

docker image push chadmcrowell/nginx:1.50

docker image tag nginx:latest chadmcrowell/nginx:1.55 # notice that it says "layers already exist"

# just because you tag an image, doesn't mean that it changes the image ID

```

### CHALLENGE 7

- pull down three images python, busybox, and redis. look at the history of that image
- tag an image with a the format of your-name/image-name

```bash

docker pull python

docker pull busybox

docker pull redis

# containers start with a layer called "scratch"

# copy on write - when changes to the base image, container updated in real time, but base image never changes
docker history python # see the copy on write

docker history busybox

docker history redis

docker image ls

docker image tag python:latest chadmcrowell/python:1.50
docker image tag busybox:latest chadmcrowell/busybox:1.20
docker image tag redis:latest chadmcrowell/redis:1

docker image tag --help

docker image ls

docker image tag python:latest chadmcrowell/python:1.55 # notice that it says "layers already exist"

# just because you tag an image, doesn't mean that it changes the image ID


```



### Dockerfile
- example dockerfile: https://docs.docker.com/get-started/02_our_app/

```bash

# build image (Dockerfile has to be in current dir)
docker image build -t custom .

docker image build -t custom . # rebuilds with a change to a line in the Dockerfile (e.g. add expose port 8080)

# keep the things that change the most at the bottom of the dockerfile for a faster build

docker container run -p 80:80 --rm nginx

docker image build -t nginx-with-html .

docker container run -p 80:80 --rm nginx-with-html

docker image ls

docker image tag nginx-with-html:latest chadmcrowell/nginx-with-html:1.0



```

### CHALLENGE 8 

- Build a Dockerfile that would allow you to build an image customizing the nginx welcome page
- Build your own image with the given requirements. 
- Push the container to the dockerhub image registry

```bash

# build an index.html
vim index.html

vim Dockerfile

# start with nginx:latest, then set WORKDIR, then COPY index.html to index.html

# pull down the code
git clone https://github.com/docker/getting-started.git

cd getting-started/app

vim Dockerfile

# start with node:12-alpine
# run 'apk add --no-cache python2 g++ make' inside the container
# the working directory is /app
# copy all the contents from the current directory into the container
# run 'yarn install --production' inside the container
# command '["node", "src/index.js"]'
# expose port 3000

docker image build -t todo-app .

docker image ls

docker run -d --name todo-app -p 3000:3000 todo-app

docker container ls

# to open the todo app in killercoda:
# - click in the top right on Traffic / Ports
# - In custom ports type 3000
# - click "access"

# push the image to dockerhub
docker image tag todo-app:latest chadmcrowell/todo-app:1.0

docker image ls

docker login

cat .docker/config.json

docker image push chadmcrowell/todo-app:1.0



```





---



### DOCKER NETWORKING

```bash

docker container run -p 80:80 --name webhost -d nginx

docker container port webhost # which ports are forwarding traffic to the container

docker container inspect --format '{{ .NetworkSettings.IPAddress }}' webhost

docker network ls # see the bridge network (default virtual network created with docker)

docker network inspect bridge # list containers attached to this network (bridge network)

docker network ls # host network to attach directly to host

docker network create my_app_net # create new virtual network using bridge driver

docker network ls # uses bridge driver

docker container run -d --name new_nginx --network my_app_net nginx

docker network inspect my_app_net # new container is on that network

docker network --help

docker network connect my_app_net webhost # add a nic to running container named "webhost"

docker container inspect webhost # view new nic on container for my_app_net network

docker network disconnect my_app_net webhost # unplugg the nic

docker container inspect webhost # nic is gone

docker container run -d --name my_nginx --network my_app_net nginx

docker network inspect my_app_net # should see two containers on that network

docker container exec -it my_nginx ping new_nginx # ping no longer comes with nginx image

docker network ls

```


### CHALLENGE 9

- Get the IP address of a container
- Create a new virtual network for a different subset of containers
- Add a nic to an already running container by adding it to the new network. 
- inspect the network to see which containers are on which network

```bash

docker network ls # see the bridge network (default virtual network created with docker)

docker container run -p 80:80 --name proxy -d nginx

docker container port proxy # which ports are forwarding traffic to the container

docker container inspect --format '{{ .NetworkSettings.IPAddress }}' proxy



docker network inspect bridge # list containers attached to this network (bridge network)

docker network ls # host network to attach directly to host

docker network create my_net # create new virtual network using bridge driver

docker network ls # uses bridge driver

docker network inspect my_net # see the new ip range

docker container ls

docker network --help

docker network connect my_net proxy # add a nic to running container named "webhost"

docker container inspect proxy # view new nic on container for my_network network

docker network ls

docker network inspect bridge
docker network inspect my_net
```







### DOCKER VOLUMES

```bash

docker pull mysql

docker image inspect mysql # look for volume 

docker container run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=yes mysql

docker container ls

docker container inspect mysql # look for volume under mounts

# it's mounted to /var/lib/docker

docker volume ls

docker volume inspect {hit-tab}

docker container run -d --name mysql2 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes mysql

docker volume ls # no way to tell them apart???

docker container stop mysql

docker container stop mysql2

docker container ls

docker container ls -a

docker volume ls

docker container rm mysql mysql2

docker volume ls # VOLUMES STILL THERE

docker container run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -v mysql-db:/var/lib/mysql mysql

docker volume ls # new volume is named

docker volume inspect mysql # friendly name

docker container rm -f mysql

docker container run -d --name mysql3 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -v mysql-db:/var/lib/mysql mysql

docker volume ls # using the same volume, i DID NOT create a new one

docker container inspect mysql3 # scroll up and look at MOUNTS at the source

# BIND MOUNT

docker container run -d --name nginx -p 80:80 -v ${pwd}:/usr/share/nginx/html nginx # must have index.html in pwd

docker container exec -it nginx bash
# in container run 'cd /usr/share/nginx/html'
# in container run 'ls -al'

# it mapped the whole directory

# any changes will be on the host and on the container all at once

# good for development, so we can work locally and it will impact container

docker container run -d --name postgres -v postgres:/var/lib/postgresql/data postgres:9.6.1

docker container logs -f postgres

docker container stop postgres

docker container run -d --name postgres2 -v postgres:/var/lib/postgresql/data postgres:9.6.2

docker container ps -a

docker volume ls 

docker container logs postgres2



# start an ubuntu container that will create a file named /data.txt with a random number between 1 and 10000
docker container run -d --name data ubuntu bash -c "shuf -i 1-10000 -n 1 -o /data.txt && tail -f /dev/null"

# get the output from the data.txt file
docker container exec data cat /data.txt

# run a second container, there is no /data.txt
docker container run -it ubuntu ls /

# remove the first container
docker container rm -f data

# create a persistent volume 
docker volume create todo-db

# list vol
docker volume ls

# stop the myapp container
docker container rm -f todo-app

# add the container with volume mount
docker container run -d --name todo-app -p 3000:3000 -v todo-db:/etc/todos todo-app

# add a few things to the todo app

# to open the todo app in killercoda:
# - click in the top right on Traffic / Ports
# - In custom ports type 3000
# - click "access"

# Stop and remove the container
docker container rm -f todo-app

docker container ls
docker container ls -a

# run container again
docker container run -d --name todo-app -p 3000:3000 -v todo-db:/etc/todos todo-app

# access website to see data persist! 

# to open the todo app in killercoda:
# - click in the top right on Traffic / Ports
# - In custom ports type 3000
# - click "access"

docker volume inspect todo-db

# The Mountpoint is the actual location on the disk where the data is stored.

# BIND MOUNTS

# With bind mounts, we control the exact mountpoint on the host

# use a bind mount to mount our source code into the container and see the changes right away



```


### CHALLENGE 10

- Create a container based on the mysql image while mounting a volume named mysql-db into the container at /var/lib/mysql. Delete the container and create a new one that accessess the same data.
- Create a bind mount directly to local mountpoint in /app dir, update the source code, and see the changes in the container immediately. Rebuild the image when done.

```bash
docker volume ls

docker container run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -v mysql-db:/var/lib/mysql mysql

docker volume ls # new volume is named

docker volume inspect mysql-db # friendly name

# the mountpoint is where the data resides locally


docker container rm -f mysql

docker volume ls # data is still there (persists)

docker container run -d --name mysql2 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -v mysql-db:/var/lib/mysql mysql

docker volume ls # using the same volume, i DID NOT create a new one

docker container inspect mysql2 # scroll up and look at MOUNTS at the source

docker container rm -f todo-app

docker container ls -a

# from the gettingstarted/app dir
docker container run -d --name todo-app -p 3000:3000 -w /app -v "$(pwd):/app" node:12-alpine sh -c "yarn install --ignore-engines && yarn run dev"

# '-w /app' sets the “working directory” or the current directory that the command will run from
# '-v "$(pwd):/app"' bind mount the current directory from the host in the container into the /app directory
# 'sh -c "yarn install && yarn run dev"' Starting a shell using sh (alpine doesn’t have bash) and running yarn install to install all dependencies and then running yarn run dev. If we look in the package.json, we’ll see that the dev script is starting nodemon.

docker logs todo-app # when you see 'listening on 3000' then it's ready to go

# view the app in a web browser

# In the src/static/js/app.js file, change the “Add Item” button to “Add”. This change will be on line 109:
vim src/static/js/app.js # search for "adding"

docker container stop todo-app

docker container ls -a

docker image build -t todo-app .

# using bind mounts like this, we didn't have to keep rebuilding our image in order to see the changes, we were able to see it in real time


```


### Docker compose 

```bash

```


### CHALLENGE 11

- Create two Docker containers by creating a docker compose file. The frontend will use 'node:12-alpine' and backend will use mysql
- Run the docker compose commands to start the multi-container service created in the compose file.

```bash

# in getting-started/app create docker-compose.yml
vim docker-compose.yml

# start off by defining the schema version

# define the list of services (or containers) we want to run

# 

# FINAL compose file should look like this

# version: "3.7"

# services:
#   app:
#     image: node:12-alpine
#     command: sh -c "yarn install && yarn run dev"
#     ports:
#       - 3000:3000
#     working_dir: /app
#     volumes:
#       - ./:/app
#     environment:
#       MYSQL_HOST: mysql
#       MYSQL_USER: root
#       MYSQL_PASSWORD: secret
#       MYSQL_DB: todos

#   mysql:
#     image: mysql:5.7
#     volumes:
#       - todo-mysql-data:/var/lib/mysql
#     environment:
#       MYSQL_ROOT_PASSWORD: secret
#       MYSQL_DATABASE: todos

# volumes:
#   todo-mysql-data:


docker compose up -d

docker compose logs

docker compose --help

docker compose ps

docker compose top

docker compose down 

```

### DOCKER SECURITY 

- [Docker Bench](https://github.com/docker/docker-bench-security)
- 




This is intended to be a few hours of workshop where the expectation is to teach linux required for devops - basics commands etc and then moving to VMs' then moving to Docker and then explaing about dokcer , what it is container, installation, main commands, volumes, dockerfile, docker-compose, dockerhub, docker registry,

Yeah so basically we need to asume that the attendees have no prior knowledge and you make them understand in detail

when you reach the section on how containers work you can refer this video that I made - https://youtu.be/buHPsFgpsgU

similar you can find on dockerfile examples. 

Docker volume and security is missing which is part of docker 101 

Now there is no limit to the timings tbh so it totally depends on you which sections you think you can fast forward and which ones you can explain a bit well. I would say minimum 3 hours would be required as docker itself is a huge topic.

You can see this all needs to be covered for docker:
https://youtube.com/playlist?list=PL5uLNcv9SibBZj30yqG01a7A4_MXSyGK3

1 hr for linux and git  2 hour for docker IMO 
If I were you I would skip shell scirpt

https://iximiuz.com/en/posts/container-learning-path/
