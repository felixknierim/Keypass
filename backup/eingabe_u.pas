unit Eingabe_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Abbrechen_B: TButton;
    Hinzufuegen_B: TButton;
    Fehler_L: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Test_L: TLabel;
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
    //function DezToBin(input: array of integer): String;
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }
function DezToBin(input: array of integer): String;
var zaehler: integer;
var zaehler2: integer;
var buffer: array[0..6] of integer;
var zwischenergebnis: string;
begin
  zwischenergebnis := '';
  Form2.Test_L.Caption:= IntToStr(Length(input));
  buffer[6]:= 0;
  for zaehler:=1 to Length(input) do  //für jede Nummer des Buchstaben
  begin
    zaehler2 := 0;
    if(zaehler = 7) then
    Form2.Label7.Caption:= IntToStr(input[zaehler]);
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

procedure TForm2.Hinzufuegen_BClick(Sender: TObject);
var Stringlist: TStringList;
var Index: TStringList;
var Buffer: TStringList;
var zaehler: integer;
var Daten: string;
var ASCII_Code: array of integer;
var Bin_Code: String;

begin
  Daten:= Name_E.Text + '&' + URL_E.Text + '&' + Nutzername_E.Text + '&' + Passwort_E.Text;
  SetLength(ASCII_Code, Length(Daten));
  for zaehler:=0 to Length(Daten) do
  begin
    ASCII_Code[zaehler] := ord(Daten[zaehler]);
  end;
  Label1.Caption:= IntToStr(ASCII_Code[Length(ASCII_Code)-5]);
  Label2.Caption:= IntToStr(ASCII_Code[Length(ASCII_Code)-4]);
  Label3.Caption:= IntToStr(ASCII_Code[Length(ASCII_Code)-3]);
  Label4.Caption:= IntToStr(ASCII_Code[Length(ASCII_Code)-2]);
  Label5.Caption:= IntToStr(ASCII_Code[Length(ASCII_Code)-1]);
  Label6.Caption:= IntToStr(ASCII_Code[Length(ASCII_Code)]);

  Bin_Code:= DezToBin(ASCII_Code);
  {Verschlüsselung einfügen ASCII[32] bis ASCII[127]}
  Stringlist:= TStringList.Create;
  {Stringlist.Add(Name_E.Text + '&' + URL_E.Text + '&' + Nutzername_E.Text + '&' + Passwort_E.Text);}
  StringList.Add(Bin_Code);
  if Not(DirectoryExists('C:\\Keypass')) then
    CreateDir('C:\\Keypass');
  if Not(FileExists('C:\\Keypass\\' + Name_E.Text + '.txt')) then
  begin
    Stringlist.SaveToFile('C:\\Keypass\\' + Name_E.Text + '.txt');
    Index:= TStringList.Create;
    Buffer:= TStringList.Create;
    if FileExists('C:\\Keypass\\Index.txt') then
    begin
      Buffer.LoadFromFile('C:\\Keypass\\index.txt');
      for zaehler:=0 to Buffer.Count-1 do
      begin
        Index.Add(Buffer[zaehler]);
      end;
    end;
    Index.Add(Name_E.Text);
    Index.SaveToFile('C:\\Keypass\\index.txt');
    //Close;
  end
  else
  begin
    Fehler_L.Caption:= 'Fehler: Dateiname existiert schon.' + #10#13 + 'Geben sie dem Eintrag einen anderen Namen';
  end;
end;

procedure TForm2.Abbrechen_BClick(Sender: TObject);
begin
  Close;
end;

end.

