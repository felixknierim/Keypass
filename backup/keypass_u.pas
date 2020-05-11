unit Keypass_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Eingabe_u, Data_Dialog_u, Math;

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

procedure BinToDez(input: String; var bufferdez: array of integer);
var bufferbin: array of integer;
var test: integer;
var zaehler: integer;
begin
  zaehler:=0;
  SetLength(bufferbin, Length(input));
  for zaehler:=1 to Length(input) do
  begin
     if Not(input[zaehler] = '-') then
     bufferbin[zaehler] := StrToInt(input[zaehler]);
  end;

  zaehler:=1;
  while (zaehler <= Length(bufferbin) -7) do
  begin
    test:= Floor(zaehler/7);
    bufferdez[Floor(zaehler/7)]:= 0;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler] *2**6;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+1] *2**5;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+2] *2**4;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+3] *2**3;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+4] *2**2;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+5] *2**1;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+6] *2**0;

    zaehler += 7;
  end;
end;

procedure SplitText(Trenner: Char; const str: String; Output: TStringList);
begin
  Output.Delimiter := Trenner;
  Output.StrictDelimiter := True;
  Output.DelimitedText := str;
end;

procedure TForm1.Hinzufuegen_BClick(Sender: TObject);
var test: array[0..6] of integer;
begin
  Form2.showModal;
  Form2.Name_E.Text:= '';
  Form2.URL_E.Text:= '';
  Form2.Nutzername_E.Text:= '';
  Form2.Passwort_E.Text:= '';

end;

procedure TForm1.Liste_LClick(Sender: TObject);
var Item: string;
var buffer: TStringList;
begin
  if Not(Liste_L.ItemIndex = -1) then
  begin
     Item := Liste_L.Items[Liste_L.ItemIndex];
     buffer := TStringList.Create;
     SplitText(' ', Item, buffer);
     Form3.Name_E.Text := buffer[0];
     Form3.URL_E.Text := buffer[1];
     Form3.Nutzername_E.Text := buffer[2];
     Form3.Passwort_E.Text := buffer[3];
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
         SetLength(bindecode, Floor(Length(Daten[0])/7));
         BinToDez(Daten[0], bindecode);
         buffer:= '';
         for zaehler2:=0 to Length(bindecode)-1 do
         begin
         buffer+= Chr(bindecode[zaehler2]);
         end;



         SplitText('&', buffer, Datenverarbeitet);
         Liste_L.Items.Add(Datenverarbeitet[0] + ' ' + Datenverarbeitet[1] + ' ' + Datenverarbeitet[2] + ' ' + Datenverarbeitet[3]);


      end;
   end;
end;


end.

