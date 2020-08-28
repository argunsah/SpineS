function uiremember(varargin)


%UIREMEMBER - Remembers GUI object state. Used to remeber object last state
%in gui exit, in order to restore (using UIRESTORE) it on gui restart.
%
%UIREMEMBER
%UIREMEMBER(H)
%UIREMEMBER(...,OPTS)
%H can be an array of handles of the objects you want to restore.
%Default H is gcbo.
%OPTS - Options structure with the follwoing fields :
%filename - Name of the mat file that contains the object last state.
%           Default name : 'last_state.mat'
%prop -     Object properties to restore
%           prop can be a string for one propery or cell array {'prop1', 'prop2', ...} for
%           multiple properties.
%           Default objects properties are -
%               figure = {'position'};
%               checkbox = {'value'};
%               edit={'string'};
%               slider={'value','max','min'};
%               popupmenu={'value','string'};
%               checkbox={'value'};
%               radiobutton={'value'};
%               listbox={'value'};
%               togglebutton={'value'};

%The OPTS input support only single value H or no H (gcbo).

%Common Use : Put uiremember on the required object DeleteFcn in order to
%remember its last state.
%
%See also UIRESTORE
%
%Ver1.0 by Lior Cohen (lior_chn@yahoo.com), 07/08/2009

%Default properties
def.figure = {'position'};
def.uicontrol.checkbox = {'value'};
def.uicontrol.edit={'string'};
def.uicontrol.slider={'value','max','min'};
def.uicontrol.popupmenu={'value','string'};
def.uicontrol.checkbox={'value'};
def.uicontrol.radiobutton={'value'};
def.uicontrol.listbox={'value'};
def.uicontrol.togglebutton={'value'};
%
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
%

for i=1:length(h)
    tag=get(h(i),'tag');
    if isempty(prop)%in case there are no user properties input, use the fefaults.
        
        type = get(h(i),'type');
        if strcmp(type,'uicontrol')
            style=get(h(i),'style');
            if isfield(def,'uicontrol')&& isfield(def.uicontrol,style)
                prop=def.uicontrol.(style);
            else
                warning('No default values for the %s object. Please use OPTS.', tag);
                continue;
            end
        else
            if isfield(def,type)
                prop=def.(type);
            else
                warning('No default values for the %s object. Please use OPTS.', tag);
                continue;
            end
        end
        
    end
    
    
    %
    if ~iscell(prop), prop=cell(prop); end
    %
    
    for k=1:length(prop)
        val=get(h(i),prop{k});
        s.(prop{k})=val;
    end
    %
    if exist(mem_file,'file')
        tmp=load(mem_file);
        sav=tmp.sav;
    end
    
    sav.(tag)=s;
    save(mem_file,'sav','-mat');
    
end