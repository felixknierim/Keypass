unit libary_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Math;

procedure SplitText(Trenner: Char; str: String; var Output: TStringList);
procedure BinToDez(input: String; var Zwischenspeicher_dez: array of integer);
function DezToBin(input: array of integer): String;
procedure speichern(Daten: String; Name: String; var Output: String; var Fehler: boolean);
function encrypt(Daten: string; Key: string): string;
function BinXor(binaer1: integer; binaer2: integer): integer;
function decrypt(Daten: string; Key: string): string;
procedure Eintrag_loeschen(Name:string);

var Passwort_public: string;


implementation

procedure SplitText(Trenner: Char; str: String; var Output: TStringList);
begin
  Output.Delimiter := Trenner;  //Trennzeichen wird festgelegt
  Output.StrictDelimiter := True; //Ansonsten sind noch andere Zeichen Delimiter
  Output.DelimitedText := str; //Texteingabe und Seperierung
end;

procedure BinToDez(input: String; var Zwischenspeicher_dez: array of integer);   //von Binärzahlen zu Dezimalzahlen
var Zwischenspeicher_bin: array of integer;
var zaehler: integer;
begin
  zaehler:=0;
  SetLength(Zwischenspeicher_bin, Length(input));  //Länge wird an input angepasst

  for zaehler:=1 to Length(input) do    //zaehler:=1 weil das erste Zeichen einer Zeichenkette nicht auslesbar ist
  begin
    Zwischenspeicher_bin[zaehler-1] := StrToInt(input[zaehler]);  //alle Zahlen von input in Zwischenspeicher_bin gespeichert bloß als integer
  end;

  zaehler:=1;
  while (zaehler <= Length(Zwischenspeicher_bin) ) do  //solange der Zähler-Variable kleiner ist als Zwischenspeicher_bin
  begin
    Zwischenspeicher_dez[Floor(zaehler/7)]:= 0;  //Reset         ein Zeichen -> 7 bit  Florr(zaehler/7) damit immer der gleiche Eintrag benutzt wird

    Zwischenspeicher_dez[Floor(zaehler/7)] += Zwischenspeicher_bin[zaehler-1] *2**6;   //Übersetzung von Binärenzahlen in Dezimalzahlen zaehler-1 damit es bei bufferbin[0] anfängt
    Zwischenspeicher_dez[Floor(zaehler/7)] += Zwischenspeicher_bin[zaehler] *2**5;
    Zwischenspeicher_dez[Floor(zaehler/7)] += Zwischenspeicher_bin[zaehler+1] *2**4;
    Zwischenspeicher_dez[Floor(zaehler/7)] += Zwischenspeicher_bin[zaehler+2] *2**3;
    Zwischenspeicher_dez[Floor(zaehler/7)] += Zwischenspeicher_bin[zaehler+3] *2**2;
    Zwischenspeicher_dez[Floor(zaehler/7)] += Zwischenspeicher_bin[zaehler+4] *2**1;
    Zwischenspeicher_dez[Floor(zaehler/7)] += Zwischenspeicher_bin[zaehler+5] *2**0;

    zaehler += 7; //ein Zeichen wird in 7 bit gespeichert also hier ein Zeichen weiter (eigentlich sind es immer 8 bit aber ich habe hier 7 bit verwendet, weil hier keine 8 bit benötigt werden
  end;
  Zwischenspeicher_bin := Nil;   //Arbeitsspeicher wird freigegeben
end;

function DezToBin(input: array of integer): String;  //Dezimalzahlen zu Binärzahlen
var zaehler: integer;
var zaehler2: integer;
var Zwischenspeicher: array[0..6] of integer;
var zwischenergebnis: string;
begin
  zwischenergebnis := '';

  for zaehler:=0 to Length(input)-1 do  //für jede Nummer des Buchstaben
  begin
    zaehler2 := 0; //reset der Variablen
    Zwischenspeicher[0]:= 0;
    Zwischenspeicher[1]:= 0;
    Zwischenspeicher[2]:= 0;
    Zwischenspeicher[3]:= 0;
    Zwischenspeicher[4]:= 0;
    Zwischenspeicher[5]:= 0;
    Zwischenspeicher[6]:= 0;

    while Not(input[zaehler] = 0) do   // zu Binaercode, Ergebnis in Zwischenspeicher bloß Rueckwaerts     solange ausgewählte Zahl nicht 0 ist
    begin
      Zwischenspeicher[zaehler2] := input[zaehler] mod 2; //inputzahl wird modulo 2 genommen die Stellen werden auf die verschiedenen Zwischenspeicher verteilt
      input[zaehler] := trunc(input[zaehler] / 2);  //inputzahl wird auf den Wert nach der Modulorechnung aktualisiert

      zaehler2 += 1;  //Zähler für Zwischenspeicher wird erhöht
    end;

    //Ergebnis für ein Zeichen wird richtigrum in String gebracht
    for zaehler2:=Length(Zwischenspeicher)-1 downto 0 do  //geht Zwischenspeicher Rückwärts durch
    begin
      zwischenergebnis += IntToStr(Zwischenspeicher[zaehler2]); //wird zum gesammten Binärstring hinzugefügt
    end;
  end;

  DezToBin := zwischenergebnis; //Rueckgabewert
