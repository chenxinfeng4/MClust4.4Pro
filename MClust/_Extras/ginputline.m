function [x, y] = ginputline(clr)
%Improve 'ginput' with color line.
%Finished by "DOUBLE CLICK" or press "ENTER".
%function [x, y] = ginputline(clr)
% clr : line color
% x, y: coordinates, [n]_by_1
%
% inspired by 'DrawConvexHull.m' (B. Hangya, CSHL; balazs.cshl@gmail.com)
% modified by Chen XF, 2016-7-8
    if ~exist('color','var')
        clr = 'k';
    end
    pointcntr = 0;
    isenter = 0;
    A = gca;
    F = gcf;
    set(F,'Pointer','crosshair')
    
    % Remove ButtonDownFcn
    bdf = get(A,'ButtonDownFcn');
    set(A,'ButtonDownFcn',[])
    set(allchild(A),'ButtonDownFcn',[])
    
    % Draw polygon
    seltyp = get(F,'SelectionType');  % click type
    if isequal(seltyp,'normal') || pointcntr == 0;
        point1 = get(A,'CurrentPoint'); % button down detected
        point1x = point1(1,1);
        point1y = point1(1,2);
        point0x = point1(1,1);
        point0y = point1(1,2);
        L = plot(NaN, NaN, 'MarkerSize', 6, 'Marker', 'o',...
            'Color', clr, 'MarkerFaceColor', clr);
        bp = 1;
        while bp
            bp = waitforbuttonpress;    % wait for mouse click
            if ~isequal(gcf,F)      % the user clicked on another figure window
                x = [];
                y = [];
                return
            end
        end
        seltyp2 = get(F,'SelectionType');  % click type
        while isequal(seltyp2,'normal') && ~isenter
            point2 = get(A,'CurrentPoint'); % button down detected
            point2x = point2(1,1);
            point2y = point2(1,2);
            set(L(1), 'XData', point2x, 'YData', point2y);
            if pointcntr > 0
                L(end+1) = line([point1x point2x],[point1y point2y],'Color',clr,'LineWidth',1);
            end
            point0x = [point0x point2x];
            point0y = [point0y point2y];
            pointcntr = pointcntr + 1;
            point1x = point2x;
            point1y = point2y;
            bp = 1;
            while bp
                bp = waitforbuttonpress;    % wait for mouse click
                if ~isequal(gcf,F)      % the user clicked on another figure window
                    x = [];
                    y = [];
                    return
                end
                cchar = get(F,'CurrentCharacter');
                if bp && isequal(double(cchar),13)    % Enter pressed
                    bp = 0;
                    isenter = 1;
                end
            end
            seltyp2 = get(F,'SelectionType');  % click type
        end
        L(end+1) = line([point2x point0x(2)],[point2y point0y(2)],'Color',clr,'LineWidth',1);
    end
    x = point0x(2:end);
    y = point0y(2:end);
    
    % Restore ButtonDownFcn
    set(A,'ButtonDownFcn',bdf)
    set(allchild(A),'ButtonDownFcn',bdf)
    
    delete(L)   % delete lines  
    set(F,'Pointer','arrow')
    x = reshape(x,[],1);
    y = reshape(y,[],1);