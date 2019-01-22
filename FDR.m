function FDR(dataH1,dataH2,cols,D)
	
	
	
	figPos= [450 250 1000 800];
	figPos=defineWindowSize(figPos);
	
	
	
	D=split(D,'_');
	switch D{1,1,4}
		case 'AVvsUnr'
			D{1,1,4}='AV vs Unr';
		case 'FCvsUnr'
			D{1,1,4}='FC vs Unr';
		case 'FSvsHS'
			D{1,1,4}='FS vs HS';
		case 'FSvsUn'
			D{1,1,4}='FS vs Unr';
		case 'HCvsUnr'
			D{1,1,4}='HC vs Unr';
		case 'HS2vsUn'
			D{1,1,4}='HS vs Unr';
	end
	
	fName=['Kinship: ' D{1,1,4} '    Persons: ' D{1,1,5} '    Number of Markers: ' num2str(numel(cols))];
	
	leg=D{1,1,4};
	leg1=leg(1:strfind(leg,' vs '));
	leg2=leg((strfind(leg,' vs ')+4):end);
	fig = figure('Name',fName,'NumberTitle','off',...
		'units','pixels',...
		'OuterPosition',figPos,...
		'MenuBar','none',...
		'Resize','on');
	
	y1=prod(dataH1(:,cols),2);
	y2=prod(dataH2(:,cols),2);
	
	set(fig,'units','normalized');
	
	xst=0;
	
	
	EDG=min([-10,floor(min(log10(y2)))]):0.1:max([10,ceil(max(log10(y1)))]);
	
	ax=axes(fig);
	ax.Units='Normalized';
	ax.Position=[0.05 0.75 0.65 0.2];
	histogram(log10(y1),'Parent',ax,'BinEdges',EDG,'Normalization','probability','LineStyle','none');
	hold on
	histogram(log10(y2),'Parent',ax,'BinEdges',EDG,'Normalization','probability','LineStyle','none');
	hold off
	ax.XAxis.TickLabels=strcat('10^{' ,ax.XAxis.TickLabels,'}');
	lin1=line([log10(100) log10(100)],get(ax,'YLim'),'Color',[1 0 0]);
	lin2=line([log10(0.01) log10(0.01)],get(ax,'YLim'),'Color',[1 0 0]);
	legend({leg1 leg2 ['thresh_{' leg1 '}'] ['thresh_{' leg2 '}']});
	figure(fig);
	dispTable(fig,y1,y2,xst,1,lin1,ax,fix(ax.XLim));
	dispTable(fig,y2,y1,xst+0.5,-1,lin2,ax,fix(ax.XLim));
	
	
	f2=fig;
	ax2=axes(f2);
	ax2.Box='on';
 	ax2.Position=[0.75 0.75 0.2 0.2];
	
	
	it=1;
	for ii=-30:0.1:30
		th=10^ii;
		isH1 = [sum(y1>=th);sum(y1<th)];
		isH2 = [sum(y2>=th);sum(y2<th)];
		isH1=[isH1;sum(isH1)]; %#ok<*AGROW>
		isH2=[isH2;sum(isH2)];
		TPR(it)=isH1(1)/isH1(3);
		FPR(it)=isH2(1)/isH2(3);
		it=it+1;
	end
	plot(FPR,TPR,'r');
	hold on
	
	clear TPR FPR isH1 isH2
	it=1;
	for ii=-30:0.1:30
		th=10^-ii;
		isH1 = [sum(y1<=th);sum(y1>th)];
		isH2 = [sum(y2<=th);sum(y2>th)];
		
		isH1=[isH1;sum(isH1)];
		isH2=[isH2;sum(isH2)];
		
		TPR(it)=isH2(1)/isH2(3);
		FPR(it)=isH1(1)/isH1(3);
		it=it+1;
	end
	plot(FPR,TPR,'b');
	xx=linspace(0,1);
	plot(xx,xx,'k--');
	axis equal;
	hold off
	ax2.XLim=[0 1];
	ax2.YLim=[0 1];
	ax2.XTick=0:1;
	ax2.YTick=0:1;
	xlabel('False Positive Rate');
	ylabel('True Positive Rate');
	lgd=legend({'Predicted H1','Predicted H2'},'location','southeast');
	lgd.FontSize = 8;
	title('ROC curve')
	
	figure(fig);
end


