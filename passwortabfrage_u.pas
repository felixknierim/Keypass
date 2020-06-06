unit Passwortabfrage_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, md5;

type

  { TForm4 }

  TForm4 = class(TForm)
    Bestaetigen_E: TButton;
    Zweck_L: TLabel;
    Passwort_E: TEdit;
    Static_L: TLabel;
    procedure Bestaetigen_EClick(Sender: TObject);
  private
    var Passwort: string;
  public

  end;

var
  Form4: TForm4;

implementation

{$R *.lfm}

{ TForm4 }

procedure TForm4.Bestaetigen_EClick(Sender: TObject);
var Passwort_Hash: TStringList;
begin
  Passwort_Hash:= TStringList.Create;
  if FileExists('C:\\Keypass\\Passwort.txt') then  //wenn die Datei Passwort.txt existiert
  begin
    Passwort_Hash.LoadFromFile('C:\\Keypass\\Passwort.txt');  //lädt die Datei Passwort.txt in Liste
    if Passwort_Hash[0] = MD5Print(MD5String(Passwort_E.Text)) then //Überprüft ob die Eingabe(gehasht) mit dem gespeicherten gehashten Passwort übereinstimmt --> Passwort richtig
    begin
      Passwort:= Passwort_E.Text; //übergabe des Passwortes zur Ver-/Entschlüsselung der Dateien
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
    Passwort:= Passwort_E.Text; //Password als Übergabe zur Ver-/Entschlüsselung der Dateien
    Close;
  end;
end;

end.

