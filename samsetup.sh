#!/bin/bash
clear
TFLINK=https://releases.hashicorp.com/terraform/0.12.1/terraform_0.12.1_linux_amd64.zip
TFVERS=12
#root only!
if [ "$(whoami)" != 'root' ]; then
	echo "You are not root, please f off!"
	exit 1
else
    	echo "Ok, you are root! Proceeding.."
fi

echo "Installing basic/necessary packages.."
yum update -y
pip3 install --upgrade awscli
yum install -y unzip jq curl vim

echo "Installing Terraform.."
curl ${TFLINK} -s -o "terraform${TFVERS}.zip"
unzip terraform${TFVERS}.zip
mv terraform /usr/local/bin
rm -rf terraform${TFVERS}.zip

echo "Installing Terraform enterprise cli.."
git clone git@github.com:hashicorp/tfe-cli.git
cd tfe-cli/bin
echo "export PATH=$PWD:\$PATH" >> ~/.bash_profile
sudo ln -s $PWD/tfe /usr/local/bin/tfe

#setup aliases for github so a simple "gp" will add, commit, and push
#your changes to GitHub
echo "Setup GitHub shortcuts.."
cat <<EOF > ~/.bash_profile
gitpush() {
    git add .
    git commit -m "updated"
    git push
}
alias gp=gitpush
EOF
source ~./bash_profile

#Clean up and clear out cache of yum repository
yum clean all
