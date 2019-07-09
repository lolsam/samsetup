#!/bin/bash
clear
TFLINK=https://releases.hashicorp.com/terraform/0.12.1/terraform_0.12.1_linux_amd64.zip
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
pip install --upgrade awscli

echo "Installing Terraform.."
curl ${TFLINK} -s -o "terraform${TFVERS}.zip"
unzip terraform${TFVERS}.zip -d /usr/local/bin/
rm -rf terraform${TFVERS}.zip

echo "Installing Terraform enterprise cli.."
git clone https://github.com/hashicorp/tfe-cli.git
cd tfe-cli/bin
echo "export PATH=$PWD:\$PATH" >> ~/.bash_profile
ln -s $PWD/tfe /usr/local/bin/tfe

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
EOF

#execute changes asap without a reload
source ~/.bash_profile

#Clean up and clear out cache of yum repository
yum clean all

#Done
echo "End of script -- setup complete :) "
