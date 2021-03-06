function g_2skeleton(fileName, FA_fileName, mean_FA_fileName, dst_fileName, threshold, JobName, ResultPath)
%
%__________________________________________________________________________
% SUMMARY OF G_2SKELETON
% 
% This is to project the values to the skeleton during TBSS procedure
%
% SYNTAX:
% G_2SKELETON( FILENAME, FA_FILENAME, MEAN_FA_FILENAME, DST_FILENAME, THRESHOLD, JOBNAME )
%__________________________________________________________________________
% INPUTS:
%
% FILENAME
%       (string) the path of the file to be projected to the skeleton
%
% FA_FILENAME
%       (string) the path of FA file of 1*1*1
%
% MEAN_FA_FILENAME
%       (string) the average FA of all the subjects
%
% DST_FILENAME
%       (string) the distance map ( the value of the voxel is the distance 
%                from the centor of voxel to the skeleton nearest to it )
%        
% THRESHOLD
%       (float)(float) threshold for TBSS, always be 0.2
%       Please reference:http://www.fmrib.ox.ac.uk/fsl/tbss/index.html 
%
% JOBNAME
%        (string) the name of the job which call the command this time.It
%        is determined in the function g_dti_pipeline.
%        If you use this function alone, this parameter is not needed.
%__________________________________________________________________________
% OUTPUTS:
%
%__________________________________________________________________________
% USAGE:
%
%        1) g_2skeleton(fileName, FA_fileName, mean_FA_fileName,dst_fileName, threshold)
%        2) g_2skeleton(fileName, FA_fileName, mean_FA_fileName, dst_fileName, threshold, JOBNAME)
%__________________________________________________________________________
% COMMENTS:
% 
% My work is based on the psom refered to http://code.google.com/p/psom/.
% It has an attractive feature: if the job breaks and you restart, it will
% excute the job from the break point rather than from the start.
% The output files jobs will produce are specifiled in the file named 
% [JOBNAME '_FileOut.m']
%
% Copyright (c) Gaolang Gong, Zaixu Cui, State Key Laboratory of Cognitive
% Neuroscience and Learning, Beijing Normal University, 2011.
% Maintainer: zaixucui@gmail.com
% See licensing information in the code
% keywords: tbss_skeleton

% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documation files, to deal in the
% Software without restriction, including without limitation the rights to
% use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.

if nargin <=6
    if strcmp(fileName(end-6:end), '.nii.gz')
       skeletonised_fileName=cat(2,fileName(1:end-7),'_skeletonised');
    elseif strcmp(fileName(end-3:end), '.nii')
       skeletonised_fileName=cat(2,fileName(1:end-4),'_skeletonised');
    else
       error('not a NIFTI file')
    end
else
    if strcmp(fileName(end-6:end), '.nii.gz')
        [a, FileNameSuffixWithNII, c] = fileparts(fileName);
        skeletonised_fileName=cat(2,ResultPath,FileNameSuffixWithNII(1:end-4),'_skeletonised');
    elseif strcmp(fileName(end-3:end), '.nii')
        [a, FileNameSuffix, c] = fileparts(fileName);
        skeletonised_fileName=cat(2,ResultPath,FileNameSuffix,'_skeletonised');
    else
        error('not a NIFTI file');
    end
end
disp('projecting values to skeleton...');
cmd=cat(2, '$FSLDIR/bin/tbss_skeleton -i ', mean_FA_fileName, ' -p ', num2str(threshold), ' ',  dst_fileName,...
           ' $FSLDIR/data/standard/LowerCingulum_1mm ', FA_fileName, ' ', skeletonised_fileName, ' -a ', fileName);
system(cmd);

if nargin == 6
    [a,b,c] = fileparts(fileName);
    [SubjectFolder,b,c] = fileparts(a);
    cmd = ['touch ' SubjectFolder filesep 'tmp' filesep 'OutputDone' filesep JobName '.done '];
    system(cmd);
end