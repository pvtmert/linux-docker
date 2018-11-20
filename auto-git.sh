#!/usr/bin/env bash

cat versions.txt | while read ver; do
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

git push --all origin
