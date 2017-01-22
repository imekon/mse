program convertcolors;

uses
  System.Classes, System.SysUtils;

const
  inputFilename = 'colors.inc';
  outputFilename = 'colors.txt';

var
  i: integer;
  value: single;
  input: TextFile;
  output: TextFile;
  line, temp, name, r, g, b: string;
  parameters: TStringList;

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

function StripSemiC(const text: string): string;
var
  i: integer;
  builder: TStringBuilder;
  
begin
  builder := TStringBuilder.Create;
  for i := 1 to Length(text) do
  begin
    if text[i] <> ';' then
      builder.Append(text[i]);
  end;
  result := builder.ToString;
  builder.Free;
end;

begin
  AssignFile(input, inputFilename);
  AssignFile(output, outputFilename);
  Reset(input);
  Rewrite(output);
  try
    WriteLn(output, 'Red 1 0 0');
    WriteLn(output, 'Green 0 1 0');
    WriteLn(output, 'Blue 0 0 1');
    WriteLn(output, 'Yellow 1 1 0');
    WriteLn(output, 'Cyan 0 1 1');
    WriteLn(output, 'Magenta 1 0 1');
    WriteLn(output, 'Black 0 0 0');
    WriteLn(output, 'White 1 1 1');

    for i := 0 to 19 do
    begin  
      value := i * 0.05;
      if i < 2 then
        WriteLn(output, 'Gray0', (i * 5):1, ' ', value:1:2, ' ', value:1:2, ' ', value:1:2)
      else
        WriteLn(output, 'Gray', (i * 5):2, ' ', value:1:2, ' ', value:1:2, ' ', value:1:2);
    end;

    parameters := TStringList.Create;
    while not(eof(input)) do
    begin
      ReadLn(input, line);
      if Length(line) = 0 then
        continue;
      temp := Copy(line, 1, 3);
      if temp = '// ' then
        continue;
      Split(' ', line, parameters);

      if (parameters[0] = '#declare') and
         (parameters[2] = '=') and
         (parameters[3] = 'color') and
         (parameters[4] = 'red') and
         (parameters[6] = 'green') then
      begin
        name := parameters[1];
        r := parameters[5];
        g := StripSemiC(parameters[7]);
        b := '0.0';
        WriteLn(output, name, ' ', r, ' ', g, ' ', b);
      end
      else
      if (parameters[0] = '#declare') and
         (parameters[2] = '=') and
         (parameters[3] = 'color') and
         (parameters[4] = 'red') and
         (parameters[6] = 'blue') then
      begin
        name := parameters[1];
        r := parameters[5];
        g := '0.0';
        b := StripSemiC(parameters[7]);
        WriteLn(output, name, ' ', r, ' ', g, ' ', b);
      end
      else
      if (parameters[0] = '#declare') and
         (parameters[2] = '=') and
         (parameters[3] = 'color') and
         (parameters[4] = 'red') and
         (parameters[6] = 'green') and
         (parameters[8] = 'blue') then
      begin
        name := parameters[1];
        r := parameters[5];
        g := parameters[7];
        b := StripSemiC(parameters[9]);
        WriteLn(output, name, ' ', r, ' ', g, ' ', b);
      end;

    end;
    parameters.Free;
  finally
    CloseFile(input);
    CloseFile(output);
  end;
end.
