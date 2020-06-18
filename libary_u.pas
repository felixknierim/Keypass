unit libary_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Math;

procedure SplitText(Trenner: Char; str: String; var Output: TStringList);
procedure BinToDez(input: String; var bufferdez: array of integer);
function DezToBin(input: array of integer): String;
procedure speichern(Daten: String; Name: String; var Output: String; var NextAction: boolean);
function encrypt(Daten: string; Schluessel: string): string;
function BinXor(bin1: integer; bin2: integer): integer;
function decrypt(Daten: string; Key: string): string;
procedure Eintrag_loeschen(Name:string);

var Passwort_public: string;


implementation

procedure SplitText(Trenner: Char; str: String; var Output: TStringList);
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
    bufferbin[zaehler-1] := StrToInt(input[zaehler]);  //alle Zahlen von input in bufferbin gespeichert bloß als integer
  end;

  zaehler:=1;
  while (zaehler <= Length(bufferbin) ) do
  begin
    bufferdez[Floor(zaehler/7)]:= 0;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler-1] *2**6;   //Übersetzung von Binärenzahlen in Dezimalzahlen zaehler-1 damit es bei bufferbin[0] anfängt
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler] *2**5;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+1] *2**4;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+2] *2**3;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+3] *2**2;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+4] *2**1;
    bufferdez[Floor(zaehler/7)] += bufferbin[zaehler+5] *2**0;

    zaehler += 7; //ein Zeichen wird in 7 bit gespeichert also hier ein Zeichen weiter (eigentlich sind es immer 8 bit aber ich habe hier 7 bit verwendet, weil hier keine 8 bit benötigt werden
  end;
  bufferbin := Nil;
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
    zaehler2 := 0; //reset der Variablen
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
var zaehler: integer;
var ASCII_Code: array of integer;
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
  {Verschlüsselung}
  generated_key:= '';
  for zaehler:=0 to Length(Bin_Code)-1 do
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
  {Verschlüsselung end}
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
  Stringlist.Free();
  Index.Free();
  Buffer.Free();
  Schluessel.Free();
  ASCII_Code := Nil;
end;

function encrypt(Daten: string; Schluessel: string): string;  //verschlüsselt Daten mit Schluessel
var zaehler: integer;
var verschluesselte_Daten: string;
var buffer1, buffer2: integer;
begin
  verschluesselte_Daten:= '';
  if (Length(Daten) <= Length(Schluessel)) then
  begin
    for zaehler:=1 to Length(Daten) do  //zaehler:=1 weil das nullte Element eines Strings nicht auslesbar ist, durchläuft alle Zeichen von Daten
    begin
      buffer1:= StrToInt(Daten[zaehler]);  //als Zahl speichern
      buffer2:= StrToInt(Schluessel[zaehler]);  //als Zahl speichern
      verschluesselte_Daten += IntToStr(BinXor(buffer1, buffer2));  //die beiden Zahlen werden mit operator XOR bearbeitet und an einen String angehängt
    end;
    encrypt:= verschluesselte_Daten;      //Rückgabe des Ergebnisses
  end
  else
  begin
    encrypt:= encrypt(Daten, schluessel + schluessel);
  end;
end;

function BinXor(bin1: integer; bin2: integer): integer;    //gibt den XOR Wert von zwei zahlen zurück nur 0 und 1 möglich
begin
  if((bin1 = 0) and (bin2 = 0)) or ((bin1 = 1) and (bin2 = 1)) then //wenn beide zahlen den gleichen Wert haben
  begin
    BinXor:= 0;
  end
  else if ((bin1 = 1) and (bin2 = 0)) or ((bin1 = 0) and (bin2 = 1)) then   //wenn dei Zahlen unterschiedliche Werte haben
  begin
    BinXor:= 1;
  end;
end;

function decrypt(Daten: string; Key: string): string;  //entschlüsselt Daten mit Key, macht im Prinzip genau das gleiche wie encrypt
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
  end
  else
  begin
    decrypt:= decrypt(Daten, Key + Key);
  end;
end;

procedure Eintrag_loeschen(Name: string);
var index_alt: TStringList;
var index_neu: TStringList;
var zaehler: integer;
var Keys_alt: TStringList;
var Keys_neu: TStringList;
var buffer2: TStringList;
begin
  if (FileExists('C:\\Keypass\\index.txt')) then   //wenn die Index-Datei existiert
  begin
    Index_alt:= TStringList.Create;
    Index_neu:= TStringList.Create;
    Index_alt.LoadFromFile('C:\\Keypass\\index.txt'); //Daten werden geladen
    for zaehler:=0 to Index_alt.Count-1 do     //durchläuft alle Elemente der Index - Datei
    begin
      if(Not(Index_alt[zaehler] = Name)) then //wenn der Eintrag aus der alten Index-Datei nicht der geänderte Eintrag ist
      begin
        Index_neu.Add(Index_alt[zaehler]);    //alter Eintrag wird übernommen
      end
      else     //wenn es der überarbeitete Eintrag ist
      begin
        continue;      //der Neue Eintrag wird Automatisch bei speichern() im Index erstellt
      end;
    end;
    Index_neu.SaveToFile('C:\\Keypass\\index.txt'); //neue Index-Datei wird gespeichert
    DeleteFile('C:\\Keypass\\' + Name + '.txt');  //alte Datei wird gelöscht (Die Datei die Überarbeitet wird)

    Keys_alt := TStringList.Create;
      Keys_neu := TStringList.Create;
      buffer2 := TStringList.Create;
      Keys_alt.LoadFromFile('C:\\Keypass\\Keys.txt');
      for zaehler:=0 to Keys_alt.Count-1 do
      begin
        SplitText(':', Keys_alt[zaehler], buffer2);
        if Not(buffer2[0] = Name) then
        begin
          Keys_neu.Add(Keys_alt[zaehler]);
        end
        else
        begin
          continue;
        end;
      end;
      Keys_neu.SaveToFile('C:\\Keypass\\Keys.txt');

    Index_alt.free;
    Index_neu.free;
    Keys_alt.free;
    Keys_neu.free;
    buffer2.free;
  end;
end;

end.

