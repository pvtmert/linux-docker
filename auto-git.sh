#!/usr/bin/env bash

cat $1 | while read ver; do
	git checkout master
	git checkout -b $ver || git checkout $ver
	make $ver.dockerfile
	git add $ver.dockerfile
	git commit -am "added $ver"
	git rm -f dockerfile
	git mv $ver.dockerfile dockerfile
	git commit -am "use as default dockerfile"
	git checkout master
	continue
done

cat $2 | while read ver; do
	git checkout $ver
	short=$(echo $ver | cut -d. -f-2)
	git tag -d $short
	git tag    $short
	git checkout master
done

git push --prune --all  origin
git push --prune --tags origin
