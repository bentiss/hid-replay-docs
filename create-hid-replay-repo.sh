#!/bin/sh

args=$@
current_dir=$(pwd)
destdir=${current_dir}/repo
archs="armhfp i386 x86_64 SRPMS"
releases="17 18 19 20"
rhel_releases="RHEL-6.4"
md_target=${current_dir}/Fedora.md
rhel_md_target=${current_dir}/RHEL.md

rebuild_repodata=1
rebuild_rhel_repodata=0
rebuild_fedora_repodata=0

for arg in $args
do
	case "$arg" in
		-h|--help)
			echo "Usage: `basename $0` [OPTIONS...]"
			echo "  -n, --norepo	Do not rebuild repodata, but only the `basename $md_target` target file."
			exit 1;;
		-n|--norepo)
			rebuild_repodata=0;;
		-r|--rhel)
			rebuild_repodata=0
			rebuild_rhel_repodata=1;;
		-f|--fedora)
			rebuild_repodata=0
			rebuild_fedora_repodata=1;;
	esac
done

if [[ x$rebuild_repodata == x1 ]]
then
	rebuild_rhel_repodata=1
	rebuild_fedora_repodata=1
fi

if [[ x$rebuild_fedora_repodata == x1 ]]
then
	for release in $releases
	do
		for arch in $archs
		do
			WD=${destdir}/${release}/${arch}
			if [ -e $WD ]
			then
				pushd ${WD} >/dev/null 2>&1
				createrepo .
				popd >/dev/null 2>&1
			fi
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
		WD=${destdir}/${release}/${arch}
		if [ -e $WD ]
		then
			pushd ${WD} >/dev/null 2>&1
			rpm=$(ls -v hid-replay-[0-9]*.rpm | tail -n 1)
			echo "* [${rpm}](repo/${release}/${arch}/${rpm})" >> ${md_target}
			popd >/dev/null 2>&1
		fi
	done
done

if [[ x$rebuild_rhel_repodata == x1 ]]
then
	for release in $rhel_releases
	do
		for arch in $archs
		do
			WD=${destdir}/${release}/${arch}
			if [ -e $WD ]
			then
				pushd ${WD} >/dev/null 2>&1
				createrepo .
				popd >/dev/null 2>&1
			fi
		done
	done
fi

cat > ${rhel_md_target} <<EOF
---
layout: default
title: HID-replay - RHEL 6 packages
---

# RHEL

## Automatic instructions
You can grab our [.repo](repo/hid-replay-rhel.repo):
	#> curl http://bentiss.github.io/hid-replay-docs/repo/hid-replay-rhel.repo --output /etc/yum.repos.d/hid-replay-rhel.repo

Then you can install it through:
	#> yum install hid-replay

## Manual downloading
EOF

for release in $rhel_releases
do
	echo "" >> ${rhel_md_target} 
	echo "### ${release}" >> ${rhel_md_target} 
	for arch in $archs
	do
		WD=${destdir}/${release}/${arch}
		if [ -e $WD ]
		then
			pushd ${WD} >/dev/null 2>&1
			rpm=$(ls -v hid-replay-[0-9]*.rpm | tail -n 1)
			echo "* [${rpm}](repo/${release}/${arch}/${rpm})" >> ${rhel_md_target}
			popd >/dev/null 2>&1
		fi
	done
done

