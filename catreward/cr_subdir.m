function [dir_name] = cr_subdir(num),
% Return the name of the fMRI data directory given the subject number, <num>.
%
% [dir_name] = cr_subdir(num),

	switch num
	case 101
		dir_name = '101M80351917';
    case 102
		dir_name = '102M80359344';
	case 103
		dir_name = '103M80358136';
	case 104
		dir_name = '104M80368842';
	case 105
		dir_name = '105M80350861';
	case 106
		dir_name = '106M80381623';
	case 108
		dir_name = '108M80357327';
	case 109
		dir_name = '109M80328568';
	case 111
		dir_name = '111M80343408';
	case 112
		dir_name = '112M80364602';
	case 113
		dir_name = '113M80380288';
	case 114
		dir_name = '114M80371580';
	case 115
		dir_name = '115M80364638';
	case 116
		dir_name = '116M80363397';
	case 117
		dir_name = '117M80354305';
	case 118
		dir_name = '118M80330684';
    otherwise
        error('Invalid <num> code.');
	end
end
