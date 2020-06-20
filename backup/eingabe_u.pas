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
    Anmerkung_L: TLabel;
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
var Fehler: boolean;
var Output: string;
var zaehler: integer;
var Falsches_Zeichen: integer;
begin
  if Not(FileExists('C:\\Keypass\\Passwort.txt')) then //wenn die Datei Passwort.txt nicht existiert
  begin
    Form4.Zweck_L.Caption:= 'Passwort erstellen'; //ändert das Info-Label in Form4 (Passwortabfrage/eingabe)
    Form4.ShowModal;  //öffnet die Passwortabfrage/eingabe
  end;
  if (Passwort_public = '') or (Passwort_public = ' ') then  //wenn das passwort noch nicht eingegeben wurde
  begin
    Anmerkung_L.Caption := 'es wurde kein Passwort zur bestaetigung eingegeben';   //Fehlerausgabe
    Form4.Zweck_L.Caption:= 'Passwort abfrage';  //ändert das Info-Label in Form4 (Passwortabfrage/eingabe)
    Form4.showModal;  //öffnet die Passwortabfrage/eingabe
  end
  else
  begin
    Daten:= Name_E.Text + '&' + URL_E.Text + '&' + Nutzername_E.Text + '&' + Passwort_E.Text + '&'; //Daten werden von Fenster in Variable gespeichert
    Falsches_Zeichen:= 0;
    for zaehler:= 1 to length(Daten) do   //Durchläuft alle Zeichen von Daten
    begin
      if (Daten[zaehler] = '&') or (Daten[zaehler] = 'ä') then  //wenn das Zeichen & in Daten gefunden wird
      begin
        Falsches_Zeichen+=1;  //Zähl-Variable wird um 1 erhöht
      end;
    end;
    if Falsches_Zeichen <= 4 then   //wenn unter 5 & -Zeichen in Daten vorhanden sind
    begin
      Fehler:= false; //gibt an ob alles funktioniert hat
      Output:= '';  //genauere Fehlermeldung
      Speichern(Daten, Name_E.Text,Output, Fehler); //Daten werden gespeichert
      if Fehler = true then   //wenn es keinen Fehler gab
      begin
        Close;  //Fenster wird geschlossen
      end
      else //wenn es einen Fehler gab
      begin
        Anmerkung_L.Caption:= Output; //Fehlermeldung wird angezeigt
      end;
    end
    else //wenn 5 mal oder öfter das & -Zeichen genutzt wurde
    begin
      Anmerkung_L.Caption:= 'Das Zeichen && wird verwendet';  //Fehlermeldung
    end;
  end;
end;

procedure TForm2.Abbrechen_BClick(Sender: TObject);
begin
  Close;  //Fenster wird geschlossen
end;

end.

