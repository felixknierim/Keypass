unit Eingabe_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, libary_u;

type

  { TForm2 }

  TForm2 = class(TForm)
    Abbrechen_B: TButton;
    Hinzufuegen_B: TButton;
    Fehler_L: TLabel;
    Static_L: TLabel;
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
var Daten: string;
var NextAction: boolean;
var Output: string;
begin
  Daten:= Name_E.Text + '&' + URL_E.Text + '&' + Nutzername_E.Text + '&' + Passwort_E.Text + '&';
  NextAction:= false;
  Output:= '';
  Speichern(Daten, Name_E.Text,Output, NextAction);
  if NextAction = true then
  begin
    Close;
  end
  else
  begin
    Fehler_L.Caption:= Output;
    Static_L.Caption:= '';
  end;
end;

procedure TForm2.Abbrechen_BClick(Sender: TObject);
begin
  Close;
end;

end.

