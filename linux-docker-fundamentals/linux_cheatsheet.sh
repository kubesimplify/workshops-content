#!/bin/bash

ls	# Lists all files and directories in the present working directory
ls -R	# Lists files in sub-directories as well
ls -a	# Lists hidden files as well
ls -al	# Lists files and directories with detailed information like permissions,size, owner, etc.
cd or cd ~	# Navigate to HOME directory
cd ..	# Move one level up
cd	# To change to a particular directory
cd /	# Move to the root directory
cat > filename	# Creates a new file
cat filename	# Displays the file content
cat file1 file2 > file3	# Joins two files (file1, file2) and stores the output in a new file (file3)
mv file "new file path"	# Moves the files to the new location
mv filename new_file_name	# Renames the file to a new filename
sudo	# Allows regular users to run programs with the security privileges of the superuser or root
rm filename	# Deletes a file
man	# Gives help information on a command
history	# Gives a list of all past commands typed in the current terminal session
clear	# Clears the terminal
mkdir # directoryname	Creates a new directory in the present working directory or a at the specified path
rmdir	# Deletes a directory
mv	# Renames a directory
apt-get # Command used to install and update packages
ls -l	to show file type and access permission
# r	read permission
# w	write permission
# x	execute permission
# -=	no permission
Chown user	# For changing the ownership of a file/directory
Chown user:group filename	# change the user as well as group for a file or directory
echo $VARIABLE	# display value of a variable
env	# Displays all environment variables
VARIABLE_NAME=variable_value	# Create a new variable
Unset	# Remove a variable
export Variable=value	# To set value of an environment variable
sudo adduser username	# To add a new user
sudo passwd -l 'username'	# To change the password of a user
sudo userdel -r 'username'	# To remove a newly created user
sudo usermod -a -G GROUPNAME USERNAME	# To add a user to a group
sudo deluser USER GROUPNAME	# To remove a user from a group
finger	# Shows information of all the users logged in
finger username	# Gives information of a particular user
SSH username@ip-address # or hostname	login into a remote Linux machine using SSH
Ping hostname="" or =""	# To ping and Analyzing network and host connections
dir	# Display files in the current directory of a remote computer
cd "dirname"	# change directory to “dirname” on a remote computer
put file	# upload ‘file’ from local to remote computer
get file	# Download ‘file’ from remote to local computer
quit	# Logout
bg	# To send a process to the background
fg	# To run a stopped process in the foreground
top	# Details on all Active Processes
ps	# Give the status of processes running for a user
ps PID	# Gives the status of a particular process
pidof	# Gives the Process ID (PID) of a process
kill PID	# Kills a process
nice	# Starts a process with a given priority
renice	# Changes priority of an already running process
df	# Gives free hard disk space on your system
free	# Gives free RAM on your system
dpkg --print-architecture # output the primary architecture of Debian and derivatives
rpm --eval '%{_arch}' # output the primary architecture on RPM-based systems

########## VIM EDITOR ######################

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