end;

procedure speichern(Daten: String; Name: String; var Output: String; var Fehler: boolean); //speichert Einträge in Datei  und trifft Vorkehrungen bei Index u Keys
var Fertige_Daten: TStringList;
var Index: TStringList;
var zaehler: integer;
var ASCII_Code: array of integer;
var Bin_Code: String;
var generated_key: string;
var verschluesselte_Daten: string;
var Keys: TStringList;
begin
  Fehler:= false;
  SetLength(ASCII_Code, Length(Daten));  //Länge von ASCII_Code wir angepasst
  for zaehler:=1 to Length(Daten) do   //Durchläuft Daten    fängt bei 1 an weil das nullte Element nicht auslesbar ist
  begin
    ASCII_Code[zaehler-1] := ord(Daten[zaehler]);  //Übersetzung von Buchstaben in Dezimalzahlen
  end;

  Bin_Code:= DezToBin(ASCII_Code);  //Übersettzung in Binärcode
  {Verschlüsselung}
  generated_key:= '';
  for zaehler:=0 to Length(Bin_Code) do  //erstellt einen Schlüssel der so lang ist wie Bin_Code
  begin
    generated_key += IntToStr(random(2));
  end;

  verschluesselte_Daten := encrypt(Bin_Code, generated_key); //verschlüsselt die Daten

  //schlüssel speichern
  if Not(FileExists('C:\\Keypass\\' + Name + '.txt')) then   //wenn der Eintrag noch nicht vorhande ist
  begin
    Keys:= TStringList.Create;
    if FileExists('C:\\Keypass\\Keys.txt') then    //Wenn Keys.txt Datei existiert
      Keys.LoadFromFile('C:\\Keypass\\Keys.txt');  //Schlüssel werden geladen
    Keys.Add(Name + ':' + encrypt(generated_key,Passwort_public)); //neuer Schlüssel wird hinzugefügt
    Keys.SaveToFile('C:\\Keypass\\Keys.txt'); //Schlüssel werden mit neuem Schlüssel gespeichert    alte Datei wird Überschrieben
    Keys.Free();  //Arbeitsspeicher wird freigegeben
  end;

  Fertige_Daten:= TStringList.Create;
  Fertige_Daten.Add(verschluesselte_Daten);
  if Not(DirectoryExists('C:\\Keypass')) then //wenn das Verzeichnis Keypass nicht existiert
    CreateDir('C:\\Keypass');    //erstellt Verzeichnis
  if Not(FileExists('C:\\Keypass\\' + Name + '.txt')) then  //Wenn der Eintrag noch nicht existiert
  begin
    Fertige_Daten.SaveToFile('C:\\Keypass\\' + Name + '.txt'); //speichert Daten in Datei
    Index:= TStringList.Create;
    //erstellt Eintrag in der Index-Datei
    if FileExists('C:\\Keypass\\Index.txt') then  //wenn Index-Datei existiert
    begin
      Index.LoadFromFile('C:\\Keypass\\index.txt'); //Lädt Daten von der Index-Datei
    end;
    Index.Add(Name);  //neuer Eintrag wir Hinzugefügt
    Index.SaveToFile('C:\\Keypass\\index.txt'); //Index wird überschrieben
    Fehler:= true; //kein Fehler

    Index.Free();  //Arbeitsspeicher wird freigegeben
  end
  else //wenn der Eintrag bereits existiert
  begin
    Fehler:= false;  //Fehler vorhanden
    Output:= 'Fehler: Dateiname existiert schon.' + #10#13 + 'Geben sie dem Eintrag einen anderen Namen';  //Fehlermeldung
  end;
  Fertige_Daten.Free(); //Arbeitsspeicher wird freigegeben
  ASCII_Code := Nil;
end;

function encrypt(Daten: string; Key: string): string;  //verschlüsselt Daten mit Key
var zaehler: integer;
var verschluesselte_Daten: string;
begin
  verschluesselte_Daten:= '';
  if (Length(Daten) <= Length(Key)) then  //der Schlüssel muss mindestens so lang sein wie die Daten
  begin
    for zaehler:=1 to Length(Daten) do  //zaehler:=1 weil das nullte Element eines Strings nicht auslesbar ist, durchläuft alle Zeichen von Daten
    begin
      verschluesselte_Daten += IntToStr(BinXor(StrToInt(Daten[zaehler]), StrToInt(Key[zaehler])));  //die beiden Zahlen werden mit operator XOR bearbeitet und an einen String angehängt
    end;
    encrypt:= verschluesselte_Daten;      //Rückgabe des Ergebnisses
  end
  else //wenn die Daten länger sind als der Schlüssel
  begin
    encrypt:= encrypt(Daten, Key + Key);   //Rekursion mit verdoppeltem Schlüssel (zweimal der gleiche Schlüssel hintereinandergehängt)
  end;
