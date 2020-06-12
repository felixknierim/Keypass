unit Passwortabfrage_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, md5, sha1, libary_u;

type

  { TForm4 }

  TForm4 = class(TForm)
    Bestaetigen_E: TButton;
    Zweck_L: TLabel;
    Passwort_E: TEdit;
    Static_L: TLabel;
    procedure Bestaetigen_EClick(Sender: TObject);
  private
    var Passwort_local: string;
  public

  end;

var
  Form4: TForm4;

implementation

{$R *.lfm}

{ TForm4 }


procedure TForm4.Bestaetigen_EClick(Sender: TObject);
var Passwort_Hash: TStringList;
var buffer: array of integer;
var zaehler: integer;
begin
  Passwort_public:= '';
  Passwort_Hash:= TStringList.Create;
  if FileExists('C:\\Keypass\\Passwort.txt') then  //wenn die Datei Passwort.txt existiert
  begin
    Passwort_Hash.LoadFromFile('C:\\Keypass\\Passwort.txt');  //lädt die Datei Passwort.txt in Liste
    if Passwort_Hash[0] = MD5Print(MD5String(Passwort_E.Text)) then //Überprüft ob die Eingabe(gehasht) mit dem gespeicherten gehashten Passwort übereinstimmt --> Passwort richtig
    begin
      Passwort_local:= SHA1Print(SHA1String(Passwort_E.Text)); //übergabe des Passwortes(gehasht) zur Ver-/Entschlüsselung der Dateien
      SetLength(buffer, Length(passwort_local));
      for zaehler:=1 to Length(passwort_local) do
      begin
        buffer[zaehler-1] := ord(passwort_local[zaehler]);  //Übersetzung von Buchstaben in Dezimalzahlen
      end;

      Passwort_public:= DezToBin(buffer);  //Übersettzung in Binärcode

      Close;
    end
    else   //wenn das Passwort falsch ist
    begin
      Zweck_L.Caption := 'Falsches Passwort';
    end;
  end
  else  //wenn die Datei Passwort.txt nicht existiert
  begin
    Passwort_Hash.Add(MD5Print(MD5String(Passwort_E.Text))); //Passwort wird gehasht
    Passwort_Hash.SaveToFile('C:\\Keypass\\Passwort.txt');  //Passwort wird gespeichert
    Passwort_local:= SHA1Print(SHA1String(Passwort_E.Text)); //übergabe des Passwortes(gehasht) zur Ver-/Entschlüsselung der Dateien
      SetLength(buffer, Length(Passwort_local));
      for zaehler:=1 to Length(Passwort_local) do
      begin
        buffer[zaehler-1] := ord(Passwort_local[zaehler]);  //Übersetzung von Buchstaben in Dezimalzahlen
      end;
      Passwort_public:= DezToBin(buffer);
      Close;
  end;
end;

end.

