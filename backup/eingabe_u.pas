unit Eingabe_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Abbrechen_B: TButton;
    Hinzufuegen_B: TButton;
    Fehler_L: TLabel;
    Passwort_E: TEdit;
    Passwort_L: TLabel;
    Nutzername_E: TEdit;
    Nutzername_L: TLabel;
    URL_E: TEdit;
    URL_L: TLabel;
    Name_E: TEdit;
    Name_L: TLabel;
    procedure Abbrechen_BClick(Sender: TObject);
    procedure Hinzufuegen_BClick(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.Hinzufuegen_BClick(Sender: TObject);
var Stringlist: TStringList;
var Index: TStringList;
var Buffer: TStringList;
var zaehler: integer;
begin
  Stringlist:= TStringList.Create;
  Stringlist.Add(Name_E.Text + '&' + URL_E.Text + '&' + Nutzername_E.Text + '&' + Passwort_E.Text);
  if Not(DirectoryExists('C:\\Keypass')) then
    CreateDir('C:\\Keypass');
  if Not(FileExists('C:\\Keypass\\' + Name_E.Text + '.txt')) then
  begin
    Stringlist.SaveToFile('C:\\Keypass\\' + Name_E.Text + '.txt');
    Index:= TStringList.Create;
    Buffer:= TStringList.Create;
    if FileExists('C:\\Keypass\\Index.txt') then
    begin
      Buffer.LoadFromFile('C:\\Keypass\\index.txt');
      for zaehler:=0 to Buffer.Count-1 do
      begin
        Index.Add(Buffer[zaehler]);
      end;
    end;
    Index.Add(Name_E.Text);
    Index.SaveToFile('C:\\Keypass\\index.txt');
    Close;
  end
  else
  begin
    Fehler_L.Caption:= 'Fehler: Dateiname existiert schon.' + #10#13 + 'Geben sie dem Eintrag einen anderen Namen';
  end;
end;

procedure TForm2.Abbrechen_BClick(Sender: TObject);
begin
  Close;
end;

end.

