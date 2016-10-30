
#!/bin/bash
git config --global user.name "Lucas Maurice"
git config --global user.email "lucas.maurice@outlook.com"
ssh-keygen -t rsa -b 4096 -C "lucas.maurice@outlook.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
pbcopy < ~/.ssh/id_rsa.pub
echo "Now go in your GitHub Settings and paste your SSH key"