end;

function BinXor(binaer1: integer; binaer2: integer): integer;    //gibt den XOR Wert von zwei zahlen zurück nur 0 und 1 möglich
begin
  if((binaer1 = 0) and (binaer2 = 0)) or ((binaer1 = 1) and (binaer2 = 1)) then //wenn beide zahlen den gleichen Wert haben
  begin
    BinXor:= 0;   //0 wird zurückgegeben
  end
  else if ((binaer1 = 1) and (binaer2 = 0)) or ((binaer1 = 0) and (binaer2 = 1)) then   //wenn dei Zahlen unterschiedliche Werte haben
  begin
    BinXor:= 1;  //1 wird zurückgegeben
  end;
end;

function decrypt(Daten: string; Key: string): string;  //entschlüsselt Daten mit Key, macht im Prinzip genau das gleiche wie encrypt allerdings kann man so besser unterscheiden ob Ver- oder Entschlüsselt wird
var zaehler: integer;
var zwischenergebnis: string;
begin
  zwischenergebnis:= '';
  if Length(Daten) <= Length(Key) then   //der Schlüssel muss mindestens so lang sein wie die Daten
  begin
    for zaehler:=1 to Length(Daten) do  //zaehler:=1 weil das nullte Element eines Strings nicht auslesbar ist, durchläuft alle Zeichen von Daten
    begin
      zwischenergebnis+= IntToStr(BinXor(StrToInt(Daten[zaehler]), StrToInt(Key[zaehler]))); //die beiden Zahlen werden mit operator XOR bearbeitet und an einen String angehängt
    end;
    decrypt := zwischenergebnis;   //Rückgabe des Ergebnisses
  end
  else  //wenn die Daten länger sind als der Schlüssel
  begin
    decrypt:= decrypt(Daten, Key + Key);  //Rekursion mit verdoppeltem Schlüssel (zweimal der gleiche Schlüssel hintereinandergehängt)
  end;
end;

procedure Eintrag_loeschen(Name: string);  //löscht einen Eintrag
var index_alt: TStringList;
var index_neu: TStringList;
var zaehler: integer;
var Keys_alt: TStringList;
var Keys_neu: TStringList;
var Key_Eintrag: TStringList;
begin
  if (FileExists('C:\\Keypass\\index.txt')) then   //wenn die Index-Datei existiert
  begin
    Index_alt:= TStringList.Create;
    Index_neu:= TStringList.Create;
    Index_alt.LoadFromFile('C:\\Keypass\\index.txt'); //Daten werden geladen

    for zaehler:=0 to Index_alt.Count-1 do     //durchläuft alle Elemente der Index - Datei
    begin
      if(Not(Index_alt[zaehler] = Name)) then //wenn der Eintrag aus der alten Index-Datei nicht der zu löschende Eintrag ist
      begin
        Index_neu.Add(Index_alt[zaehler]);    //alter Eintrag wird übernommen
      end
      else     //wenn es der überarbeitete Eintrag ist
      begin
        continue;      // Eintrag wird nicht übernommen -> bei Bearbeitung eines Eintrags wird die neue Datei in speichern() gespeichert
      end;
    end;

    Index_neu.SaveToFile('C:\\Keypass\\index.txt'); //neue Index-Datei wird gespeichert

    Index_alt.free; //Arbeitsspeicher wird freigegeben
    Index_neu.free;
  end;

  if FileExists('C:\\Keypass\\' + Name + '.txt') then  //wenn der Eintrag existiert
    DeleteFile('C:\\Keypass\\' + Name + '.txt');  //alte Datei wird gelöscht (Die Datei die Überarbeitet wird)

  if FileExists('C:\\Keypass\\Keys.txt') then  //wenn die Keys-Datei existiert
  begin
    Keys_alt := TStringList.Create;
    Keys_neu := TStringList.Create;
    Key_Eintrag := TStringList.Create;
    Keys_alt.LoadFromFile('C:\\Keypass\\Keys.txt'); //alte Schlüssel werden geladen

    for zaehler:=0 to Keys_alt.Count-1 do  //durchläuft die Elemente von Keys_alt
    begin
      SplitText(':', Keys_alt[zaehler], Key_Eintrag); //Name und Schlüssel werden voneinander getrennt
      if Not(Key_Eintrag[0] = Name) then   //abgleich ob Eintrag der zu löschende Eintrag ist
      begin
        Keys_neu.Add(Keys_alt[zaehler]);  //alter eintrag wird übernommen
      end
      else  //wenn ausgewählte datei zu löschende Datei ist
      begin
        continue; //wird übersprungen
      end;
    end;
    Keys_neu.SaveToFile('C:\\Keypass\\Keys.txt'); //neue Datei wird gespeichert


    Keys_alt.free;  //Arbeitsspeicher wird freigegeben
    Keys_neu.free;
    Key_Eintrag.free;
  end;
end;

end.

