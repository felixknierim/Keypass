unit Passwortabfrage_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, md5;

type

  { TForm4 }

  TForm4 = class(TForm)
    Bestaetigen_E: TButton;
    Zweck_L: TLabel;
    Passwort_E: TEdit;
    Static_L: TLabel;
    procedure Bestaetigen_EClick(Sender: TObject);
  private
    var Passwort: string;
  public

  end;

var
  Form4: TForm4;

implementation

{$R *.lfm}

{ TForm4 }

procedure TForm4.Bestaetigen_EClick(Sender: TObject);
var Passwort_Hash: TStringList;
begin
   Passwort_Hash:= TStringList.Create;
  if FileExists('C:\\Keypass\\Passwort.txt') then
  begin
  Passwort_Hash:= TStringList.Create;
  Passwort_Hash.LoadFromFile('C:\\Keypass\\Passwort.txt');
  if Passwort_Hash[0] = MD5Print(MD5String(Passwort_E.Text)) then
  begin
    Passwort:= Passwort_E.Text;

  end;
  end
  else
  begin

    Passwort_Hash.Add(MD5Print(MD5String(Passwort_E.Text)));
    Passwort_Hash.SaveToFile('C:\\Keypass\\Passwort.txt');
    Passwort:= Passwort_E.Text;

  end;
  Close;
end;

end.

