unit ImageButton;
{*******************************************************************************
 * TImageButton
 * Component of WinEssential project (http://php4php.free.fr/winessential/)
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
 * Place, Suite 330, Boston, MA 02111-1307 USA
 *
 * Original idea WebCheck
 *
 * Version 1.0 by MARTINEAU Emeric (php4php.free.fr) - 19/01/2008
 ******************************************************************************}


interface

uses
  SysUtils, Classes, Controls, StdCtrls, Graphics, Messages, Types;

type TStatus = (sNormal, sDisabled, sOver, sDown);

type
  TImageButton = class(TGraphicControl)
  private
    { Private-Deklarationen }
    FTransparentColor: TColor;
    FTransparent: Boolean;
    FImageButton: TBitmap;
    FImageDisabled: TBitmap;
    FImageMouseOver: TBitmap;
    FImageDown: TBitmap;
    FStatus: TStatus;
    FEnabled: Boolean;
    FAutoSize: Boolean;
    FClipping: Boolean;
    procedure TransparentColorSet(NewColor: TColor);
    procedure TransparentSet(Transparent: Boolean);
    procedure ImageButtonSet(NewBitmap: TBitmap);
    procedure ImageDisabledSet(NewBitmap: TBitmap);
    procedure ImageMouseOverSet(NewBitmap: TBitmap);
    procedure ImageDownSet(NewBitmap: TBitmap);
    procedure EnabledSet(value: Boolean);
    procedure AutoSizeSet(asvalue: Boolean);
    procedure ClippingSet(value: Boolean);
  protected
    procedure Paint; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(Component: TComponent); override;
    destructor Destroy; override;
  published
    property TransparentColor: TColor read FTransparentColor write TransparentColorSet default clFuchsia;
    property Transparent: Boolean read FTransparent write TransparentSet default False;
    property ImageButton: TBitmap read FImageButton write ImageButtonSet;
    property ImageDisabled: TBitmap read FImageDisabled write ImageDisabledSet;
    property ImageMouseOver: TBitmap read FImageMouseOver write ImageMouseOverSet;
    property ImageDown: TBitmap read FImageDown write ImageDownSet;
    property Enabled: Boolean read FEnabled write EnabledSet default True;
    property AutoSize: Boolean read FAutoSize write AutoSizeSet default True;
    property Clipping: Boolean read FClipping write ClippingSet default False;
    property Visible;
    property OnClick;
  end;

procedure Register;

implementation

{*******************************************************************************
 * Constructeur
 ******************************************************************************}
constructor TImageButton.Create(Component: TComponent);
begin
    inherited Create(Component);

    FTransparentColor := clFuchsia;

    Self.Width := 25 ;
    Self.Height := 25 ;

    FStatus := sNormal;

    FEnabled := True;
    FAutoSize := True;
    FClipping := False;

    FImageButton := TBitmap.Create;
    FImageDisabled := TBitmap.Create;
    FImageMouseOver := TBitmap.Create;
    FImageDown := TBitmap.Create;
end;

{*******************************************************************************
 * Destructeur
 ******************************************************************************}
destructor TImageButton.Destroy;
begin
    FImageButton.Free;
    FImageDisabled.Free;
    FImageMouseOver.Free;
    FImageDown.Free;

    inherited Destroy;
end;

{*******************************************************************************
 * Procedure appelée pour dessiner le composant
 ******************************************************************************}
procedure TImageButton.Paint;
var Image : TBitmap;
begin
    Image := TBitmap.Create ;

    if Enabled = False
    then
        FStatus := sDisabled ;

    if (FStatus = sDisabled) and (Assigned(FImageDisabled))
    then
        Image.Assign(FImageDisabled)
    else if (FStatus = sNormal) and (Assigned(FImageButton))
    then
        Image.Assign(FImageButton)
    else if (FStatus = sDown) and (Assigned(FImageDown))
    then
        Image.Assign(FImageDown)
    else if (FStatus = sOver) and (Assigned(FImageMouseOver))
    then
        Image.Assign(FImageMouseOver) ;

  if FTransparent = True
  then begin
      Image.TransparentMode := tmFixed ;
      Image.TransparentColor := FTransparentColor ;
      Image.Transparent := FTransparent ;
  end;

  Canvas.Draw(0, 0, Image) ;

  Image.Free ;
end;

{*******************************************************************************
 * Affecte l'attribut AutoSize
 ******************************************************************************}
procedure TImageButton.AutoSizeSet(asvalue: Boolean);
begin
    FAutoSize := asvalue ;

    if (FAutoSize = True) and (Assigned(FImageButton))
    then begin
        Width := FImageButton.Width;
        Height := FImageButton.Height;
    end ;

    Invalidate ;
end;

{*******************************************************************************
 * Affecte l'attribut TransparentColor
 ******************************************************************************}
procedure TImageButton.TransparentColorSet(NewColor: TColor);
begin
    FTransparentColor := NewColor ;
    Invalidate ;
end;

{*******************************************************************************
 * Affecte l'attribut Enable
 ******************************************************************************}
procedure TImageButton.EnabledSet(value: Boolean);
begin
    FEnabled := value ;

    if Enabled = True
    then
        FStatus := sNormal
    else
        FStatus := sDisabled ;

    Invalidate ;
end;

{*******************************************************************************
 * Affecte l'attribut Clipping
 ******************************************************************************}
procedure TImageButton.ClippingSet(value: Boolean);
begin
    FClipping := value ;
    Invalidate ;
end;

{*******************************************************************************
 * Affecte l'attribut Transparent
 ******************************************************************************}
procedure TImageButton.TransparentSet(Transparent: Boolean);
begin
    FTransparent := Transparent ;

    Invalidate ;
end;

{*******************************************************************************
 * Procedure appelée
 ******************************************************************************}
procedure TImageButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  OldStatus: TStatus;
begin
    if FStatus <> sDisabled
    then begin
        OldStatus := FStatus;

        if Button = mbLeft
        then begin
            FStatus := sNormal;
        end;

        { Pour éviter un affichage flashé, on redessine le controle que si le
          status est modifié }
        if OldStatus <> FStatus
        then begin
            Invalidate;
        end;

        inherited MouseUp(Button, Shift, X, Y) ;
    end ;
end;

{*******************************************************************************
 * Affecte l'attribut IamgeButton
 ******************************************************************************}
procedure TImageButton.ImageButtonSet(NewBitmap: TBitmap) ;
begin
    FImageButton.Assign(NewBitmap) ;
    AutoSizeSet(FAutoSize) ;
    Invalidate ;
end;

{*******************************************************************************
 * Affecte l'attribut ImageDisabled
 ******************************************************************************}
procedure TImageButton.ImageDisabledSet(NewBitmap: TBitmap) ;
begin
    FImageDisabled.Assign(NewBitmap) ;

    Invalidate ;
end;

{*******************************************************************************
 * Affecte l'attribut ImageMousOver
 ******************************************************************************}
procedure TImageButton.ImageMouseOverSet(NewBitmap: TBitmap);
begin
    FImageMouseOver.Assign(NewBitmap) ;
    Invalidate ;
end;

{*******************************************************************************
 * Affecte l'attribut ImageDown
 ******************************************************************************}
procedure TImageButton.ImageDownSet(NewBitmap: TBitmap);
begin
  FImageDown.Assign(NewBitmap) ;
  Invalidate ;
end;

{*******************************************************************************
 * Procedure gérant la souris
 ******************************************************************************}
procedure TImageButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  OldStatus: TStatus;
  CurrentBitmap : TBitmap ;

begin
    if FStatus <> sDisabled
    then begin
        OldStatus := FStatus ;

        { Est-ce que le on est sur le controle }
        if PtInRect(Rect(0, 0, width, height), Point(x, y))
        then begin
            { Si clipping activé }
            if FClipping = True
            then begin
                if FStatus = sNormal
                then
                    CurrentBitmap := FImageButton
                else if FStatus = sOver
                then
                    CurrentBitmap := FImageMouseOver
                else
                    CurrentBitmap := FImageDown ;

                if CurrentBitmap.Canvas.Pixels[x, y] <> FTransparentColor
                then begin
                    FStatus := sOver ;
                    { Intercepter les événements de souris }
                    MouseCapture := True ;
                end
                else begin
                    FStatus := sNormal ;
                    MouseCapture := False ;
                end ;
            end
            else begin
                { On ne regarde pas si on doit n'afficher l'image que si on n'ait
                  pas sur la couleur transparente }
                FStatus := sOver ;
                MouseCapture := True ;
            end;
        end
        else begin
            FStatus := sNormal ;
            MouseCapture := False ;
        end ;

        { Pour éviter un affichage flashé, on redessine le controle que si le
          status est modifié }
        if OldStatus <> FStatus
        then begin
            Invalidate ;
        end;

        inherited MouseMove(Shift, X, Y) ;
    end ;
end;

{*******************************************************************************
 * Procedure gérant la souris
 ******************************************************************************}
procedure TImageButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  OldStatus: TStatus;
begin
    if FStatus <> sDisabled
    then begin
        OldStatus := FStatus;

        if Button = mbLeft
        then begin
            FStatus := sDown ;
        end ;

        { Pour éviter un affichage flashé, on redessine le controle que si le
          status est modifié }
        if OldStatus <> FStatus
        then begin
            Invalidate ;
        end ;

        inherited MouseDown(Button, Shift, X, Y) ;
    end ;
end;

procedure Register;
begin
  RegisterComponents('WinEssential', [TImageButton]);
end;

end.
