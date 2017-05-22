function IDXwithConsistentLabels  = UnitsSameCluster(IDX,UnitsSameGroup)
%UnitsSameCluster enables to control the labels of the clusters which contain predefined units
%
%<a href="matlab: docsearchFS('UnitsSameCluster')">Link to the help function</a>
%
%
%  Required input arguments:
%
%         IDX   : Assignment of units to groups for different values of c
%                   (restriction factor) and k (number of groups. Cell.
%                   Cell of size length(kk)-times length(cc), where kk is
%                   the vector which contains the number of groups which
%                   have been considered and cc is the vector which
%                   contains the values of the restriction factor.  Each
%                   element of the cell is a vector of length n containinig
%                   the assignment number of each unit using a particular
%                   classification model.
%                 Data Types -  cell
%
%   UnitsSameGroup :  list of the units which must (whenever possible)
%                   have the same label. Numeric vector.  For example if
%                   UnitsSameGroup=[20 26], means that group which contains
%                   unit 20 is always labelled with number 1. Similarly,
%                   the group which contains unit 26 is always labelled
%                   with number 2, (unless it is found that unit 26 already
%                   belongs to group 1). In general, group which contains
%                   unit UnitsSameGroup(r) where r=2, ...length(kk)-1 is
%                   labelled with number r (unless it is found that unit
%                   UnitsSameGroup(r) has already been assigned to groups
%                   1, 2, ..., r-1).
%
%  Optional input arguments:
%
%  Output:
%
%   IDXwithConsistentLabels = cell with the same size as input cell IDX and with
%                   the same meaning of input cell IDX but with consistent
%                   labels. Cell. Group which contains unit
%                   UnitsSameGroup(1)  is labelled with number 1. In
%                   general. Group which contains UnitsSameGroup(r) where
%                   r=2, ...length(kk)-1 is labelled with number r (unless
%                   it is found that unit UnitsSameGroup(r) has already
%                   been assigned to groups 1, 2, ..., r-1).
%
%
%
%
% See also tclustIC, tclustICplot
%
% References:
%
% A. Cerioli, L.A. Garcia-Escudero, A. Mayo-Iscar and M. Riani (2016).
% Finding the Number of Groups in Model-Based Clustering via Constrained
% Likelihoods, submitted
%
%
% Copyright 2008-2016.
% Written by FSDA team
%
%
%
%<a href="matlab: docsearchFS('UnitsSameCluster')">Link to the help function</a>
% Last modified 31-05-2016

% Examples:
%{
    % Start with labelling produced by tclustIC and produce consist labels.
    Y=load('geyser2.txt');
    % A small number of subsamples just to show whow the procedure works.
    nsamp=10;
    out=tclustIC(Y,'cleanpool',false,'plots',1,'nsamp',10,'whichIC','CLACLA')
    % Make sure that units [23 54] are whenever possible respectively in
    % cluster 1 and 2
    UnitsSameGroup=[23 54];
    IDXCLAnew=UnitsSameCluster(out.IDXCLA,UnitsSameGroup);
%}



%% Beginning of code


if ~iscell(IDX)
    error('FSDA:UnitsSameCluster:WrongInput','Input must be a cell.');
end

[kk,cc]=size(IDX);

% Initialize IDXwithConsistentLabels with IDX
IDXwithConsistentLabels=IDX;

for i=1:kk
    for j=1:cc
        
        idx=IDX{i,j};
        uniqvar=unique(idx);
        % Remove values of uniqvar which are equal to 0 because they denote
        % unassigned units whose label does not have to change.
        uniqvar(uniqvar==0)=[];
        
        % Preliminary operation: make sure that the number contained inside
        % idx go from 1 to length(uniqvar).
        missingnumb=setdiff(1:length(uniqvar),uniqvar);
        if ~isempty(missingnumb)
            for ii=1:length(missingnumb)
                idx(idx==max(idx))=missingnumb(ii);
            end
        end
        
        
        if length(uniqvar)>1
            mineqv=min([length(UnitsSameGroup) length(uniqvar)-1]);
            for jj=1:mineqv % length(uniqvar)-1
                % Find old labels for group which contains  UnitsSameGroup(jj)
                OldLabel=idx(UnitsSameGroup(jj));
                
                idxtmp=idx;
                if  OldLabel > jj
                    
                    
                    
                    % The new label for units whose old label was OldLabel
                    % becomes jj
                    idx(idxtmp==OldLabel)=jj;
                    
                    % The new label for units whose previous label was jj
                    % becomes OldLabel
                    idx(idxtmp==jj)=OldLabel;
                end
            end
        end
        
        IDXwithConsistentLabels{i,j}=idx;
        
    end
end
end

%FScategory:UTISTAT