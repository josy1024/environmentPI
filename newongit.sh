#git in "primary codebase"

git commit -m 'init import'
git config --global user.email "josy1024@gmail.com"
git config --global user.name "josy1024"
git commit -m 'init import'
git remote add origin https://github.com/josy1024/environmentPI.git
git pull origin master
git push origin master

#
# store credentials!
git config credential.helper store

#git bash added git repository
git clone https://github.com/josy1024/environmentPI.git