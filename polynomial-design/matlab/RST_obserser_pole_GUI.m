%% Script for generating GUI to illustrate effect of observer pole


f = figure;
ax = axes('Parent',f,'position',[0.13 0.39  0.77 0.54]);
[Ss, Tt, w, sol] = RST_observer_pole(0.4);

hS = loglog(w, Ss);
hold on
hT = loglog(w, Tt);
legend('|Ss(w)|', '|Tt(w)|')

b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
              'value',0.4, 'min',0, 'max',0.8);
bgcolor = f.Color;
bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
                'String','0','BackgroundColor',bgcolor);
bl2 = uicontrol('Parent',f,'Style','text','Position',[500,54,23,23],...
                'String','0.8','BackgroundColor',bgcolor);
bl3 = uicontrol('Parent',f,'Style','text','Position',[240,25,100,23],...
                'String','Observer pole','BackgroundColor',bgcolor);
            
b.Callback = @(es,ed) RST_observer_pole(es.Value, sol, hS, hT); 