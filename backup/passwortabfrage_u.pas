unit Passwortabfrage_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, md5, sha1, libary_u;

type

  { TForm4 }

  TForm4 = class(TForm)
    Bestaetigen_B: TButton;
    Zweck_L: TLabel;
    Passwort_E: TEdit;
    Static_L: TLabel;
    procedure Bestaetigen_BClick(Sender: TObject);
  private

  public

  end;

var
  Form4: TForm4;

implementation

{$R *.lfm}

{ TForm4 }


procedure TForm4.Bestaetigen_BClick(Sender: TObject);
var Passwort_Hash: TStringList;
var ASCII_Code: array of integer;
var zaehler: integer;
var Passwort_local: string;
begin
  Passwort_public:= '';
  Passwort_Hash:= TStringList.Create;

  if FileExists('C:\\Keypass\\Passwort.txt') then  //wenn die Datei Passwort.txt existiert
  begin
    Passwort_Hash.LoadFromFile('C:\\Keypass\\Passwort.txt');  //lädt die Datei Passwort.txt in Liste
    if Passwort_Hash[0] = MD5Print(MD5String(Passwort_E.Text)) then //Überprüft ob die Eingabe(gehasht) mit dem gespeicherten gehashten Passwort übereinstimmt --> wenn Passwort richtig
    begin
      //Passwort wird zum Ver-/Entschlüsseln übergeben
      Passwort_local:= SHA1Print(SHA1String(Passwort_E.Text)); //Passwort wird gehasht
      SetLength(ASCII_Code, Length(passwort_local));    //Länge des Array wird angepasst
      for zaehler:=1 to Length(passwort_local) do     //Durchläuf jedes Zeichen des Hashes
      begin
        ASCII_Code[zaehler-1] := ord(passwort_local[zaehler]);  //Übersetzung von Buchstaben in Dezimalzahlen
      end;

      Passwort_public:= DezToBin(ASCII_Code);  //Übersetzung in Binärcode damit der Schlüssel direkt zur Entschlüsselung verwendet werden kann

      Close;  //Fenster wird geschlossen

    end
    else   //wenn das Passwort falsch ist
    begin
      Zweck_L.Caption := 'Falsches Passwort'; //Fehleranzeige
    end;
  end
  else  //wenn die Datei Passwort.txt nicht existiert
  begin

    Passwort_Hash.Add(MD5Print(MD5String(Passwort_E.Text))); //Passwort wird gehasht
    Passwort_Hash.SaveToFile('C:\\Keypass\\Passwort.txt');  //Passwort(gehasht) wird gespeichert

    //Passwort wird zum Ver-/Entschlüsseln übergeben
    Passwort_local:= SHA1Print(SHA1String(Passwort_E.Text)); //Passort wird gehasht
    SetLength(ASCII_Code, Length(Passwort_local));  //Länge des Array wird angepasst
    for zaehler:=1 to Length(Passwort_local) do
    begin
      ASCII_Code[zaehler-1] := ord(Passwort_local[zaehler]);  //Übersetzung von Buchstaben in Dezimalzahlen
    end;
    Passwort_public:= DezToBin(ASCII_Code); //Übersetzung in Binärcode damit der Schlüssel direkt zur Entschlüsselung verwendet werden kann

    Close;  //Fenster wird geschlossen
  end;
  Passwort_Hash.Free();  //Arbeitsspeicher wird freigegeben
end;

end.

