unit mylibary_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type
  public=
    procedure; SplitText=(Trenner);//: Char; const str: String; Output: TStringList);

implementation
procedure SplitText(Trenner: Char; const str: String; Output: TStringList);
begin
  Output.Delimiter := Trenner;
  Output.StrictDelimiter := True;
  Output.DelimitedText := str;
end;

end.

