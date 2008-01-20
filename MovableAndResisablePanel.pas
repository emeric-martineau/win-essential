unit MovableAndResisablePanel;
{*******************************************************************************
 * TAdvancedListView
 * Component of WinEssential project (http://php4php.free.fr/winessential/)
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.See the GNU LESSER GENERAL PUBLIC LICENSE for more
 * details.
 *
 * You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE along
 * with this program; if not, write to the Free Software Foundation, Inc., 59
 * Temple Place, Suite 330, Boston, MA 02111-1307 USA.
 *
 *******************************************************************************
 * Version 1.0 by MARTINEAU Emeric (php4php.free.fr) - 20/01/2008
 ******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Forms;

type
  TMovableAndResisablePanel = class(TPanel)
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
    { Taille en pixel pour faire apparaitre le curseur de redimensionnement oblique }
    FSizeBorderOfObliqueArrow : Integer ;
    { Indique si la hauteur peut être redimenssionnée }
    FHeightResizable : Boolean ;
    { Indique si la largeur peur être redimensionnée }
    FWidthResizable : Boolean ;
    { Mémorise le curseur d'origine }
    FOriginalCursor : TCursor ;
    { Indique si le composant est déplaçable }
    FMovable : Boolean ;
    { Indique le hauteur minimum }
    FMinimumHeight : Integer ;
    { Indique le hauteur minimum }
    FMinimumWidth : Integer ;
    { Indique où est le curseur }
    Nord, Sud, Est, West : boolean ;
    NordEst, NordWest, SudEst, SudWest : boolean ;
    procedure GetCursorPosition(X, Y : Integer; var Nord, Sud, Est, West, NordEst, NordWest, SudEst, SudWest : boolean) ;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure SetDefaultCursor(NewCursor : TCursor) ;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override ;
    procedure SetMovable(value : boolean) ;    
  public
    constructor Create(Owner:TComponent); override;
    destructor Destroy; override;  
    property DockManager;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderWidth;
    property BorderStyle;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    property Locked;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
    //
    property SizeBorderOfObliqueArrow : Integer read FSizeBorderOfObliqueArrow write FSizeBorderOfObliqueArrow default 5 ;
    property HeightResizable : Boolean read FHeightResizable write FHeightResizable default true ;
    property WidthResizable : Boolean read FWidthResizable write FWidthResizable default true ;
    property Cursor : TCursor read FOriginalCursor write SetDefaultCursor default crDefault ;
    property Movable : Boolean read FMovable write SetMovable default true ;
    property MinimumHeight : Integer read FMinimumHeight write FMinimumHeight default 2 ;
    property MinimumWidth : Integer read FMinimumWidth write FMinimumWidth default 2 ;
  end;

procedure Register;

implementation

{*******************************************************************************
 * Constructeur
 ******************************************************************************}
constructor TMovableAndResisablePanel.Create(Owner:TComponent);
begin
    inherited ;

    FSizeBorderOfObliqueArrow := 5 ;
    FHeightResizable := True ;
    FWidthResizable := True ;

    FOriginalCursor := crDefault ;

    FMinimumWidth := 2 ;
    FMinimumHeight := 2 ;

    FMovable := True ;
end ;

{*******************************************************************************
 * Destructeur
 ******************************************************************************}
destructor TMovableAndResisablePanel.Destroy;
begin
    // instruction avant
    inherited;
end;

{*******************************************************************************
 * Définit le curseur par défaut
 ******************************************************************************}
procedure TMovableAndResisablePanel.SetDefaultCursor(NewCursor : TCursor) ;
begin
    FOriginalCursor := NewCursor ;
    inherited Cursor := NewCursor ;
end ;

{*******************************************************************************
 * procedure qui indique la position du cursor sur la bordure
 ******************************************************************************}
procedure TMovableAndResisablePanel.GetCursorPosition(X, Y : Integer; var Nord, Sud, Est, West, NordEst, NordWest, SudEst, SudWest : boolean) ;
begin
    Nord := (Y = 0) ;
    Sud := (Y = (Self.ClientHeight - 1));
    Est := (X = (Self.ClientWidth - 1)) ;
    West := (X = 0) ;
    NordEst := (Nord and (X > (Self.ClientWidth - 1 - SizeBorderOfObliqueArrow)) or (Est and (Y < SizeBorderOfObliqueArrow))) ;
    NordWest := (Nord and (X < SizeBorderOfObliqueArrow)) or (West and (Y < SizeBorderOfObliqueArrow)) ;
    SudEst := (Est and ((Y > (Self.ClientHeight - 1 - SizeBorderOfObliqueArrow)))) or
              (Sud and (X > (Self.ClientWidth - 1 - SizeBorderOfObliqueArrow))) ;

    SudWest := (West and (Y > (Self.ClientHeight - 1 - SizeBorderOfObliqueArrow))) or
                (Sud and (X < SizeBorderOfObliqueArrow)) ;
end ;

{*******************************************************************************
 * Définit si le control est déplaçable
 ******************************************************************************}
procedure TMovableAndResisablePanel.SetMovable(value : boolean) ;
begin
    FMovable := Value ;

    if Value
    then
        Self.Cursor := crSizeAll
    else
        Self.Cursor := FOriginalCursor ;
end ;

{*******************************************************************************
 * Procédure appelé lorsqu'on passe la souris sur le contrôle.
 * Se charge d'afficher les curseurs qui vont bien.
 ******************************************************************************}
procedure TMovableAndResisablePanel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
    P : Tpoint ;
    NewTop : Integer ;
    NewHeight : Integer ;
    NewLeft : Integer ;
    NewWidth : Integer ;
begin
    GetCursorPos(P) ;

    inherited ;

    { On rafraicit la position du curseur que si on ne clique pas car sinon, si
      on clique et qu'on déplace on va être hors du panel et donc toutes les
      variable de direction seront à false }
    if not (ssLeft in Shift)
    then
        GetCursorPosition(X, Y, Nord, Sud, Est, West, NordEst, NordWest, SudEst, SudWest) ;

    { Désactive le curseur si on ne peut pas redimensionner la hauteur }
    if not FHeightResizable
    then begin
        Nord := False ;
        Sud := False ;
    end ;

    { Désactive le curseur si on ne peut pas redimensionner la largeur }
    if not FWidthResizable
    then begin
        Est := False ;
        West := False ;
    end ;

    { Désactive les cuseurs obliques si on ne peut pas redimenssionner en hauteur }
    if not (FHeightResizable and FWidthResizable) and (NordEst or NordWest or SudEst or SudWest)
    then begin
        NordEst := False ;
        NordWest := False ;
        SudEst := False ;
        SudWest := False ;
    end ;
    
    { Désactive les curseurs pour l'affichage des curseurs obliques }
    if NordEst or NordWest
    then begin
        Nord := False ;
    end ;

    if SudEst or SudWest
    then begin
        Sud := False ;
    end ;

    if NordEst or SudEst
    then begin
        Est := False ;
    end ;

    if SudWest or NordWest
    then begin
        West := False ;
    end ;

    NewTop := Self.Top ;
    NewHeight := Self.Height ;
    NewLeft := Self.Left ;
    NewWidth := Self.Width ;

    { -1 car le premier point est 0 et non 1 }
    if (Nord or Sud)
    then begin
        inherited Cursor := crSizeNS ;

        if ssLeft in Shift
        then begin
            if Nord
            then begin
                NewTop := Self.Top - (Self.ClientOrigin.Y - P.Y) ;

                if NewTop >= 0
                then
                    NewHeight := Self.Top - NewTop + Self.Height ;
            end
            else begin
                NewHeight := P.Y - Self.ClientOrigin.Y ;
            end ;
        end ;
    end
    else if (Est or West)
    then begin
        inherited Cursor := crSizeWE ;

        if ssLeft in Shift
        then begin
            if West
            then begin
                NewLeft := Self.Left - (Self.ClientOrigin.X - P.X) ;

                if P.X > (Parent.Left + ((Parent.Width - Parent.ClientWidth) div 2))
                then
                    NewWidth := Self.Width - (P.X - Self.ClientOrigin.X) ;
            end
            else begin
                NewWidth := P.X - Self.ClientOrigin.X ;
            end ;
        end ;
    end
    else if NordEst or SudWest
    then begin
        inherited Cursor := crSizeNESW ;

        if ssLeft in Shift
        then begin
            if NordEst
            then begin
                NewTop := Self.Top - (Self.ClientOrigin.Y - P.Y) ;

                if NewTop >= 0
                then
                    NewHeight := Self.Top - NewTop + Self.Height ;

                NewWidth := P.X - Self.ClientOrigin.X ;
            end
            else begin
                NewHeight := P.Y - Self.ClientOrigin.Y ;

                NewLeft := Self.Left - (Self.ClientOrigin.X - P.X) ;

                if P.X > (Parent.Left + ((Parent.Width - Parent.ClientWidth) div 2))
                then
                    NewWidth := Self.Width - (P.X - Self.ClientOrigin.X) ;
            end;
        end ;
    end
    else if NordWest or SudEst
    then begin
        inherited Cursor := crSizeNWSE ;

        if ssLeft in Shift
        then begin
            if NordWest
            then begin
                NewTop := Self.Top - (Self.ClientOrigin.Y - P.Y) ;

                if NewTop >= 0
                then
                    NewHeight := Self.Top - NewTop + Self.Height ;

                NewLeft := Self.Left - (Self.ClientOrigin.X - P.X) ;

                if P.X > (Parent.Left + ((Parent.Width - Parent.ClientWidth) div 2))
                then
                    NewWidth := Self.Width - (P.X - Self.ClientOrigin.X) ;
            end
            else begin
                NewHeight := P.Y - Self.ClientOrigin.Y ;
                NewWidth := P.X - Self.ClientOrigin.X ;
            end ;
        end ;
    end
    else begin
        if FMovable
        then
            Cursor := crSizeAll
        else
            inherited Cursor := FOriginalCursor ;
    end ;

    if (NewTop >= 0) and (NewTop <= Self.Top + Self.Height) and (NewTop < Self.Top + Self.Height - FMinimumHeight)
    then
        Self.Top := NewTop ;

    if Assigned(Parent)
    then
        if (Parent.ClientHeight >= NewHeight + Self.Top) and (NewHeight >= FMinimumHeight)
        then
            Self.Height := NewHeight ;

    if Assigned(Parent)
    then
        if (NewLeft > 0) and (NewLeft + Self.Width < Parent.ClientWidth) and (NewLeft < (Self.Left + Self.Width - FMinimumWidth))
        then
            Self.Left := NewLeft ;

    if Assigned(Parent)
    then
        if (NewWidth <= Parent.ClientWidth - Self.Left) and (NewWidth >= FMinimumWidth)
        then
            Self.Width := NewWidth ;
end;

{*******************************************************************************
 * Procédure appelé lorsqu'on clique sur le contrôle.
 ******************************************************************************}
procedure TMovableAndResisablePanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Action: Integer;
  Msg: TMessage;
  P : TPoint ;
begin
    { Si on est sur la bordure et qu'on clique, cette fonction est appelée et
      le controle est déplacé alors qu'on veut qu'il soit redimensionné }
    if not (Nord or Sud or Est or West or NordEst or NordWest or SudEst or SudWest)
    then begin
        inherited;

        if FMovable
        then begin
            Action := HTCAPTION;
            Msg.Msg := WM_NCLBUTTONDOWN;
            Msg.WParam := Action;
            SetCaptureControl(nil);

            SendMessage(Self.Handle, Msg.Msg, Msg.wParam, Msg.lParam) ;
        end ;
    end ;
end;

procedure Register;
begin
  RegisterComponents('WinEssential', [TMovableAndResisablePanel]);
end;

end.
