unit Keypass_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Eingabe_u;

type

  { TForm1 }

  TForm1 = class(TForm)
    Aktualisieren_B: TButton;
    Hinzufuegen_B: TButton;
    Liste_L: TListBox;
    procedure Aktualisieren_BClick(Sender: TObject);
    procedure Hinzufuegen_BClick(Sender: TObject);


  private

  public

  end;

var
  Form1: TForm1;

implementation


{$R *.lfm}

{ TForm1 }

procedure SplitText(Trenner: Char; const str: String; Output: TStringList);
begin
  Output.Delimiter := Trenner;
  Output.StrictDelimiter := True;
  Output.DelimitedText := str;
end;

procedure TForm1.Hinzufuegen_BClick(Sender: TObject);
begin
  Form2.showModal;
  Form2.Name_E.Text:= '';
  Form2.URL_E.Text:= '';
  Form2.Nutzername_E.Text:= '';
  Form2.Passwort_E.Text:= '';
end;

procedure TForm1.Aktualisieren_BClick(Sender: TObject);
var Index: TStringList;
var zaehler: integer;
var Daten: TStringList;
var Datenverarbeitet: TStringList;
var buffer: string;
begin
   if (FileExists('C:\\Keypass\\index.txt')) then
   begin
      Index:= TStringList.Create;
      Index.LoadFromFile('C:\\Keypass\\index.txt');
      Liste_L.Items.Clear;
      Daten:= TStringList.Create;
      Datenverarbeitet:= TStringList.Create;
      for zaehler:= 0 to Index.Count-1 do
      begin
         Daten.LoadFromFile('C:\\Keypass\\' + Index[zaehler] + '.txt');
         buffer:= Daten[0];
         SplitText('&', buffer, Datenverarbeitet);
         Liste_L.Items.Add(Datenverarbeitet[0] + '     ' + Datenverarbeitet[1] + '    ' + Datenverarbeitet[2]);
      end;
   end;
end;


end.

