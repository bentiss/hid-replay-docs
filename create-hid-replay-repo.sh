#!/bin/sh

args=$@
current_dir=$(pwd)
destdir=${current_dir}/repo
archs="i386 x86_64 SRPMS"
releases="17 18 19"
md_target=${current_dir}/Fedora.md

rebuild_repodata=1

for arg in $args
do
	case "$arg" in
		-h|--help)
			echo "Usage: `basename $0` [OPTIONS...]"
			echo "  -n, --norepo	Do not rebuild repodata, but only the `basename $md_target` target file."
			exit 1;;
		-n|--norepo)
			rebuild_repodata=0;;
	esac
done

if [[ x$rebuild_repodata == x1 ]]
then
	for release in $releases
	do
		for arch in $archs
		do
			pushd ${destdir}/${release}/${arch} >/dev/null 2>&1
			createrepo .
			popd >/dev/null 2>&1
		done
	done
fi

cat > ${md_target} <<EOF
---
layout: default
title: HID-replay - Fedora packages
---

# Fedora

## Automatic instructions
You can grab our [.repo](repo/hid-replay.repo):
	#> curl http://bentiss.github.io/hid-replay-docs/repo/hid-replay.repo --output /etc/yum.repos.d/hid-replay.repo

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

