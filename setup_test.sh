#!/bin/bash


git init --bare ./test_orgA
cd ./test_orgA
git remote add orgA file:///Users/tim/Development/git-mirror-sync/test_orgA
git remote add orgB file:///Users/tim/Development/git-mirror-sync/test_orgB
git remote add orgC file:///Users/tim/Development/git-mirror-sync/test_orgC
rm ./hooks/*.sample
cd ..

git init ./wc
cd wc
echo "Welcome to my test repo" > README
git add README
git commit -m "Added README"
git checkout -b sync
git checkout master
git remote add orgA file:///Users/tim/Development/git-mirror-sync/test_orgA
git push --all orgA
cd ..
rm -Rf ./wc

cp config pre* post* ./test_orgA/hooks/

cp -R ./test_orgA ./test_orgB
cp -R ./test_orgA ./test_orgC

cat test_orgB/hooks/config | sed 's/^WHO_AM_I.*$/WHO_AM_I="orgB"/g' > $$
mv $$ test_orgB/hooks/config

cat test_orgC/hooks/config | sed 's/^WHO_AM_I.*$/WHO_AM_I="orgC"/g' > $$
mv $$ test_orgC/hooks/config

