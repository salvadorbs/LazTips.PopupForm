unit Execute.PopupForm;

{

 Easy popup form (c)2022 Paul TOTH <contact@execute.fr>
 https://github.com/tothpaul

}

interface

uses
  LCLType,
  Classes,
  Controls,
  Forms;

type

  { TPopupForm }

  TPopupForm = class(TForm)
  private
  // allow multiple popup at the same time
    OldPopup: TPopupForm;
    class var ActivePopup: TPopupForm;
    procedure DoDeactivate(Sender: TObject);
    procedure DoDeactivateApp(Sender: TObject);
  protected
  // force default setting and initialize FAppEvents
    procedure InitializeWnd; override;
  public
    destructor Destroy; override;
  // popup the form at the specified position
    procedure ShowPopup(Parent: TCustomForm; const Position: TPoint); overload;
  // popup the form at the bottom left corner of the source control
    procedure ShowPopup(Parent: TCustomForm; Source: TControl); overload;
  end;

implementation

{ TPopupForm }

destructor TPopupForm.Destroy;
begin
// restore old popup
  ActivePopup := OldPopup;
  inherited;
end;

procedure TPopupForm.DoDeactivate(Sender: TObject);
begin
  if Screen.ActiveForm <> ActivePopup then
     Release;
end;

procedure TPopupForm.DoDeactivateApp(Sender: TObject);
begin
  Release;
end;

procedure TPopupForm.InitializeWnd;
begin
  inherited;
// force properties so you don't have to set them at design time
  BorderStyle := bsNone;
  Position := poDesigned;
// hide the form from the TaskBar
  Self.ShowInTaskBar := stNever;

  OnDeactivate := DoDeactivate;
  Application.AddOnDeactivateHandler(DoDeactivateApp);
end;

procedure TPopupForm.ShowPopup(Parent: TCustomForm; Source: TControl);
var
   P: TPoint;
begin
// bottom left corner
  P := Source.ClientToScreen(TPoint.Create(0, Source.Height));
// verify monitor boundaries
  if P.X + Width > Self.Monitor.Width then
    P.X := Self.Monitor.Width - Width;
  if P.Y + Height > Self.Monitor.Height then
    Dec(P.Y, Source.Height + Height);
// show it
  ShowPopup(Parent, P);
end;

procedure TPopupForm.ShowPopup(Parent: TCustomForm; const Position: TPoint);
begin
// save active popup
  OldPopup := ActivePopup;
  ActivePopup := Self;
// move the form to the desired position
  Left := Position.X;
  Top := Position.Y;
// VCL sync
  Visible := True;
end;

end.
