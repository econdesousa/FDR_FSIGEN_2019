function [figPos,numMarkers,newFig]=selectMarkers(figPos)
	
	if nargin<1
		figPos= [550 400 700 300];
	end
	figPos=defineWindowSize(figPos);
	
	numMarkers=1;
	newFig=figure('units','normalized','Visible','off');
	
	figStart = figure('Name','Select Markers','NumberTitle','off',...
		'units','pixels',...
		'OuterPosition',figPos,...
		'MenuBar','none');

	txtTitle = annotation(figStart,'textbox','String','Please Select One Option...', ...
		'FontSize',20,...
		'units','normalized',...
		'Position', [0 0.7 1 0.25],...
		'HorizontalAlignment', 'center',...
		'VerticalAlignment', 'middle',...
		'Interpreter','Tex',...
		'LineStyle','none'); %#ok<*NASGU>
	
	
	GroupButton = uibuttongroup('Parent', figStart,'Visible','on',...
		'Units','normalized',...
		'Position',[0.05 0.3 .9 .3 ],...
		'SelectionChangedFcn',@bselection);
	
	Options={'8 Markers' '17 Markers' '22 Markers' '27 Markers' '32 Markers'...
		'35 Markers' '<html>Customized<br>Set of Markers</html>'};
	setappdata(figStart,'method',Options{1});

		
	% Create radio buttons in the button group.
	radio(1) = uicontrol('Parent', GroupButton,'Style','radiobutton',...
		'String',Options{1},...
		'Units','normalized',...
		'Position',[0.05 .55 .15 .4],...
		'HandleVisibility','on');

	radio(2) = uicontrol('Parent', GroupButton,'Style','radiobutton',...
		'String',Options{2},...
		'Units','normalized',...
		'Position',[0.05 .05 .15 .4],...
		'HandleVisibility','on');

	radio(3) = uicontrol('Parent', GroupButton,'Style','radiobutton',...
		'String',Options{3},...
		'Units','normalized',...
		'Position',[0.3 .55 .15 .4],...
		'HandleVisibility','on');

	radio(4) = uicontrol('Parent', GroupButton,'Style','radiobutton',...
		'String',Options{4},...
		'Units','normalized',...
		'Position',[0.3 .05 .15 .4],...
		'HandleVisibility','on');

	radio(5) = uicontrol('Parent', GroupButton,'Style','radiobutton',...
		'String',Options{5},...
		'Units','normalized',...
		'Position',[0.55 .55 .15 .4],...
		'HandleVisibility','on');

	radio(6) = uicontrol('Parent', GroupButton,'Style','radiobutton',...
		'String',Options{6},...
		'Units','normalized',...
		'Position',[0.55 .05 .15 .4],...
		'HandleVisibility','on');

	radio(7) = uicontrol('Parent', GroupButton,'Style','radiobutton',...
		'String',Options{7},...
		'Units','normalized',...
		'Position',[0.8 .05 .15 .9],...
		'HandleVisibility','on');
		
	% Make the uibuttongroup visible after creating child objects.
	GroupButton.Visible = 'on';
    function bselection(hObject,eventdata) %#ok<*INUSL>
       %display(['Previous: ' eventdata.OldValue.String]);
       %display(['Current: ' eventdata.NewValue.String]);
       %display('------------------');
       setappdata(figStart,'method',eventdata.NewValue.String);
	   assignin('base','figStart',figStart)
	end
	

	%Run BUTTON
	buttonRun = uicontrol('Parent', figStart,'Style','pushbutton',...
		'Units','normalized',...
		'Position',[0.05 0.1 0.4 0.15],...
		'String','Proceed...',...
		'FontSize',18,...
		'Callback',@buttonRun_callback);

	%Run BUTTON
	ShowHistogram = uicontrol('Parent', figStart,'Style','pushbutton',...
		'Units','normalized',...
		'Position',[0.55 0.1 0.4 0.15],...
		'String','Show Markers Data...',...
		'FontSize',18,...
		'Callback',@ShowHistogram_callback);

	function ShowHistogram_callback(hObject,eventdata) %#ok<*INUSD>
		%newFig.delete;
		newFig=openfig('Frequencies.fig','reuse');
		newFig.OuterPosition=[0.01 0.3 0.98 0.69];
		figure(newFig);
		figure(figStart);
		figStart.Units='Normalized';
		figStart.OuterPosition(2)=0.01;
		figure(figStart)
	end

	function buttonRun_callback(hObject,eventdata)

        method = getappdata(figStart,'method');	
		switch method
			case '<html>Customized<br>Set of Markers</html>'
				numMarkers=0;
			otherwise
				method_cell=split(method);
				numMarkers=str2double(method_cell{1});
		end
		uiresume
		%commandwindow
	end
	
	uiwait
	%waitfor(figStart,'delete');

	if numMarkers==0
		ShowHistogram_callback();
		newFig.OuterPosition=[0.01 0.3 0.99 0.69];
	elseif newFig.isvalid
		newFig.delete
	end
	
	figStart.delete;

end

