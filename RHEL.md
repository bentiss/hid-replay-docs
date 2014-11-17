---
layout: default
title: HID-replay - RHEL packages
---

# RHEL

As of now, all the builds are created on the hid-replay [copr](https://copr.fedoraproject.org/coprs/bentiss/hid-replay/)

## Automatic installation of the copr repo (RHEL 7 and up)
You first have to install dnf-plugins-core:

	#> dnf install -y dnf-plugins-core

Then enable the repo:

	#> dnf copr enable bentiss/mtdiag-qt

And finally install hid-replay:

	#> dnf install hid-replay

## Manual install of the copr repo
The [.repo](repo/hid-replay.repo) can also be grabbed from the webpage (replace epel-6 with the appropriate version, or refer to the [copr](https://copr.fedoraproject.org/coprs/bentiss/hid-replay/) page)

	#> curl https://copr.fedoraproject.org/coprs/bentiss/hid-replay/repo/epel-6/bentiss-hid-replay-epel-6.repo --output /etc/yum.repos.d/hid-replay.repo

Then you can install it through:

	#> yum install hid-replay
