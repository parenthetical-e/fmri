""" 
A set of functions for creating or maipulating files needed for design
matrices, both in spm and python.
"""

def spm_onsets(trialfile='',durations=3,recode=None,):
	""" 
	Map <trialfile> (a 1d csv) into onset/TR time which is determind by 
	<durations> (which can be an int if every trial had the same length in the 
	model or a list if not).  

	If <recode> is a dict of the form {1:1,2:1,3:1} where the key is the 
	current code in trialfile and value is what you would 
	like that one to be recoded as.  In this example, 1,2,3 all become 1.
	
	Any value without a key, but with an entry in trialfile is silently left
	as is.
	"""
	import csv
	
	f = open(trialfile,'r')
	trials = csv.reader(fs).next()
	fs.close()

	if isinstance(duration,int):
		tmp = [durations,] * len(trials)
	elif isinstance(duration,(list,tuple)):
		pass
	else:
		raise TypeError('<durations> must be an int, list or tuple.')

	if recode != None:
		print('Recoding....')
		[rtrials.extend(recode.get(t)) for t in trials]

	# mMap the trialfile data into TR/onset time.
	onsets = []
	for t,d in zip(trials,durations):
		onsets.extend([t,] + [0,]*(d-1))
			## if t = 2 and d = 3 then [t,] + [0,]*(d-1)
			## should give the list: [2 0 0]


	return onsets,durations
