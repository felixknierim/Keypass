unit Keypass_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Eingabe_u, Eintrag_bearbeiten_u, Math, libary_u, Passwortabfrage_u;  //Zusätzliche Forms und eigene Bibliothek importiert

type

  { TForm1 }

  TForm1 = class(TForm)
    Aktualisieren_B: TButton;
    Beenden_B: TButton;
    Hinzufuegen_B: TButton;
    Liste_L: TListBox;
    procedure Aktualisieren_BClick(Sender: TObject);
    procedure Beenden_BClick(Sender: TObject);
    procedure Hinzufuegen_BClick(Sender: TObject);
    procedure Liste_LClick(Sender: TObject);
    procedure Activate; override;


  private


  public

  end;

var
  Form1: TForm1;

implementation


{$R *.lfm}

{ TForm1 }
procedure TForm1.Activate;   //wird ausgeführt wenn sich das Fenster öffnet
begin
  inherited Activate;  //erbt den Standartmäßig festgelegten teil der Activate funktion und wird ergänzt
  if Not(DirectoryExists('C:\\Keypass')) then //wenn das Verzeichnis Keypass nicht existiert
    CreateDir('C:\\Keypass');  //Verzeichnis wird erstellt

  if FileExists('C:\\Keypass\\Passwort.txt') then //wenn die Datei Passwort.txt existiert
  begin
    Form4.Zweck_L.Caption:= 'Passwort abfrage';  //ändert das Info-Label in Form4 (Passwortabfrage/eingabe)
    Form4.showModal;  //öffnet die Passwortabfrage/eingabe
  end;
end;

procedure TForm1.Hinzufuegen_BClick(Sender: TObject);
begin
  Form2.showModal; //Fenster wird geöffnet

  //Setzt Eingaben von möglichen vorherigen Eingaben zurück
  Form2.Name_E.Text:= '';
  Form2.URL_E.Text:= '';
  Form2.Nutzername_E.Text:= '';
  Form2.Passwort_E.Text:= '';
end;

procedure TForm1.Liste_LClick(Sender: TObject);
var Item: string;
var geteilter_Eintrag: TStringList;
begin
  if Not(Liste_L.ItemIndex = -1) then  //wenn etwas ausgewählt ist (ItemIndex = -1 -> nichts ist ausgewählt)
  begin
    Item := Liste_L.Items[Liste_L.ItemIndex];  //einzelner Eintrag wir in Item gespeichert
    geteilter_Eintrag := TStringList.Create;
    SplitText(' ', Item, geteilter_Eintrag);   //Eintrag wird zerteilt

    //Informationen werden in das Fenster eingetragen
    Form3.Name_E.Text := geteilter_Eintrag[0];
    Form3.URL_E.Text := geteilter_Eintrag[1];
    Form3.Nutzername_E.Text := geteilter_Eintrag[2];
    Form3.Passwort_E.Text := geteilter_Eintrag[3];
    Form3.Liste_L:= Liste_L;  //Liste von Form1 wird an Form3 übergeben

    Form3.showModal;         //Form3 zeigt sich
    geteilter_Eintrag.Free();           //Freigabe des Arbeitsspeichers
  end;
end;

procedure TForm1.Aktualisieren_BClick(Sender: TObject);
var Index: TStringList;
var zaehler: integer;
var zaehler2: integer;
var Daten: TStringList;
var Datenverarbeitet: TStringList;
var Datentext: string;
var bindecode: array of integer;
var Keys: TStringlist;
var getrennter_Key: TStringList;
begin
  if (FileExists('C:\\Keypass\\index.txt')) then   //wenn die Index-Daatei existiert
  begin
    Index:= TStringList.Create;
    Index.LoadFromFile('C:\\Keypass\\index.txt'); //Index-Einträge werden geladen
    Liste_L.Items.Clear;  //alte Einträge in der Liste des GUI werden gelöscht
    Daten:= TStringList.Create;
    Datenverarbeitet:= TStringList.Create;

    if Not(index.Count <= 0) then    //wenn es überhaupt Einträge gibt
    begin
      for zaehler:= 0 to Index.Count-1 do  //durchläuft die einzelnen Einträge
      begin
        Daten.LoadFromFile('C:\\Keypass\\' + Index[zaehler] + '.txt'); // Informationen eines einzelnen Eintrags werden hier in Daten gespeichert
        SetLength(bindecode, Floor(Length(Daten[0])/7));   //wird auf die richtige Länge gebracht
        Keys := TStringList.Create;
        Keys.LoadFromFile('C:\\Keypass\\Keys.txt');  //lädt die Schlüssel aus Datei
        getrennter_Key:= TStringList.Create;

        for zaehler2:=0 to Keys.Count-1 do       //Keys.Count-1 weil man bei 0 anfängt zu Zählen        durchläuft alle Elemente von Keys
        begin
          SplitText(':',Keys[zaehler2], getrennter_Key);  //Informationen werden aufgeteilt getrennter_Key[0]->Dateiname, getrennter_Key[1]->verschlüsselter Schlüssel
          if getrennter_Key[0] = Index[zaehler] then      //überprüfung ob es der passende Schlüssel ist
          begin;
            getrennter_Key[1] := decrypt(getrennter_Key[1], Passwort_public);  //Schlüssel wird mit Passwort der Benutzers entschlüsselt
            Daten[0]:= decrypt(Daten[0], getrennter_Key[1]);   //Eintrag wird mit entschlüsseltem Schlüssel entschlüsselt
          end;
        end;

        BinToDez(Daten[0], bindecode);  // Übersetzung von Binärsystem ins Dezimalsystem
        Datentext:= '';
        for zaehler2:=0 to Length(bindecode)-1 do  //durchläuft alle Elemente von bindecode
        begin
          Datentext+= Chr(bindecode[zaehler2]);  // Übersetzung in Zeichen -> zeichen werden an das Ende der Zeichenkette von Datentext immer drangehängt
        end;

        SplitText('&', Datentext, Datenverarbeitet); // Datenseperierung -> in Datenverarbeitet[x] ist jeweils eine Information (Name, URL, benutzername, passwort)
        Liste_L.Items.Add(Datenverarbeitet[0] + ' ' + Datenverarbeitet[1] + ' ' + Datenverarbeitet[2] + ' ' + Datenverarbeitet[3]); // Daten werden in Liste dargestellt   durch Leerzeichen getrennt

        Keys.Free(); //Freigabe des Arbeitsspeichers
        getrennter_Key.Free();  //Arbeitsspeicher wird freigegeben
      end;
    end
    else  //wenn es keine Einträge gibt
    begin
      Liste_L.Items.Add('Keine Einträge gefunden');  //Fehlermeldung wird in Liste ausgegeben
    end;
    Index.Free(); //Arbeitsspeicher wird freigegeben
    Daten.Free();
    Datenverarbeitet.Free();
  end;
end;

procedure TForm1.Beenden_BClick(Sender: TObject);
begin
  Application.Terminate;  //Programm wird beendet
end;


end.

