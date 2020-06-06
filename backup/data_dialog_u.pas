unit Data_Dialog_u;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, libary_u;

type

  { TForm3 }

  TForm3 = class(TForm)
    Fehler_L: TLabel;
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
var NextAction: boolean;
var Daten: string;
var Output: string;
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
      Index_neu.SaveToFile('C:\\Keypass\\index.txt');
      DeleteFile('C:\\Keypass\\' + buffer[0] + '.txt');

      NextAction:= false;
      Output:= '';
      Daten:= Name_E.Text + '&' + URL_E.Text + '&' + Nutzername_E.Text + '&' + Passwort_E.Text + '&';
      Speichern(Daten, Name_E.Text,Output, NextAction);
      if NextAction = true then
      begin
        Close;
      end
      else
      begin
        Fehler_L.Caption:= Output;
      end;

    end;
  end;
end;

end.

