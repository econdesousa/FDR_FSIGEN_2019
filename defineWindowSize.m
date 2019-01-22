function figPos=defineWindowSize(figPos)
%% defineWindowSize adjusts the window size to ensure it fits the screen
% if its size doesn't fit the screen try first to move it and the to shrink
% it
	set(0,'units','pixels');
	%Obtains this pixel information
	Pix_SS = get(0,'screensize');

	%if defined position occupies more than 90% of avail size, adjust it
	if Pix_SS(3)*.9 < figPos(1)+figPos(3) || Pix_SS(4)*.9 < figPos(2)+figPos(4)

		if Pix_SS(3)*.9 < figPos(1)+figPos(3)
			if Pix_SS(3) >= figPos(3)
				figPos(1)=500;
				while Pix_SS(3) < figPos(1)+figPos(3)
					figPos(1)=max([figPos(1)-50, 0]);
				end
			else
				figPos(1)=Pix_SS(1)	;
				figPos(3)=Pix_SS(3);
			end
		end
		if Pix_SS(4)*.9 < figPos(2)+figPos(4)
			if Pix_SS(4) >= figPos(4)
				figPos(2)=400;
				while Pix_SS(4) < figPos(2)+figPos(4)
					figPos(2)=max([figPos(2)-200 , 0]);
				end
			else
				figPos(2)=Pix_SS(2)	;
				figPos(4)=Pix_SS(4);
			end
		end
	end
end
