unit DelphiTips.SampleList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls,
  Execute.PopupForm;

type
  TSampleList = class(TPopupForm)
    ListBox1: TListBox;
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Edit: TEdit;
    procedure OnKey(var Key: Word);
  end;

var
  SampleList: TSampleList;

implementation

{$R *.lfm}

{ TSampleList }

procedure TSampleList.ListBox1DblClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := ListBox1.ItemIndex;
  if Assigned(Edit) and (Index >= 0) then
  begin
    Edit.Text := ListBox1.Items[Index];
    Release;
  end;
end;

procedure TSampleList.OnKey(var Key: Word);
var
  Index: Integer;
begin
  Index := ListBox1.ItemIndex;
  case Key of
    VK_DOWN:
      if Index < ListBox1.Items.Count - 1 then
        ListBox1.ItemIndex := Index + 1;
    VK_UP:
      if Index > 0 then
        ListBox1.ItemIndex := Index - 1;
    VK_ESCAPE: Release;
    VK_RETURN:
      if Index >= 0 then
      begin
        Key := 0;
        Edit.Text := ListBox1.Items[Index];
        Release;
      end;
  end;
end;

end.
