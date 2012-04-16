""" 
Wrap the catreward (cr) spm8 functions, allowing for easy 
(if inefficient) parallelization inside iPython/StarCluster.
"""
from subprocess import call, Popen, PIPE

def _matlab(cmd):
	""" Run <cmd> in matlab.  Return anything printed to stdout. """
	p = Popen(cmd,shell=True,stdin=PIPE,stdout=PIPE,close_fds=True)
	p.wait()
	stdout = p.communicate()
	
	return stdout


def cr_ana(dir_path):
	""" Matlab wrapper. Run cr_ana.m for the dir specified in 
	<dir_path>."""

	cmd = "matlab -nodesktop -maci -nosplash -nodisplay -r "
	cmd = cmd + "\"cr_ana('{0}'".format(dir_path) + ")\""
	print(cmd)
	stdout = _matlab(cmd) 
	
	return stdout
	

def cr_realign(dir_path):
	""" Matlab wrapper. Run cr_realign.m for the dir specified in 
	<dir_path>."""

	cmd = "matlab -nodesktop -maci -nosplash -nodisplay -r "
	cmd = cmd + "\"cr_realign('{0}'".format(dir_path) + ")\""
	
	return _matlab(cmd) # returns stdout


def cr_func(dir_path,func_name):
	""" Matlab wrapper. Run cr_func.m on the functional data 
	(<func_name>) specified in <dir_path>."""

	cmd = "matlab -nodesktop -maci -nosplash -nodisplay -r "
	cmd = cmd + "\"cr_func('{0}','{1}'".format(dir_path,func_name) + ")\""
	
	return _matlab(cmd) # returns stdout


def make_batch(subfile='sub.csv',funcfile='func.csv'):
	"""
	Uses <subfile> (a 1d csv file) and <funcfile> (also 1d) to return 
	a tuple of two lists of all functions and their arguements for 
	both the first and second batchs.

	batch1 = []  - cr_ana and cr_realign are independent of each other
	batch2 = []  - cr_func (requires batch1 data)
	"""
	import csv
	import os

	# Get the subject names from subfile
	fs = open(subfile,'r')
	subnames = csv.reader(fs).next()
	fs.close()

	# and the functional data names.
	ff = open(funcfile,'r')
	funcnames = csv.reader(ff).next()
	ff.close()

	# Each entry in each bacth should work inside
	# run, e.g. fmri.catreward.spm.run(batch1[0],batch1[1:])
	batch1 = []  ## cr_ana and cr_realign are independent of each other
	batch2 = []  ## cr_func (require batch1 data)
	for s in subnames:
		spath = os.path.abspath(s)
		# Make a tuple like:
		# ('spm_function_name','arg1','arg2', ...)
		batch1.append(('cr_ana',s))
		batch1.append(('cr_realign',s))
		
		[batch2.append(('cr_func',s,f)) for f in funcnames]
			
	return batch1, batch2


def run(args=()):
	""" 
	Run a spm function (name at arg[0]; one of the cr_* functions in 
	this module), passing its arguments from args[1:].

	Plays well with make_batch().
	"""
	from fmri.catreward import spm

	# Try and get function name (arg 0) on spm then call it
	# with args inside.
	try:
		if len(args) == 2:
			stdout = getattr(spm, args[0])(args[1])
		else:
			stdout = getattr(spm, args[0])(*args[1:])
	except AttributeError:
		print('<name> was not known.')

	return stdout

