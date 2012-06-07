"""
Wrap the catreward (cr) spm8 functions, allowing for easy
(if inefficient) parallelization inside iPython/StarCluster.
"""
from subprocess import Popen, PIPE


def _matlab(cmd):
    """ Run <cmd> in matlab.  Return anything printed to stdout. """
    
    p = Popen(cmd, shell=True, stdin=PIPE, stdout=PIPE, close_fds=True)
    stdout = p.communicate()
    
    return stdout


def _matlab_base_cmd():
    """ Set the base matlab command. """
    import sys
    
    if sys.platform == 'darwin':
        return "matlab -nodesktop -maci -nosplash -nodisplay -r "
            ## OS X
    elif sys.platform == 'linux2':
        return "matlab -nodesktop -nosplash -nodisplay -r "
            ## This will be a EC2 node....
    else:
        raise EnvironmentError('Platform is unsupported.')


def cr_ana(dir_path):
    """
    Matlab wrapper. Run cr_ana.m for the dir specified in
    <dir_path>.
    """
    
    cmd = _matlab_base_cmd()
    cmd = cmd + "\"cr_ana('{0}'".format(dir_path) + ")\""
    stdout = _matlab(cmd)
    
    return stdout


def cr_realign(dir_path):
    """
    Matlab wrapper. Run cr_realign.m for the dir specified in
    <dir_path>.
    """
    
    cmd = _matlab_base_cmd()
    cmd = cmd + "\"cr_realign('{0}'".format(dir_path) + ")\""
    stdout = _matlab(cmd)
    
    return stdout


def cr_func(dir_path, func_name):
    """
    Matlab wrapper. Run cr_func.m on the functional data
    (<func_name>) specified in <dir_path>.
    """
    
    cmd = _matlab_base_cmd()
    cmd = cmd + "\"cr_func('{0}','{1}'".format(dir_path, func_name) + ")\""
    stdout = _matlab(cmd)
    
    return stdout


def drop6(subfile='sub.csv', funcfile='func.csv'):
    """
    Drop the first 6 volumes for every subject in
    <subfile> in each entry in <funcfile>.
    
    Assumes every subject's data is in the
    current directory.
    """
    import os
    import csv
    from fmri.nii import drop_vol
    
    # Get the subject names from subfile
    fs = open(subfile, 'r')
    subnames = csv.reader(fs).next()
    fs.close()
    
    # Read in funcfile
    ff = open(funcfile, 'r')
    funcnames = csv.reader(ff).next()
    ff.close()
    
    # rememer the pwd
    oldpwd = os.getcwd()
    
    # then get to droppin' each
    for s in subnames:
        os.chdir(s)
        [drop_vol(6, f + '.nii', True) for f in funcnames]
        os.chdir(oldpwd)
            ## reset path for next


def make_batch(path='', subfile='sub.csv', funcfile='func.csv'):
    """
    Uses <subfile> (a 1d csv file) and <funcfile> (also 1d) to return
    three parallizable lists of batches.
    
    Returns:
    batch1 = []  - cr_ana and
    batch2 = []  - cr_realign are independent of each other
    batch3 = []  - cr_func requires batch1,2 data
    """
    import csv
    import os
    
    # Get the subject names from subfile
    fs = open(subfile, 'r')
    subnames = csv.reader(fs).next()
    fs.close()
    
    # and the functional data names.
    ff = open(funcfile, 'r')
    funcnames = csv.reader(ff).next()
    ff.close()
    
    # Each entry in each bacth should work inside
    # run, e.g. fmri.catreward.spm.run(batch1[0],batch1[1:])
    batch1 = []
    batch2 = []
        ## cr_ana and cr_realign are independent of each other
    batch3 = []
        ## cr_func (require batch1 data)
    for s in subnames:
        spath = os.path.abspath(s)
        # Append a tuple like:
        # ('spm_function_name','arg1','arg2', ...)
        batch1.append(('cr_ana', spath))
        batch2.append(('cr_realign', spath))
        [batch3.append(('cr_func', spath, f)) for f in funcnames]
    
    return batch1, batch2, batch3


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
        print('Trying {0}.'.format(args))
        
        if len(args) == 2:
            stdout = getattr(spm, args[0])(args[1])
        else:
            stdout = getattr(spm, args[0])(*args[1:])
    except AttributeError:
        print('<name> was not known. Skipping.')
    
    return stdout
