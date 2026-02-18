function Sandpile_model()
    grid = zeros(50);              % Create empty 50x50 grid
    grains = 4;                    % Default grains to add
    buttons = [];                  % Store button references
    
    % Setup window and display
    figure('Color','black');           
    img = imagesc(grid);           % Show grid as colors
    
    % Define 5 distinct colors for grain levels
    colormap([  0.051, 0.106, 0.165;             
                0.106, 0.149, 0.231;             
                0.255, 0.353, 0.467;             
                0.890, 0.392, 0.078;             
                0.604, 0.012, 0.118              
    ]);
       
    
    colorbar;                      % Show color scale
    caxis([0 4]);                  %#ok<CAXIS> % Set scale 0-4
    axis equal tight;              % Square cells, no gaps
    title('Sandpile Model');       % Title text
    
    % Create grain selection buttons
    amounts = [1 2 3 4 16 64 256 512 1024];  % Grain options
    for n = 1:9                              % Make 9 buttons
        buttons(n) = uicontrol('Style','push',...
            'String',num2str(amounts(n)),...     % Button shows number
            'Position',[10+(n-1)*80 10 75 30],... % Space buttons apart
            'BackgroundColor',[1 1 1],...        
            'ForegroundColor',[0 0 0],...
            'Callback',@(~,~)set_g(amounts(n))); %#ok<AGROW> % Click = select grains
    end
    
    % Create reset button
    uicontrol('Style','push','String','Reset',...
              'Position',[750 10 100 30],...
              'BackgroundColor',[1 1 1],...        
              'ForegroundColor',[0 0 0],...        
              'Callback',@(~,~)reset());             % Click = reset grid
    
    % Enable clicking on grid
    set(img,'ButtonDownFcn',@click);           % Grid click = add grains
    
    update_buttons();                          % Highlight default button
    
    % Select grain amount
    function set_g(n)
        grains = n;                % Store selected  grain amount
        update_buttons();          % Update button colors
    end
    
    % Highlight selected button
    function update_buttons()
        for i = 1:length(buttons)
            if str2double(get(buttons(i),'String')) == grains
                set(buttons(i),'BackgroundColor',[0.3 0.8 0.3],...  
                    'FontWeight','bold');      % Green = selected
            else
                set(buttons(i),'BackgroundColor',[0.94 0.94 0.94],...
                    'FontWeight','normal');    % Gray = not selected
            end
        end
    end
    
    % Reset to empty grid
    function reset()
        grid = zeros(50);          % Clear all grains
        set(img,'CData',grid);     % Update display
    end
    
    % Handle grid clicks
    function click(~,~)
        pt = get(gca,'CurrentPoint');          % Get click position
        x = round(pt(1,1));                    % Round to cell column
        y = round(pt(1,2));                    % Round to cell row
        
        if x>=1 && x<=50 && y>=1 && y<=50      % Check if inside grid
            grid(y,x) = grid(y,x) + grains;    % Add grains to cell
            set(img,'CData',grid);             % Show new grains
            drawnow;                           % Update screen now
            avalanche();                       % Start cascade
        end
    end
    
    % Run avalanche cascade
    function avalanche()
        while any(grid(:) >= 4)                % While any cell has 4+ grains
            [r,c] = find(grid >= 4);           % Find unstable cells
            
            for i = 1:length(r)                % For each unstable cell
                if grid(r(i),c(i)) >= 4
                    grid(r(i),c(i)) = grid(r(i),c(i)) - 4;  % Remove 4 grains
                    
                    % Give 1 grain to each neighbor
                    if r(i) > 1,  grid(r(i)-1,c(i)) = grid(r(i)-1,c(i)) + 1; end  % Above
                    if r(i) < 50, grid(r(i)+1,c(i)) = grid(r(i)+1,c(i)) + 1; end  % Below
                    if c(i) > 1,  grid(r(i),c(i)-1) = grid(r(i),c(i)-1) + 1; end  % Left
                    if c(i) < 50, grid(r(i),c(i)+1) = grid(r(i),c(i)+1) + 1; end  % Right
                end
            end
            
            set(img,'CData',grid);            
            pause(0.05);                       
            drawnow;                          
        end
    end
end


