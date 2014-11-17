---
layout: default
title: HID-replay - RHEL packages
---

# RHEL

As of now, all the builds are created on the hid-replay [copr](https://copr.fedoraproject.org/coprs/bentiss/hid-replay/)

## Manual install of the copr repo for RHEL 7
The [.repo](https://copr.fedoraproject.org/coprs/bentiss/hid-replay/repo/epel-7/bentiss-hid-replay-epel-7.repo) can be grabbed with the following command

	#> curl https://copr.fedoraproject.org/coprs/bentiss/hid-replay/repo/epel-7/bentiss-hid-replay-epel-7.repo --output /etc/yum.repos.d/hid-replay.repo

Then you can install it through:

	#> yum install hid-replay

## Manual install of the copr repo for RHEL 6
The [.repo](https://copr.fedoraproject.org/coprs/bentiss/hid-replay/repo/epel-6/bentiss-hid-replay-epel-6.repo) can be grabbed with the following command

	#> curl https://copr.fedoraproject.org/coprs/bentiss/hid-replay/repo/epel-6/bentiss-hid-replay-epel-6.repo --output /etc/yum.repos.d/hid-replay.repo

Then you can install it through:

	#> yum install hid-replay

