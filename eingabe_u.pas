unit Eingabe_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, libary_u, Passwortabfrage_u;

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
  if Not(FileExists('C:\\Keypass\\Passwort.txt')) then //wenn die Datei Passwort.txt nicht existiert
  begin
    Form4.Zweck_L.Caption:= 'Passwort erstellen'; //ändert das Info-Label in Form4 (Passwortabfrage/eingabe)
    Form4.ShowModal;  //öffnet die Passwortabfrage/eingabe
  end;
  Daten:= Name_E.Text + '&' + URL_E.Text + '&' + Nutzername_E.Text + '&' + Passwort_E.Text + '&'; //Daten werden von Fenster in Variable gespeichert
  NextAction:= false; //gibt an ob alles funktioniert hat
  Output:= '';  //genauere Fehlermeldung
  Speichern(Daten, Name_E.Text,Output, NextAction); //Daten werden gespeichert
  if NextAction = true then
  begin
    Close;  //Fenster wird geschlossen
  end
  else
  begin
    Fehler_L.Caption:= Output;
    Static_L.Caption:= '';  //Da sich die Labels überlappen wird der Inhalt des einen Labels gelöscht damit man etwas lesen kann
  end;

end;

procedure TForm2.Abbrechen_BClick(Sender: TObject);
begin
  Close;  //Fenster wird geschlossen
end;

end.

