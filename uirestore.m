function [status,status_str] = uirestore(varargin)

%UIRESTORE - Restores GUI object last state as was saved by last UIREMEMBER of this object.
%[STATUS,STATUS_STR] = UIRESTORE
%[STATUS,STATUS_STR] = UIRESTORE(H)
%[STATUS,STATUS_STR] = UIRESTORE(...,OPTS)
%H can be an array of handles of the objects you want to restore.
%Default H is gcbo.
%OPTS - Options structure with the follwoing fields :
%filename - Name of the mat file that contains the object last state.
%           Default name : 'last_state.mat'
%prop -     Object properties to restore
%           prop can be a string for one propery or cell array {'prop1', 'prop2', ...} for
%           multiple properties.
%The OPTS input support only single value H or no H (gcbo).
%
%STSUTS is 1 for restore sucess and 0 for restore failure.
%STATUS_STR is the failure description or 'success' string in case of success.
%in case of multiple H STATUS is array and STATUS_STR is cell array.
%
%Common Use : Put uirestore on the required object CreateFcn in order to
%open the GUI with the last state.
%
%See also UIREMEMBER
%
%Ver1.0 by Lior Cohen (lior_chn@yahoo.com), 07/08/2009


h=gcbo; %default object handle
mem_file='last_state.mat';  %Default memory file name
prop=[];

if nargin==0
    %default values
elseif nargin==1 && isnumeric(varargin{1})
    h=varargin{1};
elseif nargin==1 && isstruct(varargin{1})
    opts=varargin{1};
elseif nargin==2 && isnumeric(varargin{1})&& isstruct(varargin{2})
    h=varargin{1};
    opts=varargin{2};
    if length(h)~=1, error('Multilple H are not supported when using OPTS options structure'); end
else
    error('invalid input');
end
%override the default values by the user opions values.
if exist('opts','var')
    if isfield(opts,'filename'), mem_file=opts.filename;    end
    if isfield(opts,'prop'),     prop = opts.prop; end
end

for i=1:length(h)
    %
    %In case for some reason the handle is invlaid.
    if ~ishandle(h(i))
        status_str{i}='invalid object handle';
        status(i)=0;
        return;
    end
    %
    %In case for some reason the file does not exists.
    if ~exist(mem_file,'file')
        status_str{i}='file was not found';
        status(i)=0;
        continue;
    end
    %
    tmp=load(mem_file);
    %
    %In case for some reason the file sturcuctue is invlaid.
    if ~isfield(tmp,'sav')
        status_str{i}='No sav field exists';
        status(i)=0;
        continue;
    end
    
    sav=tmp.sav;
    %
    tag=get(h(i),'tag');
    
    if ~isfield(sav,tag)
        status_str{i}='Object information is not in file';
        status(i)=0;
        continue;
    end
    %
    s=sav.(tag);
    
    if isempty(prop) %Restore all the file properties
        set(h(i),s);
        status(i)=1;
        status_str{i}='Success';

    else
        f=fieldnames(s);
        
        if ~all(ismember(prop,f))   %not all the requested prop are in the file
            status_str{i}='Some requested properties to restore are not in the file';
            status(i)=0;
            continue;
        end
              
        s1=rmfield(s,f(~ismember(f,prop)));
        set(h(i),s1);
        status(i)=1;
        status_str{i}='Success';
    end    
end
