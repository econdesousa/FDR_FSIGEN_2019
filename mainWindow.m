function mainWindow()
	
	figPos= [550 400 700 300];
	figPos=defineWindowSize(figPos);
	
	figStart = figure('Name','Select Kinship','NumberTitle','off',...
		'units','pixels',...
		'OuterPosition',figPos,...
		'MenuBar','none');
	
	Files=matfile('matlab.mat');
	D = whos(Files);D={D.name};
	MarkerNames=Files.header;
	D(strcmp(D,'header'))=[];
	
	pedigree ={'AVvsUnr','FCvsUnr','FSvsHS','FSvsUn','HCvsUnr','HS2vsUn'};
	pedigree2disp = {'AV vs Unr','FC vs Unr','FS vs HS','FS vs Unr','HC vs Unr','HS vs Unr'};
	
	txtTitle = annotation(figStart,'textbox','String','Please Select a Kinship to Analyse...', ...
		'FontSize',20,...
		'units','normalized',...
		'Position', [0 0.5 1 0.3],...
		'HorizontalAlignment', 'center',...
		'VerticalAlignment', 'middle',...
		'Interpreter','Tex',...
		'LineStyle','none');
	
	
	for j = 1:6
		B(j)=uicontrol(figStart, 'Style', 'pushbutton', ...
			'String', pedigree2disp{j},...
			'units','normalized',...
			'Position', [ (0.05 + (0.05 + (1-7*0.05)/6)*(j-1)) 0.2 (1-7*0.05)/6 0.2],...
			'Callback', @(hObject,event) NewQuestion2(j,pedigree,pedigree2disp));  %#ok<*AGROW>
	end
	B(1).Position=[ (0.05 + (0.05 + (1-7*0.05)/6)*(4-1)) 0.2 (1-7*0.05)/6 0.2];
	B(2).Position=[ (0.05 + (0.05 + (1-7*0.05)/6)*(5-1)) 0.2 (1-7*0.05)/6 0.2];
	B(3).Position=[ (0.05 + (0.05 + (1-7*0.05)/6)*(2-1)) 0.2 (1-7*0.05)/6 0.2];
	B(4).Position=[ (0.05 + (0.05 + (1-7*0.05)/6)*(1-1)) 0.2 (1-7*0.05)/6 0.2];
	B(5).Position=[ (0.05 + (0.05 + (1-7*0.05)/6)*(6-1)) 0.2 (1-7*0.05)/6 0.2];
	B(6).Position=[ (0.05 + (0.05 + (1-7*0.05)/6)*(3-1)) 0.2 (1-7*0.05)/6 0.2];
	
	
	function NewQuestion2(j,pedigree,pedigree2disp)
		
		txtTitle.String='Please Select Persons to Consider...';
		figStart.Name=['Select Persons     kinship: ' pedigree2disp{j}];
		setappdata(figStart,'pedigree',pedigree{j})
		WHOM=split(D(contains(D,pedigree{j})),'_');
		WHOM=unique(WHOM(:,:,5));
		WHOM=split(WHOM,'.');
		WHOM=unique(WHOM(:,:,1));
		for j = 1:6
			set(B(j),'Visible','off')
		end
		setappdata(figStart, 'WHOM',WHOM);
		setappdata(figStart, 'header',pedigree2disp{j});
		for i = 1:numel(WHOM)
			x=(1-(numel(WHOM)+1)*0.05)/(numel(WHOM));
			uicontrol(figStart, 'Style', 'pushbutton',...
				'String', WHOM{i},...
				'units','normalized',...
				'Position', [ (0.05 + (0.05 + x)*(i-1)) 0.2 x 0.2],...
				'Callback', @(hObject,event) done(i));  
		end
		uicontrol(figStart, 'Style', 'pushbutton', ...
			'String', 'Go Back',...
			'units','normalized',...
			'Position', [ .9 .9 .1 .1],...
			'Callback',  @(hObject,event) exitandrestart);  %#ok<*AGROW>

	end
	function exitandrestart()
		close all;
		mainWindow();
	end

	function done(i)
		pedigree=getappdata(figStart,'pedigree');
		WHOM=getappdata(figStart,'WHOM');
		whom=WHOM(i);
		
		figStart.delete
		D=D(contains(D,pedigree));
		D1=split(D','_');
		D1=D1(:,5);
		D=D(strcmp(D1,whom));
		if numel(D)~=2
			assignin('base','D3',D);
			error('???');
		end
		dataH1=Files.(D{1});		
		dataH2=Files.(D{2});


	end
	waitfor(figStart,'delete');
	assignin('caller','dataH1',dataH1);
	assignin('caller','dataH2',dataH2);
	assignin('caller','D',D);
	assignin('caller','figPos',figPos);
	assignin('caller','Files',Files);
	assignin('caller','MarkerNames',MarkerNames);
	



end

