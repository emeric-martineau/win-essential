{*******************************************************************************
 * TIE7Edit
 * Component of WinEssential project (http://php4php.free.fr/winessential/)
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.See the GGNU LESSER GENERAL PUBLIC LICENSE for more
 * details.
 *
 * You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE along
 * with this program; if not, write to the Free Software Foundation, Inc., 59
 * Temple Place, Suite 330, Boston, MA 02111-1307 USA.
 *
 *******************************************************************************
 * Version 1.0 by MARTINEAU Emeric (php4php.free.fr) - 29/02/2008
 ******************************************************************************}
unit IE7Edit;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls, Graphics, Registry,
  Forms, Menus ;

const WM_THEMECHANGED = 794 ;

      THEME_DLL = 'uxtheme.dll';

      {-------------------------------------------------------------------------
       "Edit" Parts and States
       ------------------------------------------------------------------------}
       {$EXTERNALSYM EP_EDITTEXT}
       EP_EDITTEXT = 1;
       {$EXTERNALSYM EP_CARET}
       EP_CARET = 2;

       {$EXTERNALSYM ETS_NORMAL}
       ETS_NORMAL = 1;
       {$EXTERNALSYM ETS_HOT}
       ETS_HOT = 2;
       {$EXTERNALSYM ETS_SELECTED}
       ETS_SELECTED = 3;
       {$EXTERNALSYM ETS_DISABLED}
       ETS_DISABLED = 4;
       {$EXTERNALSYM ETS_FOCUSED}
       ETS_FOCUSED = 5;
       {$EXTERNALSYM ETS_READONLY}
       ETS_READONLY = 6;
       {$EXTERNALSYM ETS_ASSIST}
       ETS_ASSIST = 7;
type
  {$EXTERNALSYM HTHEME}
  HTHEME = THandle;

  tIconPosition = (ipLeft, ipRight, ipNone) ;
  TIE7BorderStyle = (ie7bsNone, ie7bsSingle) ;
  tControl = (cButtonLeft, cButtonRight, cUpDownLeft, cUpDownRight, cNone) ;

  TIE7Edit = class(TWinControl)
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
    { couleur de fond }
    FBackGroundColor : TColor ;
    { Text affiché }
    FDefaultText : String ;
    { Couleur du survol }
    FHotBackGroundColor : TColor ;
    { Indique si on active la couleur de survol }
    FActiveHotColor : Boolean ;
    { Couleur de fond lorsque le control à le focus }
    FFocusBackGroundColor : TColor ;
    { couleur de fond si le control à le focus }
    FActiveFocusedColor : boolean ;
    { Font état normal }
    FFont : TFont ;
    { Font lorsque souris survol le composant }
    FHotFont : TFont ;
    { Font lorsque le composant à le focus }
    FFocusedFont : TFont ;
    { Font du texte par défaut }
    FDefaultTextFont : TFont ;
    { Icone à afficher }
    FIcon : TBitmap ;
    { Position de l'icone }
    FIconPosition : tIconPosition ;
    { Indique si on active la transparence de l'icone }
    FTransparentIcon : Boolean ;
    { Couleur de transparence }
    FTransparentColor : TColor ;
    { Type de bordure }
    FBorderStyle : TIE7BorderStyle ;
    { Hauteur du composant }
    FHeight : Integer ;
    { Indique si le control prend la couleur du parent }
    FParentColor : boolean ;
    { Indique si le control prend la font du parent }
    FParentFont : boolean ;
    { Caractère à afficher s'il s'agit d'un mot de passe }
    FPasswordChar : Char ;
    { Popup menu }
    FPopupMenu : TPopupMenu ;
    { Procedure lorsque le texte change }
    FOnChange : TNotifyEvent ;
    { Souris au dessus du control }
    FOnMouseEnter : TNotifyEvent ;
    { Souris sort du control }
    FOnMouseLeave : TNotifyEvent ;

    { PUBLICATION DES PROPRIETES DU TEDIT }
    FAutoSelect : boolean ;
    FAutoSize: boolean ;

    {-------------------------- Variables internes ----------------------------}
    { Indique si la souris est au-dessus du composant }
    MouseIsOver : Boolean ;
    { Est-ce que le theme est actif }
    Themed : boolean ;
    { variable qui pointe sur la dll de theme }
    handleProc : integer ;
    { variable pointant sur le thème du TEdit }
    hhTheme : HTHEME ;
    { Indique si on a le focus }
    Focused : Boolean ;
    { Control de saisie }
    EditControl : TEdit ;

    procedure WMPaint(var msg: TWMPaint); message WM_PAINT;
    procedure SetBackGroundColor(NewColor : TColor) ;
    procedure SetHotBackGroundColor(NewColor : TColor) ;
    procedure SetText(NewText : String) ;
    procedure SetDefaultText(DefaultText : String) ;
    procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    procedure MouseDown(var msg: TWMMouse); message WM_LBUTTONDOWN;
    procedure SetActiveHotColor(active : boolean) ;
    function  ThemeIsActive : boolean ;
    procedure StyleChanged( var msg:TMessage); message WM_THEMECHANGED; // Si le theme change sous Windows XP
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    // Désactivé car on passe le focus au EditControl
    //procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure SetFocusBackGroundColor(NewColor : TColor) ;
    procedure SetActiveFocusedColor(active : boolean) ;
    procedure SetFont(NewFont : TFont) ;
    procedure SetHotFont(NewFont : TFont) ;
    procedure SetFocusedFont(NewFont : TFont) ;
    procedure SetDefaultTextFont(NewFont : TFont) ;
    procedure SetIcon(NewIcon : TBitmap) ;
    procedure SetIconPosition(NewPosition : tIconPosition) ;
    procedure SetTransparentIcon(IsTransparent : boolean ) ;
    procedure SetTransparentColor(NewColor : TColor) ;
    procedure ShowText(Text : String; StartPos : Integer; EndPos : Integer; MyCanvas : TCanvas) ;
    procedure SetBorderStyle(NewBorder : TIE7BorderStyle) ;
    procedure MyOnEnter(Sender : TObject) ;
    procedure MyOnExit(Sender : TObject) ;
    procedure SetAutoSelect(NewSelect : boolean) ;
    procedure SetAutoSize(NewValue : boolean) ; override ;
    procedure SetHeight(NewHeight : Integer) ;
    function  GetText : String ;
    procedure SetCharCase(NewCase : TEditCharCase) ;
    function  GetCharCase : TEditCharCase ;
    procedure SetDragCursor(NewCursor : TCursor) ;
    function  GetDragCursor : TCursor ;
    procedure MySetEnabled(NewStatus : boolean) ;
    function  MyGetEnabled : boolean ;
    procedure SetHideSelection(NewStatus : boolean) ;
    function  GetHideSelection : boolean ;
    procedure SetImeMode(NewValue : TImeMode) ;
    function  GetImeMode : TImeMode ;
    procedure SetImeName(NewValue : TImeName) ;
    function  GetImeName : TImeName ;
    procedure SetMaxLength(Value : Integer) ;
    function  GetMaxLength : Integer ;
    procedure SetOEMConvert(value : boolean) ;
    function  GetOEMConvert : boolean ;
    procedure SetParentColor(value : boolean) ;
    procedure SetParentFont(value : boolean) ;
    procedure SetPasswordChar(NewChar : Char) ;
    procedure SetPopupMenu(NewPopupMenu : TPopupMenu) ;
    procedure MySetReadOnly(NewStatus : boolean) ;
    function  MyGetReadOnly : boolean ;
    procedure SetShowHint(value : boolean) ;
    function  GetShowHint : boolean ;
    procedure SetTabOrder(value : TTabOrder) ;
    function  GetTabOrder : TTabOrder ;
    procedure SetTabStop(value : boolean) ;
    function  GetTabStop : boolean ;
    procedure EditChange(Sender: TObject) ;
    procedure EditClick(Sender: TObject) ;
    procedure EditContextPopup(Sender: TObject; MousePos: TPoint;
            var Handled: Boolean);
    procedure EditDblClick(Sender: TObject) ;
    procedure EditDragDrop(Sender, Source: TObject; X, Y: Integer) ;
    procedure EditDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean) ;
    procedure EditEndDock(Sender, Target: TObject; X, Y: Integer) ;
    procedure EditEndDrag(Sender, Target: TObject; X, Y: Integer) ;
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState) ;
    procedure EditKeyPress(Sender: TObject; var Key: Char) ;
    procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState) ;
    procedure EditStartDock(Sender: TObject; var DragObject: TDragDockObject) ;
    procedure EditStartDrag(Sender: TObject; var DragObject: TDragObject) ;
    procedure EditMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) ;
    procedure EditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer) ;
    procedure EditMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) ;
  public
    { Déclarations publiques }
      constructor Create(Owner:TComponent); override;
      destructor Destroy; override;
  published
    { Déclarations publiées }
    property Anchors;
    property BiDiMode ;
    property Constraints;
    property Ctl3D;
    property DragKind ;
    property DragMode;
    property ParentBiDiMode ;
    property ParentCtl3D;
    property ParentShowHint;
    property Visible;
    property OnEnter;
    property OnExit;

    property BackGroundColor : TColor read FBackGroundColor write SetBackGroundColor default clWindow ;
    property HotBackGroundColor : TColor read FHotBackGroundColor write SetHotBackGroundColor default clWindow ;    
    property Text : String read GetText write SetText ;
    property DefaultText : String read FDefaultText write SetDefaultText ;
    property ActiveHotColor : boolean read FActiveHotColor write SetActiveHotColor default false ;
    property FocusBackGroundColor : TColor read FFocusBackGroundColor write SetFocusBackGroundColor default clWindow ;
    property ActiveFocusedColor : boolean read FActiveFocusedColor write SetActiveFocusedColor default false ;
    property Font : TFont read FFont write SetFont ;
    property HotFont : TFont read FHotFont write SetHotFont ;
    property FocusedFont : TFont read FFocusedFont write SetFocusedFont ;
    property DefaultTextFont : TFont read FDefaultTextFont write SetDefaultTextFont ;
    property Icon : TBitmap read FIcon write SetIcon ;
    property IconPosition : tIconPosition read FIconPosition write SetIconPosition default ipNone ;
    property TransparentIcon : boolean read FTransparentIcon write SetTransparentIcon default True ;
    property TransparentColor : TColor read FTransparentColor write SetTransparentColor default clFuchsia ;
    property BorderStyle : TIE7BorderStyle read FBorderStyle write SetBorderStyle default ie7bsSingle ;
    property AutoSelect : boolean read FAutoSelect write SetAutoSelect default true ;
    property AutoSize : boolean read FAutoSize write SetAutoSize default true ;
    property Height : Integer read FHeight write SetHeight default 21 ;
    property CharCase : TEditCharCase read GetCharCase write SetCharCase default ecNormal ;
    property DragCursor : TCursor read GetDragCursor write SetDragCursor default crDrag ;
    property Enabled : boolean read GetEnabled write SetEnabled default true ;
    property HideSelection : boolean read GetHideSelection write SetHideSelection default true ;
    property ImeMode : TImeMode read GetImeMode write SetImeMode default imDontCare ;
    property ImeName : TImeName read GetImeName write SetImeName ;
    property MaxLength : Integer read GetMaxLength write SetMaxLength default 0 ;
    property OEMConvert : boolean read GetOEMConvert write SetOEMConvert default false ;
    property ParentColor : boolean read FParentColor write SetParentColor default False ;
    property ParentFont : boolean read FParentFont write SetParentFont default True ;
    property PasswordChar : Char read FPasswordChar write SetPasswordChar default #0 ;
    property PopupMenu : TPopupMenu read FPopupMenu write SetPopupMenu ;
    property ReadOnly : boolean read MyGetReadOnly write MySetReadOnly default false ;
    property ShowHint : boolean read GetShowHint write SetShowHint default false ;
    property TabOrder : TTabOrder read GetTabOrder write SetTabOrder ;
    property TabStop : boolean read GetTabStop write SetTabStop default true ;
    property OnChange : TNotifyEvent read FOnChange write FOnChange ;
    property OnMouseEnter : TNotifyEvent read FOnMouseEnter write FOnMouseEnter ;
    property OnMouseLeave : TNotifyEvent read FOnMouseLeave write FOnMouseLeave ;
  end;

