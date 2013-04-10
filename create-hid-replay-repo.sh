#!/bin/sh

current_dir=$(pwd)
destdir=${current_dir}/repo
archs="i686 x86_64 SRPMS"
releases="17 18 19"
md_target=${current_dir}/Fedora.md

for release in $releases
do
	for arch in $archs
	do
		pushd ${destdir}/${release}/${arch} >/dev/null 2>&1
		createrepo .
		popd >/dev/null 2>&1
	done
done

cat > ${md_target} <<EOF
---
layout: default
title: HID-replay - Fedora packages
---

# Fedora

## Automatic instructions
You can grab our [.repo](repo/hid-replay.repo):
	#> wget http://bentiss.github.io/hid-replay-docs/repo/hid-replay.repo -o /etc/yum.repos.d/hid-replay.repo

Then you can install it through:
	#> yum install hid-replay

## Manual downloading
EOF

for release in $releases
do
	echo "" >> ${md_target} 
	echo "### Fedora ${release}" >> ${md_target} 
	for arch in $archs
	do
		pushd ${destdir}/${release}/${arch} >/dev/null 2>&1
		rpm=$(ls -t hid-replay-[0-9]*.rpm | head -n 1)
		echo "* [${rpm}](repo/${release}/${arch}/${rpm})" >> ${md_target}
		popd >/dev/null 2>&1
	done
done

