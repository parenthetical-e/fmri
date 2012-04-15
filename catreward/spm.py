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
	print cmd
	call(cmd,shell=True)

