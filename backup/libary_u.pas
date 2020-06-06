unit libary_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Math;

procedure SplitText(Trenner: Char; const str: String; Output: TStringList);
procedure BinToDez(input: String; var bufferdez: array of integer);
function DezToBin(input: array of integer): String;
procedure speichern(Daten: String; Name: String; var Output: String; var NextAction: boolean);

implementation

procedure SplitText(Trenner: Char; const str: String; Output: TStringList);
begin
  Output.Delimiter := Trenner;  //Trennzeichen wird festgelegt
  Output.StrictDelimiter := True;
  Output.DelimitedText := str; //Texteingabe
end;

procedure BinToDez(input: String; var bufferdez: array of integer);   //von Binärzahlen zu Dezimalzahlen
var bufferbin: array of integer;
var zaehler: integer;
begin
  zaehler:=0;
  SetLength(bufferbin, Length(input));
  for zaehler:=1 to Length(input) do    //zaehler:=1 weil das erste Zeichen einer Zeichenkette nicht auslesbar ist
  begin
    if Not(input[zaehler] = '-') then
      bufferbin[zaehler] := StrToInt(input[zaehler]);  //alle Zahlen von input in bufferbin gespeichert bloß als integer
  end;

  zaehler:=1;
  while (zaehler <= Length(bufferbin) ) do
  begin
    bufferdez[Floor(zaehler/7)]:= 0;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler] *2**6;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+1] *2**5;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+2] *2**4;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+3] *2**3;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+4] *2**2;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+5] *2**1;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+6] *2**0;

    zaehler += 7; //ein Zeichen wird in 7 bit gespeichert also hier ein Zeichen weiter
  end;
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

procedure speichern(Daten: String; Name: String; var Output: String; var NextAction: boolean);
var Stringlist: TStringList;
var Index: TStringList;
var Buffer: TStringList;
var zaehler: integer;var ASCII_Code: array of integer;
var Bin_Code: String;
begin
  NextAction:= false;
  SetLength(ASCII_Code, Length(Daten));
  for zaehler:=0 to Length(Daten) do
  begin
    ASCII_Code[zaehler] := ord(Daten[zaehler]);
  end;

  Bin_Code:= DezToBin(ASCII_Code);
  {Verschlüsselung einfügen TODO}
  Stringlist:= TStringList.Create;
  StringList.Add(Bin_Code);
  if Not(DirectoryExists('C:\\Keypass')) then
    CreateDir('C:\\Keypass');
  if Not(FileExists('C:\\Keypass\\' + Name + '.txt')) then
  begin
    Stringlist.SaveToFile('C:\\Keypass\\' + Name + '.txt');
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
    Index.Add(Name);
    Index.SaveToFile('C:\\Keypass\\index.txt');
    NextAction:= true;
  end
  else
  begin
    Output:= 'Fehler: Dateiname existiert schon.' + #10#13 + 'Geben sie dem Eintrag einen anderen Namen';
  end;
end;

end.

