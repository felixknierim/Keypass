unit Data_Dialog_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, libary_u, Passwortabfrage_u;

type

  { TForm3 }

  TForm3 = class(TForm)
    Loeschen_B: TButton;
    Fehler_L: TLabel;
    Zurueck_B: TButton;
    Speichern_B: TButton;
    Nutzername_L: TLabel;
    Passwort_L: TLabel;
    URL_E: TEdit;
    Nutzername_E: TEdit;
    Passwort_E: TEdit;
    URL_L: TLabel;
    Name_E: TEdit;
    Name_L: TLabel;
    procedure Loeschen_BClick(Sender: TObject);
    procedure Speichern_BClick(Sender: TObject);
    procedure Zurueck_BClick(Sender: TObject);
  private

  public
    Liste_L: TListBox; //Dient der Übergabe zwischen Keypass_u und Data_Dialog_u, weil es nicht möglich ist,dass zwei Forms sich gegenseitig bei uses verwenden
  end;

var
  Form3: TForm3;



implementation

{$R *.lfm}

{ TForm3 }


procedure TForm3.Zurueck_BClick(Sender: TObject);
begin
  Close;
end;

procedure TForm3.Speichern_BClick(Sender: TObject);
var Item: string;
var ausgewaehltes_Element: TStringList;
var Fehler: boolean;
var Daten: string;
var Output: string;
var zaehler: integer;
var falsches_Zeichen: integer;
begin
  //Ausgewähltes Element wird ermittelt
  if Not(Liste_L.ItemIndex = -1) then  //Wenn ein Element in der Liste ausgewählt wurde Liste_L.ItemIndex = -1 --> nicht wurde ausgewählt
  begin
    Item := Liste_L.Items[Liste_L.ItemIndex]; //Daten des Elements werden in Variable gespeichert
    ausgewaehltes_Element := TStringList.Create;
    SplitText(' ', Item, ausgewaehltes_Element); //Datenseperierung
    Eintrag_loeschen(ausgewaehltes_Element[0]); //alte Datei wird gelöscht mit Keys und index-Eintrag

    Fehler:= false;
    Output:= '';
    Daten:= Name_E.Text + '&' + URL_E.Text + '&' + Nutzername_E.Text + '&' + Passwort_E.Text + '&';

    Falsches_Zeichen:= 0;
    for zaehler:= 1 to length(Daten) do
    begin
      if Daten[zaehler] = '&' then
      begin
        Falsches_Zeichen+=1;
      end;
    end;

    if falsches_Zeichen <= 4 then
    begin
      if (Passwort_public = '') or (Passwort_public = ' ') then
      begin
        Fehler_L.Caption := 'es wurde kein Passwort zur bestaetigung eingegeben';
        Form4.Zweck_L.Caption:= 'Passwort abfrage';  //ändert das Info-Label in Form4 (Passwortabfrage/eingabe)
        Form4.showModal;  //öffnet die Passwortabfrage/eingabe
      end
      else
      begin
        Speichern(Daten, Name_E.Text,Output, Fehler); //überarbeitete Datei wird gespeichert
        if Fehler = true then    //wenn alles funktioniert hat
        begin
          Close;
        end
        else
        begin
          Fehler_L.Caption:= Output;  //Fehlerausgabe
        end;
      end;

      ausgewaehltes_Element.Free();

    end
    else
    begin
      Fehler_L.Caption:= 'Das Zeichen && wird verwendet';
    end;
  end;
end;

procedure TForm3.Loeschen_BClick(Sender: TObject);
var Item: string;
var ausgewaehltes_Element: TStringList;
begin
  if Not(Liste_L.ItemIndex = -1) then  //Wenn ein Element in der Liste ausgewählt wurde Liste_L.ItemIndex = -1 --> nicht wurde ausgewählt
  begin
    Item := Liste_L.Items[Liste_L.ItemIndex]; //Daten des Elements werden in Variable gespeichert
    ausgewaehltes_Element := TStringList.Create;
    SplitText(' ', Item, ausgewaehltes_Element); //Datenseperierung
    Eintrag_loeschen(ausgewaehltes_Element[0]);
    Close;
  end;
end;

end.

