function subjectThreshold = importfileForFigure4(filename, dataLines)
%IMPORTFILE Import data from a text file
%  SUBJECTTHRESHOLD = IMPORTFILE(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a table.
%
%  SUBJECTTHRESHOLD = IMPORTFILE(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  subjectThreshold = importfile("subjectThreshold.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 09-Aug-2020 18:21:07

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 13);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Subject", "CNSU_0002", "CNSU_1", "CNSU_2", "CNSU_0004", "CNSU_3", "CNSU_4", "CNSU_0008", "CNSU_5", "CNSU_6", "CNSU_0017", "CNSU_7", "CNSU_8"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
subjectThreshold = readtable(filename, opts);

end