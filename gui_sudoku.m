function varargout = gui_sudoku(varargin)
% GUI_SUDOKU M-file for gui_sudoku.fig
%      GUI_SUDOKU, by itself, creates a new GUI_SUDOKU or raises the existing
%      singleton*.
%
%      H = GUI_SUDOKU returns the handle to a new GUI_SUDOKU or the handle to
%      the existing singleton*.
%
%      GUI_SUDOKU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SUDOKU.M with the given input arguments.
%
%      GUI_SUDOKU('Property','Value',...) creates a new GUI_SUDOKU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_sudoku_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_sudoku_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_sudoku

% Last Modified by GUIDE v2.5 22-Jul-2012 16:33:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_sudoku_OpeningFcn, ...
    'gui_OutputFcn',  @gui_sudoku_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_sudoku is made visible.
function gui_sudoku_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_sudoku (see VARARGIN)

% Choose default command line output for gui_sudoku
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_sudoku wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_sudoku_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
set([handles.pushbutton2 handles.uitable1],'Enable','off')
data=guidata(hObject);
statusbar(handles.text1,'Calculations started',' ')
matrix=combinedsudoku(data.tablematrix,hObject,handles);%,hObject
statusbar(handles.text1,'Calculations ended',' ')
set(handles.uitable1,'Data',matrix)
data=guidata(hObject);
data.tablematrix=[];
guidata(hObject,data)
statusbar(handles.text1,'Enter new values',' ')
set([handles.pushbutton2 handles.uitable1],'Enable','on')

% data = get(tablehandle,'Data')
% data(event.indices[1],event.indices[2]) = pi();
% set(tablehandle,'Data',data);
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
data=guidata(hObject);%get(handles.uitable1,'Data')
%get(handles.uitable1,'Data') could be used directly to pushbotton1callback matrix
newdata=str2double(char(eventdata.NewData));
if ~isnan(eventdata.NewData)&&sum(eventdata.NewData==1:9)
    newdata=eventdata.NewData;
end
if ~isnan(newdata)&&sum(newdata==1:9)
    matrixsize=size(data.tablematrix);matrixsize=matrixsize(1);
    for matrixindex=1:matrixsize%check cell overwrite
        if min(data.tablematrix(matrixindex,[1 2])==[eventdata.Indices(1) eventdata.Indices(2)])
            data.tablematrix(matrixindex,:)=[];
            break
        end
    end
    data.tablematrix(end+1,:)=[eventdata.Indices(1) eventdata.Indices(2) newdata];
    guidata(hObject,data)
    statusbar(handles.text1,['row:' num2str(eventdata.Indices(1)) ...
        ' col:' num2str(eventdata.Indices(2)) ' ' num2str(newdata)],' ')
else
    statusbar(handles.text1,'incorrect input:Re-enter value',' ')
    matrix=get(handles.uitable1,'Data');
    matrix(eventdata.Indices(1),eventdata.Indices(2))={0};
    set(handles.uitable1,'Data',matrix)
end
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
data=guidata(hObject);
data.tablematrix=[];
guidata(hObject,data)
set(hObject,'Data',cell(9,9))
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
data=guidata(hObject);
data.tablematrix=[];
guidata(hObject,data)
set(handles.uitable1,'Data',cell(9,9))
statusbar(handles.text1,'Enter new values',' ')

% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function matrix=combinedsudoku(given,hObject,handles)
matrixnoterr=humansudoku(given);
matrix=cell(9,9);
if matrixnoterr.error
    data=guidata(hObject);
    data.tablematrix=[];
    guidata(hObject,data)
    statusbar(handles.text1,'Invalid input: cannot be solved',' ')
    return
end
matrixnot=matrixnoterr.matrixnot;
rows=factorial(9);
raw=zeros(rows,9);
rawcount=1;
statusbar(handles.text1,'In loop1',' ')
%the following loop was supposed to replace the next loop
% i=zeros(1,10);index=1;
% while rawcount~=rows+1
%     if i(index)<9 && index~=10
%         i(index)=i(index)+1;
%     end
%     if ~min(i(index)==i(1:index-1))
%         index=index+1;
%         continue
%     end
%     if index==9
%         if ~min(i(index)==i(1:index-1))
%             raw(rawcount,:)=i(1:9);
%             rawcount=rawcount+1;
%         else
%             index=1;
%         end
%     end
% end
for i1=1:9
    for  i2=1:9
        if i1==i2
            continue
        end
        for  i3=1:9
            if (i3==i2 || i3==i1)
                continue
            end
            for  i4=1:9
                if (i4==i3 || i4==i2 || i4==i1)
                    continue
                end
                for  i5=1:9
                    if (i5==i4 || i5==i3 ||i5==i2 ||i5==i1)
                        continue
                    end
                    for  i6=1:9
                        if (i6==i5 || i6==i4 || i6==i3 || i6==i2 || i6==i1)
                            continue
                        end
                        for  i7=1:9
                            if (i7==i6 || i7==i5 || i7==i4 || i7==i3 || i7==i2 || i7==i1)
                                continue
                            end
                            for  i8=1:9
                                if (i8==i7 || i8==i6 || i8==i7 || i8==i6 || i8==i5 || i8==i4 || i8==i3 || i8==i2 || i8==i1)
                                    continue
                                end
                                for  i9=1:9
                                    if (i9==i8 || i9==i7 || i9==i6 || i9==i5 || i9==i4 || i9==i3 || i9==i2 || i9==i1)
                                        continue
                                    end
                                    raw(rawcount,1)=i1;
                                    raw(rawcount,2)=i2;
                                    raw(rawcount,3)=i3;
                                    raw(rawcount,4)=i4;
                                    raw(rawcount,5)=i5;
                                    raw(rawcount,6)=i6;
                                    raw(rawcount,7)=i7;
                                    raw(rawcount,8)=i8;
                                    raw(rawcount,9)=i9;
                                    rawcount=rawcount+1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
