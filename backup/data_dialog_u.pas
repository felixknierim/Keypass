unit Data_Dialog_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, libary_u;

type

  { TForm3 }

  TForm3 = class(TForm)
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
    procedure Speichern_BClick(Sender: TObject);
    procedure Zurueck_BClick(Sender: TObject);
  private

  public
    Liste_L: TListBox; //Dient der Übergabe
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
var buffer: TStringList;
var Index_alt: TStringlist;
var Index_neu: TStringList;
var zaehler: integer;
var NextAction: boolean;
var Daten: string;
var Output: string;
var Keys_alt: TStringList;
var Keys_neu: TStringList;
var buffer2: TStringList;
begin                                  //neue Index-Datei wird erstellt
  if Not(Liste_L.ItemIndex = -1) then  //Wenn ein Element in der Liste ausgewählt wurde Liste_L.ItemIndex = -1 --> nicht wurde ausgewählt
  begin
    Item := Liste_L.Items[Liste_L.ItemIndex]; //Daten des Elements werden in Variable gespeichert
    buffer := TStringList.Create;
    SplitText(' ', Item, buffer); //Datenseperierung
    if (FileExists('C:\\Keypass\\index.txt')) then   //wenn die Index-Datei existiert
    begin
      Index_alt:= TStringList.Create;
      Index_neu:= TStringList.Create;
      Index_alt.LoadFromFile('C:\\Keypass\\index.txt'); //Daten werden geladen
      for zaehler:=0 to Index_alt.Count-1 do     //durchläuft alle Elemente der Index - Datei
      begin
        if(Not(Index_alt[zaehler] = buffer[0])) then //wenn der Eintrag aus der alten Index-Datei nicht der geänderte Eintrag ist
        begin
          Index_neu.Add(Index_alt[zaehler]);    //alter Eintrag wird übernommen
        end
        else     //wenn es der überarbeitete Eintrag ist
        begin
          continue;      //der Neue Eintrag wird Automatisch bei speichern() im Index erstellt
        end;
      end;
      Index_neu.SaveToFile('C:\\Keypass\\index.txt'); //neue Index-Datei wird gespeichert
      DeleteFile('C:\\Keypass\\' + buffer[0] + '.txt');  //alte Datei wird gelöscht (Die Datei die Überarbeitet wird)

      Keys_alt := TStringList.Create;
      Keys_neu := TStringList.Create;
      buffer2 := TStringList.Create;
      Keys_alt.LoadFromFile('C:\\Keypass\\Keys.txt');
      for zaehler:=0 to Keys_alt.Count-1 do
      begin
        SplitText(':', Keys_alt[zaehler], buffer2);
        if Not(buffer2[0] = buffer[0]) then
        begin
          Keys_neu.Add(Keys_alt[zaehler]);
        end
        else
        begin
          continue;
        end;
      end;
      Keys_neu.SaveToFile('C:\\Keypass\\Keys.txt');

      NextAction:= false;
      Output:= '';
      Daten:= Name_E.Text + '&' + URL_E.Text + '&' + Nutzername_E.Text + '&' + Passwort_E.Text + '&';
      if (Passwort_public = '') or (Passwort_public = ' ') then
      begin
        Fehler_L.Caption := 'es wurde kein Passwort zur bestaetigung eingegeben';
      end
      else
      begin
        Speichern(Daten, Name_E.Text,Output, NextAction); //überarbeitete Datei wird gespeichert
        if NextAction = true then    //wenn alles funktioniert hat
        begin
          Close;
        end
        else
        begin
          Fehler_L.Caption:= Output;  //Fehlerausgabe
        end;
      end;
    end;
  end;
  Index_alt.Free();
  Index_neu.Free();
  buffer.Free();
end;

end.

