""" 
Wrap the catreward (cr) spm8 functions, allowing for easy 
(if inefficient) parallelization inside iPython/StarCluster.
"""
from subprocess import call


def cr_ana(dir_path):
	cmd = "matlab -nodesktop -maci -nosplash -nodisplay -r "
	cmd = cmd + "\"cr_ana('{0}'".format(dir_path) + ")\""
	call(cmd,shell=True)


def cr_realign(dir_path):
	cmd = "matlab -nodesktop -maci -nosplash -nodisplay -r "
	cmd = cmd + "\"cr_realign('{0}'".format(dir_path) + ")\""
	call(cmd,shell=True)


def cr_func(dir_path,func_name):
	cmd = "matlab -nodesktop -maci -nosplash -nodisplay -r "
	cmd = cmd + "\"cr_func('{0}','{1}'".format(dir_path,func_name) + ")\""
	call(cmd,shell=True)


def make_batch():
	""" 
	Return a tuple of two lists of all functions and their arguements for 
	both the first and second batchs.
	"""
	
	sub_dirs = [
		'101M80351917',
		'102M80359344',
		'103M80358136',
		'104M80368842',
		'105M80350861',
		'106M80381623',
		'108M80357327',
		'109M80328568',
		'111M80343408',
		'112M80364602',
		'113M80380288',
		'114M80371580',
		'115M80364638',
		'116M80363397',
		'117M80354305',
		'118M80330684']

	func_names = [
		'pavlov',
		'taskA',
		'taskB',
		'coaster_localizer']

	batch1 = []
	batch2 = []
	for s in sub_dirs:
		batch1.append(('cr_ana',s))
		batch1.append(('cr_realign',s))
		
		[batch2.append(('cr_func',s,f)) for f in func_names]
			
	return batch1, batch2


def run(name,*args):
	""" 
	Run a spm function <name> (see the cr_* functions in this module),
	passing its arguments.

	Plays well with make_batch().
	"""
	from fmri.catreward import spm

	# Try and get function <name> then call it
	# with args inside.
	try: 
		getattr(spm, name)(*args)
	except AttributeError:
		print('<name> was not known.')