statusbar(handles.text1,'main calculation status:','replace')
statusbar(handles.text1,'xx',' ')%to be overwriten/replaced by the next statusbar command
index=zeros(1,9);
for index1=1:rows
    index(1)=index1;
    if ~rem(index1-1,4000)
        statusbar(handles.text1,percenter(1,rows,index),'replace')
    end
    if humannotchecked(index,raw,matrixnot,1)
        continue
    end
    ii3=1;
    for index2=1:rows
        index(2)=index2;
        if ~rem(index2-1,4000)
            statusbar(handles.text1,percenter(2,rows,index),'replace')
        end
        if humannotchecked(index,raw,matrixnot,2)
            continue
        end
        if(compar(index,raw,2))
            continue
        end
        if(ii3)
            index3i=index2;
            ii3=0;
        end
        if comp2(index,raw,2)
            continue
        end
        ii4=1;
        for index3=index3i:rows
            index(3)=index3;
            if ~rem(index3-1,4000)
                statusbar(handles.text1,percenter(3,rows,index),'replace')
            end
            if humannotchecked(index,raw,matrixnot,3)
                continue
            end
            if compar(index,raw,3)
                continue
            end
            if(ii4)
                index4i=index3;
                ii4=0;
            end
            if comp3(index,raw,3)
                continue
            end
            for index4=index4i:rows
                index(4)=index4;
                if ~rem(index4-1,4000)
                    statusbar(handles.text1,percenter(4,rows,index),'replace')
                end
                if humannotchecked(index,raw,matrixnot,4)
                    continue
                end
                if compar(index,raw,4)
                    continue
                end
                for index5=index4+1:rows
                    index(5)=index5;
                    if ~rem(index5-1,4000)
                        statusbar(handles.text1,percenter(5,rows,index),'replace')
                    end
                    if humannotchecked(index,raw,matrixnot,5)
                        continue
                    end
                    if compar(index,raw,5)
                        continue
                    end
                    if comp2(index,raw,5)
                        continue
                    end
                    statusbar(handles.text1,'mapper calculation started','replace')
                    mapper=loop6789(index(1:5),raw,rows);
                    statusbar(handles.text1,'mapper calculation ended','replace')
                    lraw67=length(mapper);
                    for index6=1:lraw67
                        index(6)=mapper(index6);
                        if ~rem(index6-1,4000)
                            statusbar(handles.text1,percenter(6,rows,index),'replace')
                        end
                        if humannotchecked(index,raw,matrixnot,6)
                            continue
                        end
                        if compar(index,raw,6)
                            continue
                        end
                        if comp3(index,raw,6)
                            continue
                        end
                        for index7=1:lraw67
                            index(7)=mapper(index7);
                            if ~rem(index7-1,4000)
                                statusbar(handles.text1,percenter(7,rows,index),'replace')
                            end
                            if humannotchecked(index,raw,matrixnot,7)
                                continue
                            end
                            if compar(index,raw,7)
                                continue
                            end
                            for index8=1:lraw67
                                index(8)=mapper(index8);
                                if ~rem(index8-1,4000)
                                    statusbar(handles.text1,percenter(8,rows,index),'replace')
                                end
                                if humannotchecked(index,raw,matrixnot,8)
                                    continue
                                end
                                if compar(index,raw,8)
                                    continue
                                end
                                if comp2(index,raw,8)
                                    continue
                                end
                                for index9=1:lraw67
                                    index(9)=mapper(index9);
                                    if ~rem(index9-1,4000)
                                        statusbar(handles.text1,percenter(9,rows,index),'replace')
                                    end
                                    if humannotchecked(index,raw,matrixnot,9)
                                        continue
                                    end
                                    if compar(index,raw,9)
                                        continue
                                    end
                                    matrix=num2cell(raw(index(1:9),:));
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
statusbar(handles.text1,'We couldnot find any solutions',' ')

function comp=compar(index,raw,max)
comp=0;
for col=1:9
    for id=1:max-1
        if(raw(index(max),col)==raw(index(id),col))
            comp=1;
            return
        end
    end
end

