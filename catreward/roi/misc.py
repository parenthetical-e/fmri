""" Various helper functions, mostly having to do with data. """


def subdir(num):
    """ Return the directory name, given a subject <num>ber, 
    e.g. 101. """
    
    # Create the map,
    # num -> dir_name
    num_dir_map = {
    101:'101M80351917',
    102:'102M80359344',
    103:'103M80358136',
    104:'104M80368842',
    105:'105M80350861',
    106:'106M80381623',
    108:'108M80357327',
    109:'109M80328568',
    111:'111M80343408',
    112:'112M80364602',
    113:'113M80380288',
    114:'114M80371580',
    115:'115M80364638',
    116:'116M80363397',
    117:'117M80354305',
    118:'118M80330684'}
    
    return num_dir_map[num]



