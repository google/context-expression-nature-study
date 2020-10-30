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

function [emonames,allnames,corrs] = tableread(filename)

tmp = fileread(filename);
rows = strsplit(tmp,'\n');
rows = cellfun(@(x)strsplit(x,','),rows,'UniformOutput',false);
table = vertcat(rows{:});
allnames = table(2:end,1);
emonames = table(1,2:end);
corrs = cellfun(@str2num,table(2:end,2:end));

end

