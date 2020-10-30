% Copyright 2020 Google LLC
% 
% Licensed under Creative Commons Attribution 4.0 International Public 
% License (the "License"); you may not use this file except in compliance
% with the License. You may obtain a copy of the License at
% 
%     https://creativecommons.org/licenses/by/4.0/
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

% Cowen et al., 2020 Nature

function [] = plotCorrs(allnames,selectnames,emonames,correlations,sdmax)

    if ~isempty(selectnames)
        selectnames(~ismember(selectnames,allnames)) = [];
        [~,kgididx] = ismember(selectnames,allnames);
    else
        kgididx = 1:length(allnames);
    end
    
    selectnames = allnames(kgididx);

    selectcorrelations = correlations(kgididx,:,:);
    sz = size(selectcorrelations);
    temp=mean(selectcorrelations,3);
    [~,m] = sort(temp,2,'descend');
    m(:,2) = ((m(:,2)-m(:,1)) == 1) - ((m(:,2)-m(:,1)) == -1); 
    [~,korder] = sortrows(m);
    cpUSE = selectcorrelations(korder,:,:);
    img = zeros(sz(1)*4-1,sz(2)*5-1);
    for i = 1:sz(1)
        vals = squeeze(cpUSE(i,:,:));
        maxval = std(vals(:))*sdmax;
        for j = 1:sz(2)
            c = squeeze(cpUSE(i,j,:));
            c = c./maxval;
            c(c<-1) = -1;
            c(c>1) = 1;
            img((i-1)*4+(1:3),(j-1)*5+(1:4)) = reshape(c,[3 4]);
        end
    end
    img = 1-cat(3,-img.*(img<0),abs(img),img.*(img>0));
    figure('Color','w','Position',[273    28   726   681]);
    imagesc(img)
    axis equal
    xlim([0 size(img,2)+.5]);
    ylim([0 size(img,1)+.5]);
    axis off
    for i = 1:length(selectnames)
        text(-1,(i-1)*4+2,selectnames{korder(i)},'HorizontalAlignment','right','Color','k')
    end
    for i = 1:length(emonames)
        text((i-1)*5+2.2,size(img,1)+2,emonames(i),'HorizontalAlignment','right','Rotation',90,'Color','k')
    end


    for i = 1:sz(2)
        cemo{i} = corr(squeeze(correlations(:,i,:)),'rows','pairwise'); 
    end
    cemomean1 = cellfun(@(x)tanh(nanmean(atanh(x(~eye(12))))),cemo);
    for i = 1:sz(2)
        cemo{i} = corr(squeeze(correlations(kgididx,i,:)),'rows','pairwise'); 
    end
    cemomean2 = cellfun(@(x)tanh(nanmean(atanh(x(~eye(12))))),cemo);
    for i = 1:size(correlations,1)
        ckgid{i} = corr(squeeze(correlations(i,:,:)),'rows','pairwise'); 
    end
    ckgidmean = cellfun(@(x)nanmean(x(~eye(12))),ckgid);
    ckgidmean(ckgidmean<0)=0;
    ckgidmean(isnan(ckgidmean)) = 0;

    for i = 1:sz(2)
        pos = [(i-1)*5+.5 (-.5-cemomean2(i)*8) 4 cemomean2(i)*8];
        rectangle('Position',pos,'FaceColor',1-[.19 .19 .19],'LineStyle','none')
        pos = [(i-1)*5+.5 (-.5-cemomean1(i)*8) 4 cemomean1(i)*8];
        rectangle('Position',pos,'FaceColor',1-[.26 .26 .26],'LineStyle','none')
    end
    for i = 1:sz(1)
        pos = [size(img,2)+1.5 (i-1)*4+.5 ckgidmean(kgididx(korder(i)))*8 3];
        rectangle('Position',pos,'FaceColor',1-[.26 .26 .26],'LineStyle','none')
    end
    hold on
    zs = zeros(1,length((0:.01:1)));
    os = ones(1,length((0:.01:1)));
    cbar = 1-permute([([0:.01:1 os])' [0:.01:1 fliplr(0:.01:1)]' fliplr([0:.01:1 os])'],[3 1 2]);
    imagesc([size(img,2)+1.5 size(img,2)+9.5],[-2.5 (-1.5)],1-cbar);
    text(size(img,2)+1.5,-4.7,'-2','FontSize',8,'Color','k','HorizontalAlignment','left')
    text(size(img,2)+5.5,-4.7,'SD','FontSize',8,'Color','k','HorizontalAlignment','center')
    text(size(img,2)+9.5,-4.7,'2','FontSize',8,'Color','k','HorizontalAlignment','right')

    line([-1.7 (-1.7)],[-.5 (-8.5)],'Color','k');
    line([-1.7 (-1)],[-.5 (-.5)],'Color','k');
    line([-1.7 (-1)],[-8.5 (-8.5)],'Color','k');
    line([-1.7 (-1)],[-4.5 (-4.5)],'Color','k');
    text(-2.2,-.5,'0','HorizontalAlignment','right','Color','k','FontSize',8);
    text(-2.2,-4.5,'.5','HorizontalAlignment','right','Color','k','FontSize',8);
    text(-2.2,-8.5,'1','HorizontalAlignment','right','Color','k','FontSize',8);
    text(.5,-9.5,'Across attributes included here','HorizontalAlignment','left','Color',1-[.19 .19 .19],'FontSize',8,'FontWeight','bold');
    text(35.5,-9.5,'Across all attributes studied','HorizontalAlignment','left','Color',1-[.26 .26 .26],'FontSize',8,'FontWeight','bold');
    text(34,-9.5,'/','HorizontalAlignment','left','Color',1-[.225 .225 .225],'FontSize',8,'FontWeight','bold');
    text(-4.5,-4.5,['Avg. r' newline 'between' newline 'regions'],'HorizontalAlignment','center','Color','k','FontSize',8,'VerticalAlignment','bottom','Rotation',90);

    line([size(img,2)+1.5 size(img,2)+1.5+8],size(img,1)+[3 3],'Color','k');
    line([size(img,2)+1.5 size(img,2)+1.5],[size(img,1)+3 size(img,1)+2.3],'Color','k');
    line([size(img,2)+5.5 size(img,2)+5.5],[size(img,1)+3 size(img,1)+2.3],'Color','k');
    line([size(img,2)+9.5 size(img,2)+9.5],[size(img,1)+3 size(img,1)+2.3],'Color','k');
    text(size(img,2)+1.5,size(img,1)+3.5,'0','HorizontalAlignment','center','VerticalAlignment','top','Color','k','FontSize',8);
    text(size(img,2)+5.5,size(img,1)+3.5,'.5','HorizontalAlignment','center','VerticalAlignment','top','Color','k','FontSize',8);
    text(size(img,2)+9.5,size(img,1)+3.5,'1','HorizontalAlignment','center','VerticalAlignment','top','Color','k','FontSize',8);
    text(size(img,2)+5.5,size(img,1)+5.8,['Avg. r' newline 'between' newline 'regions'],'HorizontalAlignment','center','Color','k','FontSize',8,'VerticalAlignment','top');

    hold on
    imagesc([-20.5 -3.8],[size(img,1)+14.5 size(img,1)+4.5],1-[.1 .2 .1 .2; .2 .1 .2 .1; .1 .2 .1 .2]);
    colormap([(0:.01:1)' (0:.01:1)' (0:.01:1)']);
    caxis([0 1])
    textlocx = linspace(-23.5,-.8,9);
    textlocx = textlocx(2:2:end);
    textlocy = linspace(size(img,1)+17,size(img,1)+2,7);
    textlocy = textlocy(2:2:end);
    textlocx = repmat(textlocx,[3 1]);
    textlocy = flipud(repmat(textlocy',[1 4]));
    regabbrev = {['Hispa' newline 'Amer'] 'Brazil' ['US/' newline 'Cana'] 'Africa' ['Middl' newline 'East'] ['West' newline 'Euro'] ['East' newline 'Euro'] ['Cent' newline 'Euro'] ['India' newline 'Subc'] ['MLSE' newline 'Asia'] ['MTSE' newline 'Asia'] ['East' newline 'Asia']};
    for i = 1:12
        text(textlocx(i),textlocy(i),regabbrev{i},'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',7,'Color','k')
    end
    text(-12.15,size(img,1)+17.2,'World Regions','Color','k','VerticalAlignment','top','HorizontalAlignment','center')

    set(gca,'Clipping','off')


end
