unit libary_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Math;

procedure SplitText(Trenner: Char; const str: String; Output: TStringList);
procedure BinToDez(input: String; var bufferdez: array of integer);
function DezToBin(input: array of integer): String;
procedure speichern(Daten: String; Name: String; var Output: String; var NextAction: boolean);
function encrypt(Daten: string; Schluessel: string): string;
function BinXor(bin1: integer; bin2: integer): integer;
function decrypt(Daten: string; Key: string): string;

var Passwort_public: string;

implementation

procedure SplitText(Trenner: Char; const str: String; Output: TStringList);
begin
  Output.Delimiter := Trenner;  //Trennzeichen wird festgelegt
  Output.StrictDelimiter := True;
  Output.DelimitedText := str; //Texteingabe und Seperierung
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
      bufferbin[zaehler-1] := StrToInt(input[zaehler]);  //alle Zahlen von input in bufferbin gespeichert bloß als integer
  end;

  zaehler:=1;
  while (zaehler <= Length(bufferbin) ) do
  begin
    bufferdez[Floor(zaehler/7)]:= 0;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler-1] *2**6;   //Übersetzung von Binärenzahlen in Dezimalzahlen
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler] *2**5;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+1] *2**4;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+2] *2**3;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+3] *2**2;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+4] *2**1;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+5] *2**0;

    zaehler += 7; //ein Zeichen wird in 7 bit gespeichert also hier ein Zeichen weiter (eigentlich sind es immer 8 bit aber ich habe hier 7 bit verwendet, weil hier keine 8 bit benötigt werden
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
    while Not(input[zaehler-1] = 0) do   // zu Binaercode, Ergebnis in buffer bloß Rueckwaerts
    begin
      buffer[zaehler2] := input[zaehler-1] mod 2;
      input[zaehler-1] := trunc(input[zaehler-1] / 2);
      zaehler2 += 1;
    end;
    for zaehler2:=Length(buffer)-1 downto 0 do
    begin
      zwischenergebnis += IntToStr(buffer[zaehler2]);  //Ergebnis für ein Zeichen wird richtigrum in String gebracht
    end;
  end;
  DezToBin := zwischenergebnis; //Rueckgabewert
end;

procedure speichern(Daten: String; Name: String; var Output: String; var NextAction: boolean); //speichert Einträge in Datei
var Stringlist: TStringList;
var Index: TStringList;
var Buffer: TStringList;
var zaehler: integer;var ASCII_Code: array of integer;
var Bin_Code: String;
var generated_key: string;
var verschluesselte_Daten: string;
var Schluessel: TStringList;
begin

  NextAction:= false;
  SetLength(ASCII_Code, Length(Daten));
  for zaehler:=1 to Length(Daten) do
  begin
    ASCII_Code[zaehler-1] := ord(Daten[zaehler]);  //Übersetzung von Buchstaben in Dezimalzahlen
  end;

  Bin_Code:= DezToBin(ASCII_Code);  //Übersettzung in Binärcode
  {Verschlüsselung einfügen TODO}
  generated_key:= '';
  for zaehler:=0 to Length(Bin_Code) do
  begin
    generated_key += IntToStr(random(2));
  end;

  verschluesselte_Daten := encrypt(Bin_Code, generated_key);

  //schlüssel speichern
  if Not(FileExists('C:\\Keypass\\' + Name + '.txt')) then
  begin
    Schluessel:= TStringList.Create;
    if FileExists('C:\\Keypass\\Keys.txt') then
      Schluessel.LoadFromFile('C:\\Keypass\\Keys.txt');
    Schluessel.Add(Name + ':' + encrypt(generated_key,Passwort_public));
    Schluessel.SaveToFile('C:\\Keypass\\Keys.txt');
  end;
  {Verschlüsselung einfügen TODO end}
  Stringlist:= TStringList.Create;
  StringList.Add(verschluesselte_Daten);
  if Not(DirectoryExists('C:\\Keypass')) then //wenn das Verzeichnis Keypass nicht existiert
    CreateDir('C:\\Keypass');
  if Not(FileExists('C:\\Keypass\\' + Name + '.txt')) then
  begin
    Stringlist.SaveToFile('C:\\Keypass\\' + Name + '.txt'); //speichert Daten in Datei
    Index:= TStringList.Create;
    Buffer:= TStringList.Create;
    //erstellt Eintrag in der Index-Datei
    if FileExists('C:\\Keypass\\Index.txt') then  //wenn Index-Datei existiert
    begin
      Buffer.LoadFromFile('C:\\Keypass\\index.txt'); //Lädt Daten von der Index-Datei
      for zaehler:=0 to Buffer.Count-1 do
      begin
        Index.Add(Buffer[zaehler]);
      end;
    end;
    Index.Add(Name);  //neuer Eintrag wir Hinzugefügt
    Index.SaveToFile('C:\\Keypass\\index.txt'); //Index wird überschrieben
    NextAction:= true;
  end
  else
  begin
    NextAction:= false;
    Output:= 'Fehler: Dateiname existiert schon.' + #10#13 + 'Geben sie dem Eintrag einen anderen Namen';
  end;
end;

function encrypt(Daten: string; Schluessel: string): string;
var zaehler: integer;
var verschluesselte_Daten: string;
var buffer1, buffer2: integer;
begin
  verschluesselte_Daten:= '';
  if (Length(Daten) <= Length(Schluessel)) then
  begin
    for zaehler:=1 to Length(Daten) do
    begin
      buffer1:= StrToInt(Daten[zaehler]);
      buffer2:= StrToInt(Schluessel[zaehler]);
      verschluesselte_Daten += IntToStr(BinXor(buffer1, buffer2));
    end;
    encrypt:= verschluesselte_Daten;
  end;
end;

function BinXor(bin1: integer; bin2: integer): integer;
begin
  if((bin1 = 0) and (bin2 = 0)) or ((bin1 = 1) and (bin2 = 1)) then
  begin
    BinXor:= 0;
  end
  else if ((bin1 = 1) and (bin2 = 0)) or ((bin1 = 0) and (bin2 = 1)) then
  begin
    BinXor:= 1;
  end;
end;

function decrypt(Daten: string; Key: string): string;
var zaehler: integer;
var zwischenergebnis: string;
begin
  zwischenergebnis:= '';
  if Length(Daten) <= Length(Key) then
  begin
    for zaehler:=1 to Length(Daten) do
    begin
      zwischenergebnis+= IntToStr(BinXor(StrToInt(Daten[zaehler]), StrToInt(Key[zaehler])));
    end;
    decrypt := zwischenergebnis;
  end;
end;



end.

