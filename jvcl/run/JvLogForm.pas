{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvLogForm.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is Sébastien Buysse [sbuysse@buypin.com]
Portions created by Sébastien Buysse are Copyright (C) 2001 Sébastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck@bigfoot.com].

Last Modified: 2004-01-05

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvLogForm;

interface

uses
  {$IFDEF VCL}
  Controls, Forms, Dialogs, ComCtrls, ActnList, ImgList, ToolWin,
  {$ENDIF}
  {$IFDEF VisualCLX}
  QControls, QForms, QDialogs, QComCtrls, QActnList, QImgList{, ToolWin},
  {$ENDIF}
  SysUtils, Classes;

type
  TFoLog = class(TForm)
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ImageList1: TImageList;
    ActionList1: TActionList;
    Save: TAction;
    Print: TAction;
    ListView1: TListView;
    SaveDialog1: TSaveDialog;
    procedure SaveExecute(Sender: TObject);
    procedure PrintExecute(Sender: TObject);
  private
    procedure MakeLogLines(S: TStrings);
  end;

implementation

{$IFDEF VCL}
uses
  Printers;

{$R *.dfm}
{$ENDIF}
{$IFDEF VisualCLX}
uses
  QPrinters;

{$R *.xfm}
{$ENDIF}

procedure TFoLog.SaveExecute(Sender: TObject);
var
  S: TStringList;
begin
  if SaveDialog1.Execute then
  begin
    S := TStringList.Create;
    try
      MakeLogLines(S);
      S.SaveToFile(SaveDialog1.FileName);
    finally
      S.Free;
    end;
  end;
end;

procedure TFoLog.MakeLogLines(S:TStrings);
var
  I: Integer;
begin
  for I := 0 to ListView1.Items.Count-1 do
    // (rom) Format parameters were missing
    S.Add(Format('[%s] %s > %s',
      [ListView1.Items[I].Caption, ListView1.Items[I].SubItems[0],
       ListView1.Items[I].SubItems[1]]));
end;

procedure TFoLog.PrintExecute(Sender: TObject);
var
  I: Integer;
  S: TStringList;
  F: TextFile;
begin
  S := TStringList.Create;
  try
    MakeLogLines(S);
    AssignPrn(F);
    Rewrite(F);
    for I := 0 to S.Count-1 do
      Writeln(F, S[I]);
    CloseFile(F);
  finally
    S.Free;
  end;
end;

end.
