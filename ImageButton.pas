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
 * FOR A PARTICULAR PURPOSE.See the GNU LESSER GENERAL PUBLIC LICENSE for more details.
 *
 * You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE along with
 * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
 * Place, Suite 330, Boston, MA 02111-1307 USA
 *
 * Original idea WebCheck
 *
 *******************************************************************************
 * Version 1.1 by MARTINEAU Emeric (php4php.free.fr) - 01/02/2008
 *  - ajout d'une bordure en mode design,
 *  - ajout d'une image désactivé automatiquement,
 *  - non obligation d'avoir un image over et down,
 *  - ajout de OnMouseMove, OnMouseDown, OnMouseUp,
 *  - ajoute d'un caption,
 *  - ajout de OnEnter, OnExit, OnMouseEnter, OnMouseExit,
 *  - ajoute de couleur du texte lorsqu'on a le focus, 
 *
 * Version 1.0 by MARTINEAU Emeric (php4php.free.fr) - 19/01/2008
 ******************************************************************************}


interface

uses
  SysUtils, Classes, Controls, StdCtrls, Graphics, Messages, Windows ;

type TStatus = (sNormal, sDisabled, sOver, sDown);
     TTextPosition = (tpTop, tpBottom, tpLeft, tpRight) ;

type
  TImageButton = class(TGraphicControl)
  private
    FTransparentColor: TColor;
    FTransparent: Boolean;
    FImageButton: Graphics.TBitmap;
    FImageDisabled: Graphics.TBitmap;
    FImageMouseOver: Graphics.TBitmap;
    FImageDown: Graphics.TBitmap;
    FStatus: TStatus;
    FEnabled: Boolean;
    FAutoSize: Boolean;
    FClipping: Boolean;
    FOnMouseDown : TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnMouseUp: TMouseEvent;
    FCaption : String ;
    FShowCaption : boolean ;
    FTextPosition : TTextPosition ;
    FRect : TRect ;
    FFont : TFont ;
    FHotFont : TFont ;
    FWordWrap : Boolean ;
    // Utiliser pour obtenir la config de police des boutons
    Params: NONCLIENTMETRICS;
    // Controle pour recevoir le focus
    MonButton : TButton ;
    // Procédure utilisateur
    FOnMouseEnter :  TNotifyEvent ;
    FOnMouseExit :  TNotifyEvent ;
    // Affichage du focus
    FShowFocus : Boolean ;
    // Indique si le controle à le focus
    Focused : Boolean ;
    // Couleur de fond du texte si on a le focus
    FBackGroundFocusColor : TColor ;
    // Couleur du texte si on a le focus
    FTextFocusColor : TColor ;
    // Appeler si on reçoit ou perd le focus
    FOnEnter : TNotifyEvent ;
    FOnExit : TNotifyEvent ;
    procedure TransparentColorSet(NewColor: TColor);
    procedure TransparentSet(Transparent: Boolean);
    procedure ImageButtonSet(NewBitmap: Graphics.TBitmap);
    procedure ImageMouseOverSet(NewBitmap: Graphics.TBitmap);
    procedure ImageDownSet(NewBitmap: Graphics.TBitmap);
    procedure EnabledSet(value: Boolean);
    procedure AutoSizeSet(asvalue: Boolean);
    procedure ClippingSet(value: Boolean);
    procedure ColorPictureToGray(Bitmap : Graphics.TBitmap) ;
    procedure SetCaption(Text : string) ;
    procedure SetShowCaption(status : boolean) ;
    procedure SetTextPosition(position : TTextPosition) ;
    procedure SetFont(NewFont : TFont) ;
    procedure SetWordWrap(status : boolean) ;
    function SizeOfText(Text : String; REct : TRect) : TRect ;
    procedure SetRect(Rect : TRect) ;
    procedure SetHotFont(NewFont : TFont) ;
    procedure SetShowFocus(value : Boolean) ;
    procedure ButtonEnter(Sender: TObject);
    procedure ButtonExit(Sender: TObject);
    procedure SetBackGroundFocus(couleur : TColor) ;
    procedure SetTextFocus(couleur : TColor) ;
  protected
    procedure Paint; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
  public
    constructor Create(Component: TComponent); override;
    destructor Destroy; override;
    property Rect : TRect read FRect write SetRect ;
  published
    property TransparentColor: TColor read FTransparentColor write TransparentColorSet default clFuchsia;
    property Transparent: Boolean read FTransparent write TransparentSet default False;
    property ImageButton: Graphics.TBitmap read FImageButton write ImageButtonSet;
    property ImageMouseOver: Graphics.TBitmap read FImageMouseOver write ImageMouseOverSet;
    property ImageDown: Graphics.TBitmap read FImageDown write ImageDownSet;
    property Enabled: Boolean read FEnabled write EnabledSet default True;
    property AutoSize: Boolean read FAutoSize write AutoSizeSet default True;
    property Clipping: Boolean read FClipping write ClippingSet default False;
    property Caption : String read FCaption write SetCaption ;
    property ShowCaption : boolean read FShowCaption write SetShowCaption default false ;
    property TextPosition : TTextPosition read FTextPosition write SetTextPosition default tpBottom ;
    property Font : TFont read FFont write SetFont ;
    property HotFont : TFont read FHotFont write SetHotFont ;
    property WordWrap : Boolean read FWordWrap write SetWordWrap default false ;
    property OnMouseDown : TMouseEvent read FOnMouseDown write FOnMouseDown ;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove ;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp ;
    property OnMouseEnter :  TNotifyEvent read FOnMouseEnter write FOnMouseEnter ;
    property OnMouseExit :  TNotifyEvent read FOnMouseExit write FOnMouseExit ;
    property ShowFocus : Boolean read FShowFocus write SetShowFocus default true ;
    property BackGroundFocusColor : TColor read FBackGroundFocusColor write SetBackGroundFocus default clHotLight ;
    property TextFocusColor : TColor read FTextFocusColor write SetTextFocus default clHighlightText ;
    property OnEnter : TNotifyEvent read FOnEnter write FonEnter ;
    property OnExit : TNotifyEvent read FOnExit write FOnExit ;
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

    FImageButton := Graphics.TBitmap.Create;
    FImageDisabled := Graphics.TBitmap.Create;
    FImageMouseOver := Graphics.TBitmap.Create;
    FImageDown := Graphics.TBitmap.Create;

    FCaption := '' ;
    FShowCaption := False ;
    FTextPosition := tpBottom ;

    FRect.Left := -1 ;
    FRect.Right := -1 ;
    FRect.Bottom := -1 ;
    FRect.Top := -1 ;

    FWordWrap := False ;

    Params.cbSize := SizeOf(NONCLIENTMETRICS);
    SystemParametersInfo(SPI_GETNONCLIENTMETRICS, SizeOf(NONCLIENTMETRICS), @Params, 0);

    FFont := TFont.Create ;
    FFont.Color := clBtnText ;
    FFont.Style := [] ;

    if Params.lfMessageFont.lfItalic <> 0
    then
        FFont.Style := FFont.Style + [fsItalic] ;

    if Params.lfMessageFont.lfWeight = 700
    then
        FFont.Style := FFont.Style + [fsBold] ;

    if Params.lfMessageFont.lfUnderline <> 0
    then
        FFont.Style := FFont.Style + [fsUnderLine] ;

    Font.Name := Params.lfMessageFont.lfFaceName ;

    FHotFont := TFont.Create ;
    FHotFont.Assign(FFont);

    MonButton := TButton.Create(Self) ;
    MonButton.Parent := TWinControl(Owner) ;
    MonButton.Width := 0 ;
    MonButton.Height := 0 ;
    MonButton.OnEnter := ButtonEnter ;
    MonButton.OnExit := ButtonExit ;

    FShowFocus := True ;

    Focused := False ;

    FBackGroundFocusColor := clHotLight ;
    FTextFocusColor := clHighlightText ;
