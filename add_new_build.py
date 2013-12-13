#!/bin/env python
# -*- coding: utf-8 -*-
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#

from __future__ import print_function
import sys
import os
import koji

class KojiException(Exception):pass

def usage():
	print("""Usage {0} TASK_XXXX
	Where:
	- TASK_XXXX is the task id of the koji task
	  (e.g. http://koji.fedoraproject.org/koji/taskinfo?taskID=TASK_XXXX)
""".format(sys.argv[0]))

def prep_download_task_rpm(session, task_id, outputs):
	info = session.getTaskInfo(task_id)
	if info['waiting']:
		raise KojiException("The task {0} is still not finished, please wait for its completion before running {1}.".format(task_id, sys.argv[0]))

	arch = info['arch']
	files = session.listTaskOutput(task_id)
	output = [(task_id, info['arch'], filename) for filename in files if not filename.endswith('.log')]
	outputs.extend(output)

	children = session.getTaskChildren(task_id, request=True)
	children.sort(cmp=lambda a, b: cmp(a['id'], b['id']))
	for child in children:
		prep_download_task_rpm(session, child['id'], outputs)

def check_and_chdir(dir):
	if not os.path.exists(dir):
		os.mkdir(dir)
	os.chdir(dir)

def _download(session, working_dir, task_id, arch, filename):
	current_dir = working_dir + "/" + arch
	check_and_chdir(current_dir)
	print(current_dir + '/' + filename)
	with open(filename, 'w') as f:
		f.write(session.downloadTaskOutput(task_id, filename))

def download_rpms(session, output):
	base_dir = os.getcwd()
	working_dir = base_dir + '/repo'
	check_and_chdir(working_dir)

	srpm = None
	rpms = []

	for task_id, arch, filename in output:
		if filename.endswith(".src.rpm"):
			srpm = task_id, filename
		else:
			rpms.append((task_id, arch, filename))

	dist = srpm[1].split('.')[-3].lstrip('fc')

	working_dir += "/" + dist

	check_and_chdir(working_dir)

	_download(session, working_dir, srpm[0], "SRPMS", srpm[1])

	for task_id, arch, filename in rpms:
		_download(session, working_dir, task_id, arch, filename)



def main():
	if len(sys.argv) <= 1:
		usage()
		sys.exit(1)

	task_id = sys.argv[1]
	try:
		task_id = int(task_id)
	except:
		usage()
		sys.exit(1)

	session = koji.ClientSession("http://koji.fedoraproject.org/kojihub")

	output = []

	try:
		prep_download_task_rpm(session, task_id, output)
	except KojiException, e:
		print(e)
		sys.exit(1)

	download_rpms(session, output)

if __name__ == "__main__":
	main()