function dispTable(fig,y1,y2,xst,direction,lin,ax,Limits)
	N=numel(y1)+numel(y2);
	if direction==1
		Pred = {'Predicted H1','Predicted Other','Sum'};
	else
		Pred = {'Predicted H2','Predicted Other','Sum'};
	end
	if direction==1
		isH1 = [sum(y1>=100);sum(y1<100)];
		isH2 = [sum(y2>=100);sum(y2<100)];
	else
		isH1 = [sum(y1<=0.01);sum(y1>0.01)];
		isH2 = [sum(y2<=0.01);sum(y2>0.01)];
	end
	
	FDR = ['False discovery rate (FDR): ' num2str(isH2(1)./(isH1(1)+isH2(1)),2)];
	TPR = ['True positive rate (TPR):   ' num2str(isH1(1)./(isH1(1)+isH1(2)),2)];
	
	isH1=[isH1;sum(isH1)]./N;
	isH2=[isH2;sum(isH2)]./N;
	Sum=isH1+isH2;
	
	TP1 = ['Type I error:  ' num2str(isH2(1),2)];
	TP2 = ['Type II error: ' num2str(isH1(2),2)];
	
	T = table(isH1,isH2,Sum,'RowNames',Pred);
	
	txtSlider = annotation(fig,'textbox','String','Threshold: 100', ...
		'FontSize',10,'units','normalized',...
		'Position', [xst+0.05 0.1 0.4 0.1],...
		'HorizontalAlignment', 'center',...
		'VerticalAlignment', 'middle',...
		'Interpreter','Tex',...
		'LineStyle','none');
	if direction~=1
		set(txtSlider,'String','Threshold: 0.01');
	end
	
	txtFDR = uicontrol('Style','text',...
		'Units','normalized',...
		'Position',[xst+0.05 0.23 0.4 0.07],...
		'fontweight', 'bold',...
		'FontSize',10,...
		'String',FDR);
	
	txtTPR = uicontrol('Style','text',...
		'Units','normalized',...
		'Position', [xst+0.05 0.42 0.4 .07],...
		'fontweight', 'bold',...
		'FontSize',10,...
		'String',TPR,...
		'Visible','off');
	
	txtTP1 = uicontrol('Style','text',...
		'Units','normalized',...
		'Position', [xst+0.05 0.34 0.4 .07],...
		'fontweight', 'bold',...
		'FontSize',10,...
		'String',TP1,...
		'Visible','off');
	
	txtTP2 = uicontrol('Style','text',...
		'Units','normalized',...
		'Position', [xst+0.05 0.26 0.4 .07],...
		'fontweight', 'bold',...
		'FontSize',10,...
		'String',TP2,...
		'Visible','off');
	
	Ta=uitable(fig,'Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
		'RowName',T.Properties.RowNames,...
		'Units','normalized',...
		'Position', [xst+0.02 0.3 0.46 .30],...
		'RowStriping','off',...
		'Enable','on');
	if direction~=1
		Ta.ColumnName(1:2)=Ta.ColumnName(2:-1:1);
	end
	
	txtTitle = annotation(fig,'textbox','String','LR \geq 10^{2}', ...
		'FontSize',20,...
		'units','normalized',...
		'Position', [xst+0.05 0.60 0.4 0.1],...
		'HorizontalAlignment', 'center',...
		'VerticalAlignment', 'middle',...
		'Interpreter','Tex',...
		'LineStyle','none');
	if direction~=1
		set(txtTitle,'String','LR \leq 10^{-2}');
	end
	
	if direction==1
		stepSize=1/Limits(end);
		uicontrol(fig,'Style', 'slider',...
			'Min',0,'Max',Limits(end),'Value',2,...
			'units','normalized',...
			'Position', [xst+0.05 0.17 0.4 0.05],...
			'SliderStep',[stepSize/100,stepSize/10],...
			'BackgroundColor', [.5 .5 .5],...
			'Callback', @(sl,event) updateTable(sl,Ta,N,y1,y2,...
			txtFDR,txtTPR,txtTP1,txtTP2,txtSlider,txtTitle,direction,lin,ax)...
			);
	else
		stepSize=-1/Limits(1);
		sl=uicontrol(fig,'Style', 'slider',...
			'Min',Limits(1),'Max',0,'Value',-2,...
			'units','normalized',...
			'Position', [xst+0.05 0.17 0.4 0.05],...
			'SliderStep',[stepSize/100,stepSize/10],...
			'BackgroundColor', [.5 .5 .5],...
			'Callback', @(sl,event) updateTable(sl,Ta,N,y1,y2,...
			txtFDR,txtTPR,txtTP1,txtTP2,txtSlider,txtTitle,direction,lin,ax)...
			);
	end
	
end

function updateTable(sl,Ta,N,y1,y2,txtFDR,txtTPR,txtTP1,txtTP2,txtSlider,txtTitle,direction,lin,ax)
	Pred = {'Predicted_H1','Not H1','Predicted'};
	
	if direction==1
		isH1 = [sum(y1>=10.^(sl.Value));sum(y1<10.^(sl.Value))];
		isH2 = [sum(y2>=10.^(sl.Value));sum(y2<10.^(sl.Value))];
	else
		isH1 = [sum(y1<=10.^(sl.Value));sum(y1>10.^(sl.Value))];
		isH2 = [sum(y2<=10.^(sl.Value));sum(y2>10.^(sl.Value))];
	end
	
	FDR = ['False discovery rate (FDR): ' num2str(isH2(1)./(isH1(1)+isH2(1)),2)];
	TPR = ['True positive rate (TPR):   ' num2str(isH1(1)./(isH1(1)+isH1(2)),2)];
	
	isH1=[isH1;sum(isH1)]./N;
	isH2=[isH2;sum(isH2)]./N;
	Predicted=isH1+isH2;
	
	TP1 = ['Type I error:  ' num2str(isH2(1),2)];
	TP2 = ['Type II error: ' num2str(isH1(2),2)];
	
	
	
	T = table(isH1,isH2,Predicted,'RowNames',Pred);
	
	Ta.Data=T{:,:};
	set(txtTP1,'String',TP1);
	set(txtTP2,'String',TP2);
	set(txtTPR,'String',TPR);
	set(txtFDR,'String',FDR);
	set(txtSlider,'String',['Threshold: ' num2str(10.^sl.Value)]);
	lin.XData=[sl.Value sl.Value];
	if direction==1
		set(txtTitle,'String',['LR \geq 10^{' num2str(sl.Value) '}']);
	else
		set(txtTitle,'String',['LR \leq 10^{' num2str(sl.Value) '}']);
	end
	
end

