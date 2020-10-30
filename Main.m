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

%% Choose experiment number
exp = 2;

%% Read differentially private semi-partial correlation data
directory = 'ExpressionContextCorrCSVs';
files = dir(fullfile(directory,['Exp' num2str(exp) '*.csv']));
corrs = cell(1,12);
for f = 1:12
    [emonames,allnames,corrs{f}] = tableread(fullfile(directory,files(f).name));
end
corrs = cat(3,corrs{:});

%% Select contexts
selectcontexts = {'Art' 'Birthday' 'Bodybuilding' 'Candy' 'Dance' 'Fashion' 'Father' 'Fireworks' 'Government' 'Health' 'Humor' 'Individual Sports' 'Individual sport' 'Interview' 'Martial Arts' 'Martial arts' 'Model' 'Mother' 'Music' 'Music & Audio' 'Parody' 'Pet' 'Pets' 'Police' 'Practical Joke' 'Practical joke' 'Protest' 'Rapping' 'Rock Concert' 'Rock concert' 'Sad' 'School' 'Shopping' 'Soldier' 'Standing' 'Team Sports' 'Team sport' 'Toy' 'Toys' 'Wedding' 'Weight training'};
% selectcontexts = []; % leave empty to show all contexts

%% Visualize correlations
plotCorrs(allnames,selectcontexts,emonames,corrs,2)
