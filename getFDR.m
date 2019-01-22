function getFDR()
	
	figPos= [150 150 2000 600];
	figPos=defineWindowSize(figPos);
	
	figStart = figure('Name','Select Kinship','NumberTitle','off',...
		'units','pixels',...
		'OuterPosition',figPos,...
		'MenuBar','none')%,...
		%'Resize','off');
	
	Files=matfile('matlab.mat');
	D = whos(Files);D={D.name};
	
	cols={1:8;1:22;1:27;1:32;1:35};

	pedigree ={'AVvsUnr','FCvsUnr','FSvsHS','FSvsUn','HCvsUnr','HS2vsUn'};

	
	txtTitle = annotation(figStart,'textbox','String','Please Select a Kinship to Analyse...', ...
		'FontSize',20,...
		'units','normalized',...
		'Position', [0.1 0.7 0.9 0.3],...
		'HorizontalAlignment', 'center',...
		'VerticalAlignment', 'middle',...
		'Interpreter','Tex',...
		'LineStyle','none');
	
	
	for j = 1:6
		B(j)=uicontrol(figStart, 'Style', 'pushbutton', ...
			'String', pedigree{j},...
			'units','normalized',...
			'Position', [ 0.4/7 + (0.4/7 + 0.1)*(j-1) 0.2 0.1 0.2],...
			'Callback', @(hObject,event) NewQuestion2(j)); 
	end
	
	function NewQuestion2(j)
		setappdata(figStart,'pedigree',pedigree{j})
		WHOM=split(D(contains(D,pedigree{j})),'_');
		WHOM=unique(WHOM(:,:,5));
		WHOM=split(WHOM,'.');
		WHOM=unique(WHOM(:,:,1));
		for j = 1:6
			set(B(j),'Visible','off')
		end
		setappdata(figStart, 'WHOM',WHOM)
		for i = 1:numel(WHOM)
			W(i)=uicontrol(figStart, 'Style', 'pushbutton', 'String', WHOM{i},...
				'Position', [100*i 50 85 100],...
				'Callback', @(hObject,event) done(i)); 
		end
	end

	function done(i)
		d=split(D(contains(D,pedigree{j})),'_');d=unique(d(:,:,2));
		dataOrigin1=d{1};
		dataOrigin2=d{2};
		pedigree=getappdata(figStart,'pedigree');
		WHOM=getappdata(figStart,'WHOM');
		whom=WHOM(i);
		FDR(pedigree,whom,dataOrigin1,dataOrigin2)
	
	end
	
% 	d=split(D(contains(D,pedigree{j})),'_');d=unique(d(:,:,2));
% 	dataOrigin1=d{1};
% 	dataOrigin2=d{2};
end