end;

{*******************************************************************************
 * Destructeur
 ******************************************************************************}
destructor TImageButton.Destroy;
begin
    { Si le parent est détruit, exemple lors de la fermeture de la fenêtre, le
	  bouton est détruit automatiquement, donc il ne faut pas le re-détruire }
    if Assigned(MonButton.Parent)
    then
        MonButton.Free ;

    FImageButton.Free;
    FImageDisabled.Free;
    FImageMouseOver.Free;
    FImageDown.Free;
    FFont.Free ;
    FHotFont.Free ;

    inherited Destroy;
end;

{*******************************************************************************
 * Procedure appelée pour dessiner le composant
 ******************************************************************************}
procedure TImageButton.Paint;
var Image : Graphics.TBitmap;
    CurrentRect : TRect ;
    fmt : Integer ;
    X, Y : Integer ;
    { Taille du rectangle }
    TextRect : TRect ;
begin
    Image := Graphics.TBitmap.Create ;

    if Enabled = False
    then
        FStatus := sDisabled ;

    Image.Assign(FImageButton) ;

    if (FStatus = sDisabled)
    then begin
        if FImageDisabled.Empty
        then begin
            FImageDisabled.Assign(FImageButton);
            ColorPictureToGray(FImageDisabled) ;
        end ;

        Image.Assign(FImageDisabled) ;
    end
    else if (FStatus = sDown) and (not FImageDown.Empty)
    then
        Image.Assign(FImageDown)
    else if (FStatus = sOver) and (not FImageMouseOver.Empty)
    then
        Image.Assign(FImageMouseOver) ;

    if FTransparent = True
    then begin
        Image.TransparentMode := tmFixed ;
        Image.TransparentColor := FTransparentColor ;
        Image.Transparent := True ;
    end;

    X := (Self.Width - Image.Width) div 2 ;
    Y := 0 ;

    if FTextPosition = tpTop
    then begin
        TextRect.Top := 0 ;
        TextRect.Left := 0 ;
        TextRect.Bottom := Height ;
        TextRect.Right := Width ;

        TextRect := SizeOfText(FCaption, TextRect) ;

        Y := TextRect.Bottom ;
    end
    else if FTextPosition = tpRight
    then begin
        X := 0 ;
        Y := (Self.Height - Image.Height) div 2 ;
    end
    else if FTextPosition = tpLeft
    then begin
        X := Self.Width - Image.Width ;
        Y := (Self.Height - Image.Height) div 2 ;
    end ;


    Canvas.Draw(X, Y, Image) ;

    { Trace un encadré si on est dans l'éditeur de composant }
    if (csDesigning in ComponentState) and not (csLoading in TControl(Owner).ComponentState)
    then begin
        Canvas.MoveTo(0,0);
        Canvas.Pen.Color := clBlack ;
        Canvas.Pen.Width := 1 ;
        Canvas.Brush.Style := bsClear	;
        Canvas.Pen.Style := psDash ;
        Canvas.LineTo(Self.Width - 1, 0);
        Canvas.LineTo(Self.Width - 1, Self.Height - 1);
        Canvas.LineTo(0, Self.Height - 1) ;
        Canvas.LineTo(0, 0) ;
    end ;

    if FShowCaption
    then begin
        if Enabled = False
        then begin
            Canvas.Font.Color := GetSysColor(COLOR_GRAYTEXT) ;
        end
        else begin
            if FStatus = sOver
            then begin
                Canvas.Font := FHotFont
            end
            else begin
                Canvas.Font := FFont ;
            end ;
        end ;

        if (FRect.Left = -1) or (FRect.Right = -1) or (FRect.Top = -1) or (FRect.Bottom = -1)
        then begin
            // affecter selon position de l'image
            if FTextPosition = tpBottom
            then begin
                TextRect.Top := 0 ;
                TextRect.Left := 0 ;
                TextRect.Bottom := Self.Height - Image.Height;
                TextRect.Right := Self.Width ;

                TextRect := SizeOfText(FCaption, TextRect) ;

                CurrentRect.Left := (Self.Width - TextRect.Right) div 2 ;

                if CurrentRect.Left < 0
                then
                    CurrentRect.Left := 0 ;

                CurrentRect.Top := Image.Height ;
                CurrentRect.Right := Self.Width ;
                CurrentRect.Bottom := Image.Height + TextRect.Bottom ;
            end
            else if FTextPosition = tpTop
            then begin
                TextRect.Top := 0 ;
                TextRect.Left := 0 ;
                TextRect.Bottom := Self.Height - Image.Height;
                TextRect.Right := Self.Width ;

                TextRect := SizeOfText(FCaption, TextRect) ;

                CurrentRect.Left := (Self.Width - TextRect.Right) div 2 ;

                if CurrentRect.Left < 0
                then
                    CurrentRect.Left := 0 ;

                CurrentRect.Top := 0 ;
                CurrentRect.Right := Self.Width ;

                if TextRect.Bottom > (Self.Height - Image.Height)
                then
                    CurrentRect.Bottom := Self.Height - Image.Height
                else
                    CurrentRect.Bottom := TextRect.Bottom ;

            end
            else if FTextPosition = tpLeft
            then begin
                TextRect.Top := 0 ;
                TextRect.Left := 0 ;
                TextRect.Bottom := 0 ;
                TextRect.Right := Self.Width - Image.Width ;

                TextRect := SizeOfText(FCaption, TextRect) ;

                CurrentRect.Left := 0 ;
                CurrentRect.Top := (Self.Height - TextRect.Bottom) div 2 ;

                if CurrentRect.Top < 0
                then
                    CurrentRect.Top := 0 ;

                CurrentRect.Right := Self.Width - Image.Width ;
                CurrentRect.Bottom := CurrentRect.Top + TextRect.Bottom ;
            end
            else if FTextPosition = tpRight
            then begin
                TextRect.Top := 0 ;
                TextRect.Left := 0 ;
                TextRect.Bottom := 0 ;
                TextRect.Right := Self.Width - Image.Width ;

                TextRect := SizeOfText(FCaption, TextRect) ;

                CurrentRect.Left := Image.Width ;
                CurrentRect.Top := (Self.Height - TextRect.Bottom) div 2 ;

                if CurrentRect.Top < 0
                then
                    CurrentRect.Top := 0 ;

                CurrentRect.Right := Self.Width ;
                CurrentRect.Bottom := CurrentRect.Top + TextRect.Bottom ;
            end ;
        end
        else begin
            CurrentRect := FRect ;
        end ;

        Canvas.Brush.Style := bsClear ;

        if (Focused) and (FTransparentColor <> FBackGroundFocusColor)
        then begin
            Canvas.Brush.Style := bsSolid ;
            Canvas.Brush.Color := FBackGroundFocusColor ;
            Canvas.FillRect(CurrentRect);
            Canvas.Font.Color := FTextFocusColor ;
        end ;

        if (FTextPosition = tpRight) or (FTextPosition = tpLeft)
        then
            fmt := DT_LEFT
        else
            fmt := DT_CENTER ;

        if FWordWrap
        then
            fmt := fmt or DT_WORDBREAK ;

        DrawText(Canvas.Handle, PChar(FCaption), length(FCaption), CurrentRect, fmt) ;

        if Focused
        then
            DrawFocusRect(Canvas.Handle, CurrentRect) ;
    end ;

    Image.Free ;
end;

{*******************************************************************************
 * Affecte l'attribut AutoSize
 ******************************************************************************}
procedure TImageButton.AutoSizeSet(asvalue: Boolean);
var TextRect : TRect ;
begin
    FAutoSize := asvalue ;

    if (FAutoSize = True) and (Assigned(FImageButton))
    then begin
        Width := FImageButton.Width;
        Height := FImageButton.Height;

        TextRect.Top := 0 ;
        TextRect.Left := 0 ;
        TextRect.Bottom := 0 ;
        TextRect.Right := 0 ;

        TextRect := SizeOfText(FCaption, TextRect) ;

        if (FShowCaption = True) and (FRect.Left = -1) and (FRect.Right = -1) and (FRect.Bottom = -1) and (FRect.Left = -1)
        then begin
            Width := Width + TextRect.Right ;
            Height := Height + TextRect.Bottom ;
        end
        else if (FShowCaption = False) and ((FRect.Left <> -1) or (FRect.Right <> -1) or (FRect.Bottom <> -1) or (FRect.Left <> -1))
        then begin
            Width := Width + FRect.Right ;
            Height := Height + FRect.Bottom ;
        end ;
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

    if Assigned(FOnMouseUp)
    then
        FOnMouseUp(Self, Button, Shift, X, Y) ;
end;

{*******************************************************************************
 * Affecte l'attribut IamgeButton
 ******************************************************************************}
procedure TImageButton.ImageButtonSet(NewBitmap: Graphics.TBitmap) ;
begin
    FImageButton.Assign(NewBitmap) ;
    AutoSizeSet(FAutoSize) ;

    FImageDisabled.Assign(NewBitmap) ;
    ColorPictureToGray(FImageDisabled) ;

    Invalidate ;
end;

{*******************************************************************************
 * Affecte l'attribut ImageMousOver
 ******************************************************************************}
procedure TImageButton.ImageMouseOverSet(NewBitmap: Graphics.TBitmap);
begin
    FImageMouseOver.Assign(NewBitmap) ;
    Invalidate ;
end;

{*******************************************************************************
 * Affecte l'attribut ImageDown
 ******************************************************************************}
procedure TImageButton.ImageDownSet(NewBitmap: Graphics.TBitmap);
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
  CurrentBitmap : Graphics.TBitmap ;
begin
    if FStatus <> sDisabled
    then begin
        OldStatus := FStatus ;

        { Est-ce que le on est sur le controle }
        if (x >= 0) and (x < Self.Width) and (y >= 0) and (y <= Self.Height)
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

    if Assigned(FOnMouseMove)
    then
        FOnMouseMove(Self, Shift, X, Y) ;
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

        MonButton.SetFocus ;

        inherited MouseDown(Button, Shift, X, Y) ;
    end ;

    if Assigned(FOnMouseDown)
    then
        FOnMouseDown(Self, Button, Shift, X, Y) ;
end;

{*******************************************************************************
 * Convertit un image en noir et blanc
 ******************************************************************************}
procedure TImageButton.ColorPictureToGray(Bitmap : Graphics.TBitmap) ;
var x, y : Integer ;
    oldcolor : TColor ;
    R, V, B : Integer ;
    Gray : Integer ;
begin
    Bitmap.PixelFormat := Pf24Bit;

    for x := 0 to Bitmap.Width - 1 do
    begin
        for y := 0 to Bitmap.Height - 1 do
        begin
            oldColor := Bitmap.Canvas.Pixels[x, y] ;

            if oldColor <> FTransparentColor
            then begin
                B := (OldColor and $FF0000) shr 16 ;
                V := (OldColor and $FF00) shr 8 ;
                R := (OldColor and $FF) ;

                R := (76 * R) div 255 ;
                V := (150 * V) div 255 ;
                B := (29 * B) div 255 ;

                Gray := R + V + B ;

                Bitmap.Canvas.Pixels[x, y] := (Gray shl 16) or (Gray shl 8) or Gray ;
            end ;
        end ;
    end ;
end ;

{*******************************************************************************
 * Affecte le texte du bouton
 ******************************************************************************}
procedure TImageButton.SetCaption(Text : string) ;
begin
    FCaption := Text ;
    
    if FShowCaption
    then
        Invalidate ;
end ;

{*******************************************************************************
 * Affecte l'affichage ou non du bouton
 ******************************************************************************}
procedure TImageButton.SetShowCaption(status : boolean) ;
begin
    if status <> FShowCaption
    then begin
        FShowCaption := status ;
        Invalidate ;
    end ;
end ;

{*******************************************************************************
 * Affecte la position du texte
 ******************************************************************************}
procedure TImageButton.SetTextPosition(position : TTextPosition) ;
begin
    if position <> FTextPosition
    then begin
        FTextPosition := position ;
        Invalidate ;
    end ;
end ;

{*******************************************************************************
 * Affecte la font
 ******************************************************************************}
procedure TImageButton.SetFont(NewFont : TFont) ;
begin
    FFont := NewFont ;
    Invalidate ;
end ;

{*******************************************************************************
 * Affecte s'il y a un retour à la ligne
 ******************************************************************************}
procedure TImageButton.SetWordWrap(status : boolean) ;
begin
    if status <> FWordWrap
    then begin
        FWordWrap := status ;

        if FShowCaption
        then
            Invalidate ;
    end ;
end ;

{*******************************************************************************
 * Affecte le rectangle d'affichage du texte 
 ******************************************************************************}
procedure TImageButton.SetRect(Rect : TRect) ;
begin
    FRect := Rect ;
    Invalidate ;
end ;

{*******************************************************************************
 * Calcule le rectangle occupé par le texte
 ******************************************************************************}
function TImageButton.SizeOfText(Text : String; Rect : TRect) : TRect ;
var TmpCanvas : TCanvas ;
begin
    TmpCanvas := TCanvas.Create ;
    TmpCanvas.Handle := GetDC(0) ;

    if FWordWrap
    then
        DrawText(TmpCanvas.Handle, PChar(FCaption), length(FCaption), Rect, DT_EXPANDTABS or DT_WORDBREAK or DT_CALCRECT) // or DT_VCENTER
    else
        DrawText(TmpCanvas.Handle, PChar(FCaption), length(FCaption), Rect, DT_EXPANDTABS or DT_CALCRECT) ; // or DT_VCENTER

    Result := Rect ;

    TmpCanvas.Handle := 0 ;
    TmpCanvas.Free ;
end ;

{*******************************************************************************
 * Affecte la hot font
 ******************************************************************************}
procedure TImageButton.SetHotFont(NewFont : TFont) ;
begin
    FHotFont := NewFont ;
    Invalidate ;
end ;

{*******************************************************************************
 * Appelé lorsque la souris passe sur le contrôle
 ******************************************************************************}
procedure TImageButton.CMMouseEnter(var msg:TMessage);
begin
    if Assigned(FOnMouseEnter)
    then
        FOnMouseEnter(Self) ;
end;

{*******************************************************************************
 * Appelé lorsque la souris sort du contrôle
 ******************************************************************************}
procedure TImageButton.CMMouseLeave(var msg:TMessage);
begin
    if Assigned(FOnMouseExit)
    then
        FOnMouseExit(Self) ;

end;

{*******************************************************************************
 * Affecte la possibilité d'afficher le focus rect
 ******************************************************************************}
procedure TImageButton.SetShowFocus(value : boolean) ;
begin
    FShowFocus := value ;
    Invalidate ;
end ;

{*******************************************************************************
 * On reçoit le focus
 ******************************************************************************}
procedure TImageButton.ButtonEnter(Sender: TObject);
begin
    Focused := True ;
    Invalidate ;

    if Assigned(FOnEnter)
    then
        FOnEnter(Self) ;
end ;

{*******************************************************************************
 * On perd le focus
 ******************************************************************************}
procedure TImageButton.ButtonExit(Sender: TObject);
begin
    Focused := False ;
    Invalidate ;

    if Assigned(FOnExit)
    then
        FonExit(Self) ;
end ;

{*******************************************************************************
 * Definit la couleur de fond du texte quand on a le focus
 ******************************************************************************}
procedure TImageButton.SetBackGroundFocus(couleur : TColor) ;
begin
    FBackGroundFocusColor := couleur ;
    Invalidate ;
end ;

{*******************************************************************************
 * Définit la couleur du texte quand on a le focus
 ******************************************************************************}
procedure TImageButton.SetTextFocus(couleur : TColor) ;
begin
    FTextFocusColor := couleur ;
    Invalidate ;
end ;


procedure Register;
begin
  RegisterComponents('WinEssential', [TImageButton]);
end;

end.
