unit Keypass_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Eingabe_u, Data_Dialog_u, Math, libary_u;

type

  { TForm1 }

  TForm1 = class(TForm)
    Aktualisieren_B: TButton;
    Hinzufuegen_B: TButton;
    Label1: TLabel;
    Liste_L: TListBox;
    procedure Aktualisieren_BClick(Sender: TObject);
    procedure Hinzufuegen_BClick(Sender: TObject);
    procedure Liste_LClick(Sender: TObject);


  private

  public

  end;

var
  Form1: TForm1;

implementation


{$R *.lfm}

{ TForm1 }
procedure TForm1.Hinzufuegen_BClick(Sender: TObject);
begin
  Form2.showModal; //Fenster wird geöffnet
  Form2.Name_E.Text:= '';
  Form2.URL_E.Text:= '';
  Form2.Nutzername_E.Text:= '';
  Form2.Passwort_E.Text:= '';
end;

procedure TForm1.Liste_LClick(Sender: TObject);
var Item: string;
var buffer: TStringList;
begin
  if Not(Liste_L.ItemIndex = -1) then  //wenn etwas ausgewählt ist (ItemIndex = -1 -> nichts ist ausgewählt)
  begin
    Item := Liste_L.Items[Liste_L.ItemIndex];
    buffer := TStringList.Create;
    SplitText(' ', Item, buffer);
    Form3.Name_E.Text := buffer[0];   //Informationen werden in das Fenster eingetragen
    Form3.URL_E.Text := buffer[1];
    Form3.Nutzername_E.Text := buffer[2];
    Form3.Passwort_E.Text := buffer[3];
    Form3.Liste_L:= Liste_L;
    Form3.showModal;
  end;
end;

procedure TForm1.Aktualisieren_BClick(Sender: TObject);
var Index: TStringList;
var zaehler: integer;
var zaehler2: integer;
var Daten: TStringList;
var Datenverarbeitet: TStringList;
var buffer: string;
var bindecode: array of integer;
begin
  if (FileExists('C:\\Keypass\\index.txt')) then   //wenn der Index existiert
  begin
    Index:= TStringList.Create;
    Index.LoadFromFile('C:\\Keypass\\index.txt');
    Liste_L.Items.Clear;
    Daten:= TStringList.Create;
    Datenverarbeitet:= TStringList.Create;
    for zaehler:= 0 to Index.Count-1 do  //durchläuft die einzelnen Einträge
    begin
      Daten.LoadFromFile('C:\\Keypass\\' + Index[zaehler] + '.txt'); // Informationen eines einzelnen Eintrags werden hier in Daten gespeichert
      SetLength(bindecode, Floor(Length(Daten[0])/7));
      BinToDez(Daten[0], bindecode);  // Übersetzung von Binärsystem ins Dezimalsystem
      buffer:= '';
      for zaehler2:=0 to Length(bindecode)-2 do
      begin
        buffer+= Chr(bindecode[zaehler2]);  // Übersetzung in Zeichen
      end;

      SplitText('&', buffer, Datenverarbeitet); // Datenseperierung
      Liste_L.Items.Add(Datenverarbeitet[0] + ' ' + Datenverarbeitet[1] + ' ' + Datenverarbeitet[2] + ' ' + Datenverarbeitet[3]); // Daten werden in Liste dargestellt
    end;
  end;
end;


end.

