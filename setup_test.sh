#!/bin/bash


# setup our initial "local repo" (with remotes to the currently non-existant other "local repos")
git init --bare ./test_orgA
cd ./test_orgA
git remote add orgA ../test_orgA
git remote add orgB ../test_orgB
git remote add orgC ../test_orgC
rm ./hooks/*.sample
cd ..

# create a working copy and push a change to orgA (just some there's something there)
git init ./wc
cd wc
echo "Welcome to my test repo" > README
git add README
git commit -m "Added README"
git checkout -b sync
git checkout master
git remote add orgA ../test_orgA
git push --all orgA
cd ..
rm -Rf ./wc

# install the hooks in orgA
cp config pre* post* ./test_orgA/hooks/

# create the other "local repos"
cp -R ./test_orgA ./test_orgB
cp -R ./test_orgA ./test_orgC

# update the config in those new repos
cat test_orgB/hooks/config | sed 's/^WHO_AM_I.*$/WHO_AM_I="orgB"/g' > $$
mv $$ test_orgB/hooks/config

cat test_orgC/hooks/config | sed 's/^WHO_AM_I.*$/WHO_AM_I="orgC"/g' > $$
mv $$ test_orgC/hooks/config


# now any commit to orgA, B or C should be propogated automattically to the
# other repos



# so lets test - lets make a simple commit to orgC
git clone ./test_orgC ./wc
cd wc
echo "content" >> README
git add README
git commit -m "Added content to the README"
git push
cd ..
rm -Rf ./wc

# lets check it back it into orgB
git clone ./test_orgB ./wc
cd wc
test_content=`cat README | grep content`
if [ "$test_content" = "content" ]
then
        echo "Looks good to me...."
else
        echo "The commit didn't seem to propagate :("
fi
cd ..
rm -Rf ./wc

