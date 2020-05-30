unit Data_Dialog_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    Label1: TLabel;
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
    Liste_L: TListBox;
  end;

var
  Form3: TForm3;



implementation

{$R *.lfm}

{ TForm3 }

procedure SplitText(Trenner: Char; const str: String; Output: TStringList);
begin
  Output.Delimiter := Trenner;
  Output.StrictDelimiter := True;
  Output.DelimitedText := str;
end;

function DezToBin(input: array of integer): String;
var zaehler: integer;
var zaehler2: integer;
var buffer: array[0..6] of integer;
var zwischenergebnis: string;
begin
  zwischenergebnis := '';
  buffer[6]:= 0;
  for zaehler:=1 to Length(input) do  //für jede Nummer des Buchstaben
  begin
    zaehler2 := 0;
    buffer[0]:= 0;
    buffer[1]:= 0;
    buffer[2]:= 0;
    buffer[3]:= 0;
    buffer[4]:= 0;
    buffer[5]:= 0;
    buffer[6]:= 0;
    while Not(input[zaehler] = 0) do   // zu Binaercode, Ergebnis in buffer bloß Rueckwaerts
    begin
      buffer[zaehler2] := input[zaehler] mod 2;
      input[zaehler] := trunc(input[zaehler] / 2);
      zaehler2 += 1;
    end;
    for zaehler2:=Length(buffer)-1 downto 0 do
    begin
      zwischenergebnis += IntToStr(buffer[zaehler2]);  //Ergebnis für ein Zeichen wird richtigrum in String gebracht
    end;
  end;

  DezToBin := zwischenergebnis; //Rueckgabewert

end;

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
//auslagern
var Stringlist: TStringList;
var Buffer2: TStringList;
var zaehler2: integer;
var Daten: string;
var ASCII_Code: array of integer;
var Bin_Code: String;
//
begin
  if Not(Liste_L.ItemIndex = -1) then
  begin
     Item := Liste_L.Items[Liste_L.ItemIndex];
     buffer := TStringList.Create;
     SplitText(' ', Item, buffer);
     if (FileExists('C:\\Keypass\\index.txt')) then
     begin
      Index_alt:= TStringList.Create;
      Index_neu:= TStringList.Create;
      Index_alt.LoadFromFile('C:\\Keypass\\index.txt');
      for zaehler:=0 to Index_alt.Count-1 do
      begin
        if(Not(Index_alt[zaehler] = buffer[0])) then
        begin
         Index_neu.Add(Index_alt[zaehler]);
        end
        else
        begin
          continue;
        end;
      end;
      Index_neu.Add(Name_E.Text);
      Index_neu.SaveToFile('C:\\Keypass\\index.txt');
      DeleteFile('C:\\Keypass\\' + buffer[0] + '.txt');



  //auslagern
  Daten:= Name_E.Text + '&' + URL_E.Text + '&' + Nutzername_E.Text + '&' + Passwort_E.Text + '&';
  SetLength(ASCII_Code, Length(Daten));
  for zaehler2:=0 to Length(Daten) do
  begin
    ASCII_Code[zaehler2] := ord(Daten[zaehler2]);
  end;

  Bin_Code:= DezToBin(ASCII_Code);
  {TODO Verschlüsselung einfügen }
  Stringlist:= TStringList.Create;
  StringList.Add(Bin_Code);
  if Not(DirectoryExists('C:\\Keypass')) then
    CreateDir('C:\\Keypass');
  if Not(FileExists('C:\\Keypass\\' + Name_E.Text + '.txt')) then
  begin
    Stringlist.SaveToFile('C:\\Keypass\\' + Name_E.Text + '.txt');
    Buffer2:= TStringList.Create;
    Close;
  end
  else
  begin
    Label1.Caption:= 'Fehler: Dateiname existiert schon.' + #10#13 + 'Geben sie dem Eintrag einen anderen Namen';
  end;



     end;
  end;

end;

end.

