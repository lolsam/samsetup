#!/bin/bash
clear
TFLINK=https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip
TFVERS=12

#root only!
echo "Checking to see if you are root"
if [ "$(whoami)" != 'root' ]; then
	echo "You are not root; the door is that way!"
	exit 1
else
    	echo "Ok, you are root! Proceeding.."
fi
echo "Installing basic/necessary packages.."
yum update -y
yum install -y unzip jq curl vim git python pip3

echo "Installing AWS CLI (V2)"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
rm -rf awscliv2.zip 

echo "Installing Terraform.."
curl ${TFLINK} -s -o "terraform${TFVERS}.zip"
sudo unzip terraform${TFVERS}.zip -d /usr/local/bin/
rm -rf terraform${TFVERS}.zip

echo "Installing Packer.." 
curl "https://releases.hashicorp.com/packer/1.5.6/packer_1.5.6_linux_amd64.zip" -o "packer.zip" 
sudo unzip packer.zip -d /usr/local/bin
rm -rf packer.zip

#setup aliases for github and terraform commands to save my typing energy
echo "Setup GitHub and Terraform shortcuts.."
cat <<EOF > ~/.bash_profile
gitpush() {
    git add .
    git commit -m "updated"
    git push
}
alias gp=gitpush

########### Terraform plan
tplan() {
    terraform plan
}
alias tp=tplan

########### Terraform format
tformat() {
  terraform format
}
alias tf=tformat

########## Terraform apply auto
tapprove() {
  terraform apply -auto-approve
}
alias taa=tapprove

########## Terraform destroy auto
tdestroy() {
  terraform destroy -auto-approve
}
alias tda=tdestroy

alias c=clear

export PS1="\[$(tput bold)\]\[\033[38;5;220m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;51m\]\h\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;13m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]\n\[$(tput sgr0)\]\[\033[38;5;10m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

EOF

#execute changes asap without a reload
source ~/.bash_profile || { echo 'Setting up .bash_profile failed' ; exit 1; }

#allow password-less login if it's a lab server 
if [ "$(hostname -d)" == "mylabserver.com" ]; then echo "%cloud_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/10-ops; fi

#Clean up and clear out cache of yum repository
yum clean all

#If wanting to install AWS CodeDeploy, uncomment the line below
#wget -O - https://raw.githubusercontent.com/lolsam/samsetup/master/install-codedeploy.sh | bash -x

#Done
echo "End of script -- setup complete :) "