function a=comp3(index,raw,max)
a=0;
gh=raw(index(max-2:max),:);
for i=[0 3 6]
    if(gh(1,1+i)==gh(3,2+i)||gh(1,1+i)==gh(3,3+i)||gh(1,2+i)==gh(3,1+i)||gh(1,2+i)==gh(3,3+i)||gh(1,3+i)==gh(3,1+i)||gh(1,3+i)==gh(3,2+i)||gh(2,1+i)==gh(3,2+i)||gh(2,1+i)==gh(3,3+i)||gh(2,2+i)==gh(3,1+i)||gh(2,2+i)==gh(3,3+i)||gh(2,3+i)==gh(3,1+i)||gh(2,3+i)==gh(3,2+i))
        a=1;
        return
    end
end

function a=comp2(index,raw,max)
a=0;
gh=raw(index([max-1 max]),:);
for i=[0 3 6]
    if(gh(1,1+i)==gh(2,2+i)||gh(1,1+i)==gh(2,3+i)||gh(1,2+i)==gh(2,1+i)||gh(1,2+i)==gh(2,3+i)||gh(1,3+i)==gh(2,1+i)||gh(1,3+i)==gh(2,2+i))
        a=1;
        return
    end
end

function notwork=humannotchecked(index,raw,matrixnot,roww)
notwork=0;indexx=index(roww);
for coll=1:9
    indd=1;
    while(indd~=9&&matrixnot(roww,coll,indd))
        if matrixnot(roww,coll,indd)==raw(indexx,coll)
            notwork=1;
            return
        end
        indd=indd+1;
    end
end

function matrixnoterr=humansudoku(given)
%given=[a1 b1 c1;a2 b2 c2;a3 b3 c3; . . .],a-raw,b-col,c-value
matrixnot=zeros(9,9,9);
givens=size(given);givens=givens(1);
for giv=1:givens
    raw=given(giv,1);
    col=given(giv,2);
    val=given(giv,3);
    ind1=1;
    for ind=1:9%for the cells whose values are givens
        if ind~=val
            matrixnot(raw,col,ind1)=ind;
            ind1=ind1+1;
        end
    end
    if raw==1||raw==2||raw==3
        cornerraw=1;
    elseif raw==4||raw==5||raw==6
        cornerraw=4;
    elseif raw==7||raw==8||raw==9
        cornerraw=7;
    end
    if col==1||col==2||col==3
        cornercol=1;
    elseif col==4||col==5||col==6
        cornercol=4;
    elseif col==7||col==8||col==9
        cornercol=7;
    end
    for coll=1:9%for the row of the given cell
        if coll==col
            continue
        end
        m=sortmatrixnot(matrixnot,raw,coll);
        index=m.index;matrixnot=m.matrixnot;
        if m.err
            matrixnoterr.error=1;return
        end
        matrixnot(raw,coll,index)=val;
    end
    for roww=1:9
        if roww==raw
            continue
        end
        m=sortmatrixnot(matrixnot,roww,col);
        index=m.index;matrixnot=m.matrixnot;
        if m.err
            matrixnoterr.error=1;return
        end
        matrixnot(roww,col,index)=val;
    end
    for roww=cornerraw:cornerraw+2
        for coll=cornercol:cornercol+2
            if coll==col&&roww==raw
                continue
            end
            m=sortmatrixnot(matrixnot,roww,coll);
            index=m.index;matrixnot=m.matrixnot;
            if m.err
                matrixnoterr.error=1;return
            end
            matrixnot(roww,coll,index)=val;
        end
    end
    for r=1:9
        for c=1:9
            m=sortmatrixnot(matrixnot,r,c);matrixnot=m.matrixnot;
            if m.err
                matrixnoterr.error=1;return
            end
        end
    end
end
matrixnoterr.matrixnot=matrixnot;
matrixnoterr.error=0;

function sorted=sortmatrixnot(mn,raw,col)
matrixnot=mn;
intermediate=unique(matrixnot(raw,col,:));
if ~intermediate(1)
    intermediate(1)=[];
end
inter=length(intermediate);
for ww=1:inter
    matrixnot(raw,col,ww)=intermediate(ww);
end
for ww=inter+1:9
    matrixnot(raw,col,ww)=0;
end
matrixnot(raw,col,:)=sort(matrixnot(raw,col,:),'descend');
sorted.err=0;
sorted.index=inter+1;
if inter==9
    sorted.err=1;
    sorted.index=8;
end
sorted.matrixnot=matrixnot;

function out=percenter(num,rows,index)
out=0;
for ind=1:num
    out=out+index(ind)/rows^ind;
end
out=[num2str(100*out,16) ' %'];

function statusbar(text1handle,stringtext,stringchoice)
str=cellstr(get(text1handle,'String'));
if strcmp(stringchoice,'replace')
    str(end)=[];
elseif length(str)==7
    str(1)=[];
end
str(end+1)={stringtext};
set(text1handle,'String',str)
drawnow expose

function mapper=loop6789(index,raww,rlength)
mapper=zeros(1,4^8);
rawindex=0;
for index1=1:rlength
    no=0;
    for col=1:9
        for nots=raww(index(:),col)'
            if raww(index1,col)==nots
                no=1;
                break
            end
        end
        if no
            break
        end
    end
    if ~no
        rawindex=rawindex+1;
        mapper(rawindex)=index1;
    end
end
mapper(rawindex+1:end)=[];