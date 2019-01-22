
function main()
	warning ('off','all');
	mainWindow();
	[~,numMarkers]=selectMarkers(figPos);
	if numMarkers == 0
		cols=selectCustomizedMarkers(MarkerNames);
		while numel(cols)==0
			f = warndlg('no markers selected');
			waitfor(f);			
			cols=selectCustomizedMarkers(MarkerNames);
		end
	elseif numMarkers==8
		cols=[7,8,17,3,9,4,10,15];
	else
		cols=1:numMarkers;
	end
	
	FDR(dataH1,dataH2,cols,D);
end