var
  OpenThemeData : function (
    hWnd : THandle;
    pszClassList : LPCWSTR) : HTHEME stdcall;

  CloseThemeData : function (
    hTheme : HTHEME) : HResult stdcall;

  DrawThemeBackground : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    const pRect : PRect;
    const pClipRect : PRect) : HResult stdcall;

procedure Register;

implementation

constructor TIE7Edit.Create(Owner:TComponent);
begin
    inherited ;

    inherited Width := 121 ;
    inherited Height := 21 ;

    FHeight := 21 ;

    FBackGroundColor := clWindow ;
    FHotBackGroundColor := clWindow ;
    Self.Visible := True ;
    FDefaultText := Self.Name ;
    FActiveHotColor := False ;
    FFocusBackGroundColor := clWindow ;
    FActiveFocusedColor := False ;

    FFont := TFont.Create ;
    FHotFont := TFont.Create ;
    FFocusedFont := TFont.Create ;
    FDefaultTextFont := TFont.Create ;

    FDefaultTextFont.Color := clGrayText ;

    FIcon := TBitmap.Create ;
    FIcon.TransparentMode := tmFixed ;
    FIcon.Transparent := True ;
    FIcon.TransparentColor := clFuchsia ;

    FIconPosition := ipNone ;
    FTransparentIcon := True ;
    FTransparentColor := clFuchsia ;

    FBorderStyle := ie7bsSingle ;

    FAutoSelect := True ;
    FAutoSize := True ;

    FParentColor := False ;
    FParentFont := True ;

    FOnMouseEnter := nil ;
    FOnMouseLeave := nil ;

    MouseIsOver := False ;
    Cursor := crIBeam ;
    Themed := ThemeIsActive ;
    Focused := False ;

    { Indique qu'on réagit à la tabulation }
    inherited TabStop := False ;

    handleProc := LoadLibrary(THEME_DLL);

    { Charge les librairies pour la gestion des thèmes }
    if handleProc <> 0
    then begin
        @OpenThemeData := GetProcAddress(handleProc, 'OpenThemeData');
        @CloseThemeData := GetProcAddress(handleProc, 'CloseThemeData');
        @DrawThemeBackground := GetProcAddress(handleProc, 'DrawThemeBackground');

        hhTheme:= OpenThemeData(0, 'Edit');
    end ;

    EditControl := TEdit.Create(Self);
    EditControl.Parent := Self ;
    EditControl.Width := inherited Width ;
    EditControl.Height := inherited Height ;
    EditControl.TabStop := True ;    
    EditControl.BorderStyle := bsNone ;
    EditControl.OnEnter := MyOnEnter ;
    EditControl.OnExit := MyOnExit ;
    EditControl.AutoSelect := True ;
    EditControl.AutoSize := False ;
    EditControl.ParentBiDiMode := True ;
    EditControl.OnChange := EditChange ;
    EditControl.OnClick := EditClick ;
    EditControl.OnContextPopup := EditContextPopup ;
    EditControl.OnDblClick := EditDblClick ;
    EditControl.OnDragDrop := EditDragDrop ;
    EditControl.OnDragOver := EditDragOver ;
    EditControl.OnEndDock := EditEndDock ;
    EditControl.OnEndDrag := EditEndDrag ;
    EditControl.OnKeyDown := EditKeyDown ;
    EditControl.OnKeyPress := EditKeyPress ;
    EditControl.OnKeyUp := EditKeyUp ;
    EditControl.OnStartDock := EditStartDock ;
    EditControl.OnStartDrag := EditStartDrag ;
    EditControl.OnMouseDown := EditMouseDown ;
    EditControl.OnMouseMove := EditMouseMove ;
    EditControl.OnMouseUp := EditMouseUp ;
end ;

destructor TIE7Edit.Destroy;
begin
    if HandleProc <> 0
    then begin
         CloseThemeData(hhTheme) ;
         FreeLibrary(HandleProc);
    end ;

    FFont.Free ;
    FHotFont.Free ;
    FFocusedFont.Free ;
    FDefaultTextFont.Free ;
    FIcon.Free ;

    EditControl.Free ;
    
    inherited ;
end ;

{*******************************************************************************
 * Affecte la couleur de fond
 ******************************************************************************}
procedure TIE7Edit.SetBackGroundColor(NewColor : TColor) ;
begin
    if NewColor <> FBackGroundColor
    then begin
        FBackGroundColor := NewColor ;
        Invalidate ;
    end ;
end ;

{*******************************************************************************
 * Affecte la couleur de fond
 ******************************************************************************}
procedure TIE7Edit.SetHotBackGroundColor(NewColor : TColor) ;
begin
    if NewColor <> FHotBackGroundColor
    then begin
        FHotBackGroundColor := NewColor ;
        Invalidate ;
    end ;
end ;

{*******************************************************************************
 * Change le texte
 ******************************************************************************}
procedure TIE7Edit.SetText(NewText : String) ;
begin
    EditControl.Text := NewText ;
    Invalidate ;
end ;

{*******************************************************************************
 * Change le texte par défaut
 ******************************************************************************}
procedure TIE7Edit.SetDefaultText(DefaultText : String) ;
begin
    FDefaultText := DefaultText ;
    Invalidate ;
end ;


{*******************************************************************************
 * Affecte la couleur de fond
 ******************************************************************************}
procedure TIE7Edit.WMPaint(var msg: TWMPaint);
var MyCanvas : TCanvas ;
    PaintInfo: TPaintStruct;
    WindowROrig : Trect ;
    Style : Integer ;
    X, Y : Integer ;
    PosStartText : Integer ;
    PosEndText : Integer ;
    TmpIcon : TBitmap ;
    PosImage : Integer ;
    TmpTextImage : TBitmap ;
    HauteurLettre : Integer ;
    EpaisseurBordure : SmallInt ;
begin
    BeginPaint(Handle, PaintInfo);

    MyCanvas := TCanvas.Create ;

    try
        MyCanvas.Handle := GetDC(Self.Handle);

        MyCanvas.Lock ;

        if not IsRectEmpty(PaintInfo.rcPaint) and (ClientWidth > 0) and (ClientHeight > 0) then
        begin
            { Crée le fond }
            MyCanvas.Brush.Style := bsSolid ;

            if MouseIsOver
            then begin
                MyCanvas.Brush.color := FHotBackGroundColor ;
                MyCanvas.Font.Assign(FHotFont);
            end
            else if Focused and FActiveFocusedColor
            then begin
                MyCanvas.Brush.color := FFocusBackGroundColor ;
                MyCanvas.Font.Assign(FFocusedFont);
            end
            else begin
                if FParentColor
                then
                    MyCanvas.Brush.color := inherited color
                else
                    MyCanvas.Brush.color := FBackGroundColor ;

                if FParentFont
                then
                    MyCanvas.Font.Assign(inherited Font)
                else
                    MyCanvas.Font.Assign(FFont);
            end ;

            if FBorderStyle = ie7bsSingle
            then begin
                { Dessine le contour }
                if not Themed
                then begin
                    FillRect(MyCanvas.Handle, PaintInfo.rcPaint, MyCanvas.Brush.Handle);

                    {1 +-
                       |
                    }
                    MyCanvas.Pen.Style := psSolid ;
                    MyCanvas.Pen.Color := clGrayText ;
                    MyCanvas.MoveTo(0, Self.Height - 1);
                    MyCanvas.LineTo(0, 0);
                    MyCanvas.LineTo(Self.Width - 1, 0) ;

                    {2  +
                        |
                      +-+
                    }
                    MyCanvas.Pen.Color := clWindow ;
                    MyCanvas.LineTo(Self.Width - 1, Self.Height - 1) ;
                    MyCanvas.LineTo(-1, Self.Height - 1) ;

                    { idem 1 }
                    MyCanvas.Pen.Color := cl3DDkShadow ;
                    MyCanvas.MoveTo(1, Self.Height - 2);
                    MyCanvas.LineTo(1, 1);
                    MyCanvas.LineTo(Self.Width - 2, 1) ;

                    { idem 2 }
                    MyCanvas.Pen.Color := clBtnFace ;
                    MyCanvas.LineTo(Self.Width - 2, Self.Height - 2) ;
                    MyCanvas.LineTo(0, Self.Height - 2) ;

                    EpaisseurBordure := 2 ;
                end
                else begin
                    { Contour XP/Vista }
                    WindowROrig := Rect(0,0,Self.Width, Self.Height) ;

                    if MouseIsOver and Enabled
                    then
                        Style := ETS_HOT
                    else if not Enabled
                    then
                        Style := ETS_DISABLED
                    else if Focused
                    then
                        Style := ETS_FOCUSED
                    else if EditControl.ReadOnly and Enabled
                    then
                        Style := ETS_READONLY
                    else
                        Style := ETS_NORMAL ;

                    DrawThemeBackground(hhTheme, MyCanvas.Handle, EP_EDITTEXT, Style, @WindowROrig, nil);

                    if (Self.Width > 2) and (Self.Height > 2)
                    then begin
                        { Il faut que la largeur ou la hauteur soit suppérieur à 2
                          car sinon on colorie la bordure }
                        X := Self.Width div 2 ;
                        Y := Self.Height div 2 ;

                        MyCanvas.FloodFill(X, Y, MyCanvas.Pixels[X, Y], fsSurface) ;
                    end ;

                    EpaisseurBordure := 1 ;
                end ;
            end
            else begin
                EpaisseurBordure := 0 ;

                MyCanvas.FillRect(Rect(0,0, Self.Width, Self.Height));
            end ;

            { Position du texte en fonction de la position de l'icone }
            if FIconPosition = ipNone
            then begin
                PosStartText := 2 + EpaisseurBordure ;
                PosEndText := Self.Width ;
            end
            else if FIconPosition = ipLeft
            then begin
                PosStartText := FIcon.Width + EpaisseurBordure ; // + 1 ;
                PosEndText := Self.Width ;
            end
            else begin
                PosStartText := 2 + EpaisseurBordure ;
                PosEndText := Self.Width - FIcon.Width - (EpaisseurBordure * 2) ; //- 1;
            end ;

            { On dessine le texte sur une image car sinon le texte déborde sur
              les bordures si le controle n'est pas assez grand }
            TmpTextImage := TBitmap.Create ;
            TmpTextImage.Width := PosEndText - PosStartText - 1 ;

            if (FDefaultText <> '') and (EditControl.Text = '') and (not Focused)
            then begin
                MyCanvas.Font.Assign(FDefaultTextFont) ;
            end ;

            HauteurLettre := MyCanvas.TextHeight('X') ;

            { Calcule la taille de l'image recevant le texte }
            if HauteurLettre < Self.Height - (2 + EpaisseurBordure * 2)
            then
                TmpTextImage.Height := HauteurLettre
            else
                TmpTextImage.Height := Self.Height - (2 + EpaisseurBordure * 2) ;

            TmpTextImage.Canvas.Brush.Color := MyCanvas.Brush.color ;

            TmptextImage.Canvas.FillRect(Rect(0, 0, TmpTextImage.Width, TmpTextImage.Height));

            { S'il y a un texte par défaut et pas de texte }
            if (FDefaultText <> '') and (EditControl.Text = '') and (not Focused)
            then begin
                EditControl.Visible := False ;
                TmpTextImage.Canvas.Font.Assign(FDefaultTextFont);
                ShowText(FDefaultText, 0, PosEndText, TmpTextImage.Canvas) ;
            end
            else begin
                EditControl.Color := MyCanvas.Brush.color ;

                EditControl.Font.Assign(MyCanvas.Font) ;

                EditControl.Width := TmpTextImage.Width - 1;

                if FIconPosition = ipLeft
                then begin
                    EditControl.Left := EpaisseurBordure + FIcon.Width ;
                end
                else begin
                    EditControl.Left := EpaisseurBordure ;
                end ;

                EditControl.Height := TmpTextImage.Height ;
                EditControl.Top := ((Self.Height - TmpTextImage.Height) div 2) ;

                EditControl.Visible := True ;
            end ;

            MyCanvas.Draw(PosStartText, (Self.Height - TmpTextImage.Height) div 2, TmpTextImage);

            TmpTextImage.Free ;

            { Affichage de l'icone }
            if FIconPosition <> ipNone
            then begin
                TmpIcon := TBitmap.Create ;

                TmpIcon.TransparentColor := FIcon.TransparentColor ;
                TmpIcon.TransparentMode := FIcon.TransparentMode ;
                TmpIcon.Transparent := FIcon.Transparent ;

                TmpIcon.Assign(FIcon);

                if TmpIcon.Height >= Self.Height
                then begin
                    TmpIcon.Height := Self.Height - (EpaisseurBordure * 2)
                end ;

                if FIconPosition = ipLeft
                then begin
                    PosImage := EpaisseurBordure ;
                end
                else begin
                    PosImage := Self.Width - FIcon.Width - EpaisseurBordure ;
                end ;

                MyCanvas.Draw(PosImage, (Self.Height - TmpIcon.Height) div 2, TmpIcon);

                TmpIcon.Free ;
            end ;
        end ;
    finally
        MyCanvas.UnLock ;
        MyCanvas.Free ;
    end ;

    EndPaint(Handle, PaintInfo);
end ;


{*******************************************************************************
 * La souris entre sur le composant
 ******************************************************************************}
procedure TIE7Edit.CMMouseEnter(var msg: TMessage);
begin
    if FActiveHotColor
    then begin
        MouseIsOver := True ;
        Invalidate ;
    end ;

    if Assigned(FOnMouseEnter)
    then
        FOnMouseEnter(Self) ;
end ;

{*******************************************************************************
 * La souris sort du composant
 ******************************************************************************}
procedure TIE7Edit.CMMouseLeave(var msg: TMessage);
begin
    if FActiveHotColor
    then begin
        MouseIsOver := False ;
        Invalidate ;
    end ;

    if Assigned(FOnMouseLeave)
    then
        FOnMouseLeave(Self) ;

end ;

{*******************************************************************************
 * Indique si on utilise le mode survol du composant
 ******************************************************************************}
procedure TIE7Edit.SetActiveHotColor(active : boolean) ;
begin
    if active <> FActiveHotColor
    then begin
        FActiveHotColor := active ;
        MouseIsOver := False ;        
        Invalidate ;
    end ;
end ;

{*******************************************************************************
 * Vérifie qu'il s'agit des CommonControl version 6 ou supérieur
 ******************************************************************************}
function TIE7Edit.ThemeIsActive : boolean ;
var Registre : TRegistry ;
begin
    Result := False ;

    Registre := TRegistry.Create ;

    try
        Registre.RootKey := HKEY_CURRENT_USER ;

        if Registre.OpenKey('\Software\Microsoft\Windows\CurrentVersion\ThemeManager', False)
        then begin
            Result := (Registre.ReadString('ThemeActive') = '1') ;
            Registre.CloseKey;
        end;
    finally
        Registre.Free;
    end ;
end ;

{*******************************************************************************
 * Procedure appelé si le theme XP change
 ******************************************************************************}
procedure TIE7Edit.StyleChanged( var msg:TMessage);
begin
    if Themed
    then
        CloseThemeData(hhTheme) ;
        
    Themed := ThemeIsActive ;

    if (HandleProc <> 0) and (Themed = true)
    then begin
        hhTheme:= OpenThemeData(0, 'Edit');
    end ;
end ;

{*******************************************************************************
 * Appeler lorsqu'on rentre avec Tab
 ******************************************************************************}
procedure TIE7Edit.WMSetFocus(var Msg: TWMSetFocus);
begin
    inherited;

    EditControl.SetFocus ;
end ;

{*******************************************************************************
 * Appeler lorsqu'on modifie la valeur de ActiveFocusedColor
 ******************************************************************************}
procedure TIE7Edit.SetActiveFocusedColor(active : boolean) ;
begin
    if active <> FActiveFocusedColor
    then begin
        FActiveFocusedColor := active ;

        if Focused
        then begin
            Invalidate ;
        end ;
    end ;
end ;

{*******************************************************************************
 * Appeler lorsqu'on modifie la couleur de fond lorsque le control à le focus
 ******************************************************************************}
procedure TIE7Edit.SetFocusBackGroundColor(NewColor : TColor) ;
begin
    if FFocusBackGroundColor <> NewColor
    then begin
        FFocusBackGroundColor := NewColor ;
        Invalidate ;
    end ;
end ;

{*******************************************************************************
 * Appeler lorsqu'on modifie la font
 ******************************************************************************}
procedure TIE7Edit.SetFont(NewFont : TFont) ;
var EpaisseurBordure : Integer ;
begin
    FFont := NewFont ;

    EditControl.Font.Assign(NewFont);

    if FAutoSize
    then begin
        { Passe à la nouvelle taille }
        EditControl.AutoSize := True ;

        { Désactive la taille auto }
        EditControl.AutoSize := False ;

        if FBorderStyle = ie7bsSingle
        then begin
            if not Themed
            then begin
                EpaisseurBordure := 2 ;
            end
            else begin
                EpaisseurBordure := 1 ;
            end ;
        end
        else begin
            EpaisseurBordure := 0 ;
        end ;

        FHeight := EditControl.Height + (EpaisseurBordure * 2) ;
    end ;

    Invalidate ;
end ;

{*******************************************************************************
 * Appeler lorsqu'on modifie la font
 ******************************************************************************}
procedure TIE7Edit.SetHotFont(NewFont : TFont) ;
begin
    FHotFont := NewFont ;
    Invalidate ;
end ;

{*******************************************************************************
 * Appeler lorsqu'on modifie la font
 ******************************************************************************}
procedure TIE7Edit.SetFocusedFont(NewFont : TFont) ;
begin
    FFocusedFont := NewFont ;
    Invalidate ;
end ;

{*******************************************************************************
 * Appeler lorsqu'on modifie la font du texte par défaut
 ******************************************************************************}
procedure TIE7Edit.SetDefaultTextFont(NewFont : TFont) ;
begin
    FDefaultTextFont := NewFont ;
    Invalidate ;
end ;

{*******************************************************************************
 * Appeler lorsqu'on affecte une icone
 ******************************************************************************}
procedure TIE7Edit.SetIcon(NewIcon : TBitmap) ;
begin
    FIcon.Assign(NewIcon) ;

    EditControl.Width := EditControl.Width - FIcon.Width ; 

    Invalidate ;
end ;

{*******************************************************************************
 * Appeler lorsqu'on affecte une icone
 ******************************************************************************}
procedure TIE7Edit.SetIconPosition(NewPosition : tIconPosition) ;
begin
    FIconPosition := NewPosition ;
    Invalidate ;
end ;

{*******************************************************************************
 * Appeler lorsqu'on affecte une icone
 ******************************************************************************}
procedure TIE7Edit.SetTransparentIcon(IsTransparent : Boolean) ;
begin
    if IsTransparent <> FTransparentIcon
    then begin
        FTransparentIcon := IsTransparent ;
        FIcon.Transparent := IsTransparent ;

        Invalidate ;
    end ;
end ;

{*******************************************************************************
 * Appeler lorsqu'on affecte une icone
 ******************************************************************************}
procedure TIE7Edit.SetTransparentColor(NewColor : TColor) ;
begin
    if FTransparentColor <> NewColor
    then begin
        FTransparentColor := NewColor ;
        FIcon.TransparentColor := NewColor ;

        Invalidate ;
    end ;
end ;

{*******************************************************************************
 * Affiche un texte dans une limite donnée
 ******************************************************************************}
procedure TIE7Edit.ShowText(Text : String; StartPos : Integer; EndPos : Integer; MyCanvas : TCanvas) ;
var TailleLettre : Integer ;
    i : Integer ;
    { Mémorise la couleur de fond pour le texte non sélectionné }
begin
    for i := 1 to Length(Text) do
    begin
        TailleLettre := MyCanvas.TextWidth(Text[i]) ;

        if (StartPos >= EndPos) or (StartPos + TailleLettre >= EndPos)
        then
            break ;

        MyCanvas.TextOut(StartPos, 0, Text[i]);

        StartPos := StartPos + TailleLettre ;
    end ;
end ;

{*******************************************************************************
 * Change type de bordure
 ******************************************************************************}
procedure TIE7Edit.SetBorderStyle(NewBorder : TIE7BorderStyle) ;
begin
    if FBorderStyle <> NewBorder
    then begin
        FBorderStyle := NewBorder ;
        Invalidate ;
    end ;
end ;

{*******************************************************************************
 * Appelé si EditControl reçoit le focus
 ******************************************************************************}
procedure TIE7Edit.MyOnEnter(Sender : TObject) ;
begin
    Focused := True ;

    Invalidate ;

    if Assigned(OnEnter)
    then
        OnEnter(Self) ;
end ;

{*******************************************************************************
 * Appelé si EditControl perd le focus
 ******************************************************************************}
procedure TIE7Edit.MyOnExit(Sender : TObject) ;
begin
    Focused := False ;

    Invalidate ;

    if Assigned(OnExit)
    then
        OnExit(Self) ;
end ;

{*******************************************************************************
 * Modifie l'attribut AutoSelect de EditControl
 ******************************************************************************}
procedure TIE7Edit.SetAutoSelect(NewSelect : boolean) ;
begin
    if NewSelect <> FAutoSelect
    then begin
        FAutoSelect := NewSelect ;
        EditControl.AutoSelect := NewSelect ;
    end ;
end ;

{*******************************************************************************
 * Modifie l'attribut AutoSize de EditControl
 ******************************************************************************}
procedure TIE7Edit.SetAutoSize(NewValue : boolean) ;
begin
    if FAutoSize <> NewValue
    then begin
        FAutoSize := NewValue ;
        EditControl.AutoSize := NewValue ;
        Self.Height := EditControl.Height ;
    end ;
end ;

{*******************************************************************************
 * Affecte la nouvelle hauteur
 ******************************************************************************}
procedure TIE7Edit.SetHeight(NewHeight : Integer) ;
var EpaisseurBordure : Integer ;
    MyCanvas : TCanvas ;
begin
    if (NewHeight <> FHeight) and (FAutoSize = False)
    then begin
        FHeight := NewHeight ;
        inherited Height := FHeight ;
    end
    else if FAutoSize
    then begin
        MyCanvas := TCanvas.Create ;
        MyCanvas.Font.Assign(FFont) ;

        MyCanvas.Handle := GetDC(Self.Handle);

        MyCanvas.Lock ;

        EditControl.Height := MyCanvas.TextHeight('X') ;

        MyCanvas.Unlock ;

        MyCanvas.Free ;

        if FBorderStyle = ie7bsSingle
        then begin
            if not Themed
            then begin
                EpaisseurBordure := 2 ;
            end
            else begin
                EpaisseurBordure := 1 ;
            end ;
        end
        else begin
            EpaisseurBordure := 0 ;
        end ;

        // + 6 pour que ça soit plus joli
        FHeight := EditControl.Height + (EpaisseurBordure * 2) + 6 ;
        Inherited Height := FHeight ;
    end ;
end ;

{*******************************************************************************
 * Change le texte
 ******************************************************************************}
function TIE7Edit.GetText : String ;
begin
    Result := EditControl.Text ;
end ;

{*******************************************************************************
 * Si on clique sur le composant, on passe le control ou TEdit
 ******************************************************************************}
procedure TIE7Edit.MouseDown(var msg: TWMMouse);
begin
    if EditControl.Enabled
    then begin
        EditControl.Visible := True ;
        EditControl.SetFocus ;
    end ;
end ;

{-------------------------------------------------------------------------------
  Republication des propriétés de TEdit
 ------------------------------------------------------------------------------}
procedure TIE7Edit.SetCharCase(NewCase : TEditCharCase) ;
begin
    EditControl.CharCase := NewCase ;
end ;

function  TIE7Edit.GetCharCase : TEditCharCase ;
begin
    Result := EditControl.CharCase ;
end ;

procedure TIE7Edit.SetDragCursor(NewCursor : TCursor) ;
begin
    EditControl.DragCursor := NewCursor ;
    inherited DragCursor := NewCursor ;
end ;

function  TIE7Edit.GetDragCursor : TCursor ;
begin
    Result := EditControl.DragCursor ;
end ;

procedure TIE7Edit.MySetEnabled(NewStatus : boolean) ;
begin
    EditControl.Enabled := NewStatus ;
    inherited Enabled := NewStatus ;
end ;

function  TIE7Edit.MyGetEnabled : boolean ;
begin
    Result := inherited Enabled ;
end ;

procedure TIE7Edit.SetHideSelection(NewStatus : boolean) ;
begin
    EditControl.HideSelection := NewStatus ;
end ;

function  TIE7Edit.GetHideSelection : boolean ;
begin
    Result := EditControl.HideSelection ;
end ;

procedure TIE7Edit.SetImeMode(NewValue : TImeMode) ;
begin
    EditControl.ImeMode := NewValue ;
end ;

function  TIE7Edit.GetImeMode : TImeMode ;
begin
    Result := EditControl.ImeMode ;
end ;

procedure TIE7Edit.SetImeName(NewValue : TImeName) ;
begin
    EditControl.ImeName := NewValue ;
end ;

function  TIE7Edit.GetImeName : TImeName ;
begin
    Result := EditControl.ImeName ;
end ;

procedure TIE7Edit.SetMaxLength(Value : Integer) ;
begin
    EditControl.MaxLength := Value ;
end ;

function  TIE7Edit.GetMaxLength : Integer ;
begin
    result := EditControl.MaxLength ;
end ;

procedure TIE7Edit.SetOEMConvert(value : boolean) ;
begin
    EditControl.OEMConvert := value ;
end ;

function  TIE7Edit.GetOEMConvert : boolean ;
begin
    Result := EditControl.OEMConvert ;
end ;

procedure TIE7Edit.SetParentColor(value : boolean) ;
begin
    if FParentColor <> value
    then begin
        FParentColor := value ;
        inherited ParentColor := Value ;

        if (value = true)
        then begin
            FBackGroundColor := inherited Color ;

            Invalidate ;
        end ;
    end ;
end ;

procedure TIE7Edit.SetParentFont(value : boolean) ;
begin
    if FParentFont <> value
    then begin
        FParentFont := value ;
        inherited Parentfont := value ;

        if (value = true)
        then begin
            FFont := inherited font ;

            Invalidate ;
        end ;
    end ;
end ;

procedure TIE7Edit.SetPasswordChar(NewChar : Char) ;
begin
     EditControl.PasswordChar := NewChar ;
end ;

procedure TIE7Edit.SetPopupMenu(NewPopupMenu : TPopupMenu) ;
begin
    EditControl.PopupMenu := NewPopUpMenu ;
end ;

procedure TIE7Edit.MySetReadOnly(NewStatus : boolean) ;
begin
    EditControl.ReadOnly := NewStatus ;
end ;

function  TIE7Edit.MyGetReadOnly : boolean ;
begin
    Result := EditControl.ReadOnly ;
end ;

procedure TIE7Edit.SetShowHint(value : boolean) ;
begin
    inherited ShowHint := value ;
    EditControl.ShowHint := value ;
end ;

function  TIE7Edit.GetShowHint : boolean ;
begin
    Result := inherited ShowHint ;
end ;

procedure TIE7Edit.SetTabOrder(value : TTabOrder) ;
begin
    EditControl.TabOrder := Value;
end ;

function  TIE7Edit.GetTabOrder : TTabOrder ;
begin
    result := EditControl.TabOrder ;
end ;

procedure TIE7Edit.SetTabStop(value : boolean) ;
begin
    EditControl.TabStop := value ;
end ;

function  TIE7Edit.GetTabStop : boolean ;
begin
    Result := EditControl.TabStop ;
end ;

procedure TIE7Edit.EditChange(Sender: TObject) ;
begin
    if Assigned(FOnChange)
    then
        FOnChange(Self) ;
end ;

procedure TIE7Edit.EditClick(Sender: TObject) ;
begin
    if Assigned(OnClick)
    then
        OnClick(Self) ;
end ;

procedure TIE7Edit.EditContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
    if Assigned(OnContextPopup)
    then
        OnContextPopup(Sender, MousePos, Handled) ;
end ;

procedure TIE7Edit.EditDblClick(Sender: TObject) ;
begin
    if Assigned(OnDblClick)
    then
        OnDblClick(Self) ;
end ;

procedure TIE7Edit.EditDragDrop(Sender, Source: TObject; X, Y: Integer) ;
begin
    if Assigned(OnDragDrop)
    then
        DragDrop(Source, X, Y) ;
end ;

procedure TIE7Edit.EditDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean) ;
begin
    if Assigned(OnDragOver)
    then
        OnDragOver(Self, Source, X, Y, State, Accept) ;
end ;

procedure TIE7Edit.EditEndDock(Sender, Target: TObject; X, Y: Integer) ;
begin
    if Assigned(OnEndDock)
    then
        OnEndDock(Self, Target, X, Y) ;
end ;

procedure TIE7Edit.EditEndDrag(Sender, Target: TObject; X, Y: Integer) ;
begin
    if Assigned(OnEndDrag)
    then
       OnEndDrag(Self, Target, X, Y) ;
end ;

procedure TIE7Edit.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState) ;
begin
    if Assigned(OnKeyDown)
    then
        OnKeyDown(Self, Key, Shift) ;
end ;

procedure TIE7Edit.EditKeyPress(Sender: TObject; var Key: Char) ;
begin
    if Assigned(OnKeyPress)
    then
        OnKeyPress(Self, Key) ;
end ;

procedure TIE7Edit.EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState) ;
begin
    if Assigned(OnKeyUp)
    then
        OnKeyUp(Self, Key, Shift) ;
end ;

procedure TIE7Edit.EditStartDock(Sender: TObject; var DragObject: TDragDockObject) ;
begin
    if Assigned(OnStartDock)
    then
        OnStartDock(Self, DragObject) ;
end ;

procedure TIE7Edit.EditStartDrag(Sender: TObject; var DragObject: TDragObject) ;
begin
    if Assigned(OnStartDrag)
    then
        OnStartDrag(Self, DragObject) ;
end ;

procedure TIE7Edit.EditMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) ;
begin
    if Assigned(OnMouseDown)
    then
        OnMouseDown(Self, Button, Shift, X, Y) ;
end ;

procedure TIE7Edit.EditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer) ;
begin
    if Assigned(OnMouseMove)
    then
        OnMouseMove(Self, Shift, X, Y) ;
end ;

procedure TIE7Edit.EditMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) ;
begin
    if Assigned(OnMouseUp)
    then
        OnMouseUp(Self, Button, Shift, X, Y) ;
end ;

procedure Register;
begin
    RegisterComponents('WinEssential', [TIE7Edit]);
end;

end.
