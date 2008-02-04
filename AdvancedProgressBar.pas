unit AdvancedProgressBar;
{*******************************************************************************
 * TAdvancedProgressBar
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
 * Inspired by G32 Progress Bar (http://www.g32.org/vcl/index.html)
 *
 *******************************************************************************
 * Version 1.0 by MARTINEAU Emeric (php4php.free.fr) - 04/02/2008
 ******************************************************************************}
interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics ;

type
  TDirection = (tdVertical, tdHorizontal) ;
  TTextPosition = (tpNone, tpCenter, tpBottomCenter, tpBottomLeft, tpBottomRight) ;
  TGaugeType = (gtSolid, gtGradien, gt3D, gtImage) ;

  TAdvancedProgressBar = class(TGraphicControl)
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
    { Rectangle de dessin de la progressbar }
    BarRect : TRect ;
    { Couleur de bordure }
    FBorderColor : TColor ;
    { Couleur de fond }
    FBackColor : TColor ;
    { Hauteur du texte }
    TextHeight : Integer ;
    { Position du text }
    FTextPosition : TTextPosition ;
    { Police d'écriture }
    FFont : TFont ;
    { Minimum }
    FMin : Cardinal ;
    { Maximum }
    FMax : Cardinal ;
    { Position }
    FPosition : Cardinal ;
    { Text affiché si 100 % }
    FEndText : String ;
    { Type de gauge }
    FGaugeType : TGaugeType ;
    { Direction de la gauge }
    FDirection : TDirection ;
    { Couleur 1 }
    FColor1 : TColor ;
    { Couleur 2 }
    FColor2 : TColor ;
    { Contraste de la barre en 3D }
    FContraste : SmallInt ;
    { Taille de la bordure }
    FBorderSize : SmallInt ;
    { Image }
    FBitmap: TBitmap ;
    procedure Paint; override;
    procedure SetBorderColor(couleur : TColor) ;
    procedure SetBackColor(couleur : TColor) ;
    procedure SetFont(NewFont : Tfont) ;
    procedure SetTextPosition(NewPosition : TTextPosition) ;
    procedure SetParent(AParent: TWinControl) ; override ;
    procedure SetMin(Value : Cardinal) ;
    procedure SetMax(Value : Cardinal) ;
    procedure SetPosition(Value : Cardinal) ;
    procedure SetEndText(Text : String) ;
    procedure DrawGauge(Rect : TRect; PourCentage : SmallInt) ;
    procedure SetGaugeType(GaugeType : TGaugeType) ;
    procedure SetDirection(ADirection : TDirection) ;
    procedure SetColor1(Couleur : TColor) ;
    procedure SetColor2(Couleur : TColor) ;
    function ModifContraste(C: TColor; Contraste: Integer): TColor;
    procedure SetContrast(Contraste : SmallInt) ;
    procedure SetBorderSize(size : SmallInt) ;
    procedure SetBitmap(Image : TBitmap) ;
  public
    { Déclarations publiques }
    constructor Create(Component: TComponent); override;
    destructor Destroy; override;
  published
    { Déclarations publiées }
    property Visible;
    property Enabled;    
    property BorderColor : Tcolor read FBorderColor write SetBorderColor default clBlack ;
    property BackColor : Tcolor read FBackColor write SetBackColor default clAppWorkSpace ;
    property Font : TFont read FFont write SetFont ;
    property TextPosition : TTextPosition read FTextPosition write SetTextPosition default tpNone ;
    property Min : Cardinal read FMin write SetMin default 0 ;
    property Max : Cardinal read FMax write SetMax default 0 ;
    property Position : Cardinal read FPosition write SetPosition default 0 ;
    property EndText : String read FEndText write SetEndText ;
    property GaugeType : TGaugeType read FGaugeType write SetGaugeType default gt3D;
    property Direction : TDirection read FDirection write SetDirection default tdHorizontal ;
    property Color1 : TColor read FColor1 write SetColor1 default clHighlight ;
    property Color2 : TColor read FColor2 write SetColor2 default clBlack ;
    property Contrast : SmallInt read FContraste write SetContrast default -64 ;
    property BorderSize : SmallInt read FBorderSize write SetBorderSize default 1 ;
    property Bitmap : TBitmap read FBitmap write SetBitmap ;
  end;

procedure Register;

implementation

{*******************************************************************************
 * Constructeur
 ******************************************************************************}
constructor  TAdvancedProgressBar.Create(Component: TComponent);
var Metrics: NONCLIENTMETRICS;
begin
    inherited Create(Component);

    FBorderColor := clBlack ;
    FBackColor := clAppWorkSpace ;

    Metrics.cbSize := SizeOf(NONCLIENTMETRICS);
    SystemParametersInfo(SPI_GETNONCLIENTMETRICS, SizeOf(NONCLIENTMETRICS), @Metrics, 0);

    FFont := TFont.Create ;
    FFont.Color := clBtnText ;
    FFont.Style := [] ;

    if Metrics.lfMessageFont.lfItalic <> 0
    then
        FFont.Style := FFont.Style + [fsItalic] ;

    if Metrics.lfMessageFont.lfWeight = 700
    then
        FFont.Style := FFont.Style + [fsBold] ;

    if Metrics.lfMessageFont.lfUnderline <> 0
    then
        FFont.Style := FFont.Style + [fsUnderLine] ;

    FFont.Name := Metrics.lfMessageFont.lfFaceName ;

    Canvas.Font.Assign(FFont) ;

    Self.Width := 150 ;
    Self.Height := 17 ;

    FTextPosition := tpNone ;

    FMin := 0 ;
    FMax := 100 ;
    FPosition := 0 ;

    FEndText := '' ;

    FGaugeType := gt3D ;

    FDirection := tdHorizontal ;

    FColor1 := clHighlight ;
    FColor2 := clBlack ;

    FContraste := -64 ;

    FBorderSize := 1 ;

    FBitmap := TBitmap.Create ;
end ;

{*******************************************************************************
 * Destructeur
 ******************************************************************************}
destructor  TAdvancedProgressBar.Destroy;
begin
    FFont.Free ;
    FBitmap.Free ;
    
    inherited Destroy;
end;

{*******************************************************************************
 * Couleur de la bordure
 ******************************************************************************}
procedure TAdvancedProgressBar.SetBorderColor(couleur : TColor) ;
begin
    FBorderColor := Couleur ;
    Invalidate ;
end ;

{*******************************************************************************
 * Couleur de fond
 ******************************************************************************}
procedure TAdvancedProgressBar.SetBackColor(couleur : TColor) ;
begin
    FBackColor := Couleur ;
    Invalidate ;
end ;

{*******************************************************************************
 * Dessine le composant
 ******************************************************************************}
procedure TAdvancedProgressBar.SetFont(NewFont : Tfont) ;
begin
    FFont.Assign(NewFont) ;

    Canvas.Font.Assign(FFont) ;

    TextHeight := Canvas.TextHeight('0%') ;
end ;

{*******************************************************************************
 * Definit position du texte
 ******************************************************************************}
procedure TAdvancedProgressBar.SetTextPosition(NewPosition : TTextPosition) ;
begin
    FTextPosition := NewPosition ;
    Invalidate ;
end ;

{*******************************************************************************
 * Affecte le parent
 ******************************************************************************}
procedure TAdvancedProgressBar.SetParent(AParent: TWinControl) ;
begin
    inherited ;

    if AParent <> nil
    then
        TextHeight := Canvas.TextHeight('0%') ;
end ;

{*******************************************************************************
 * Affecte le minimum
 ******************************************************************************}
procedure TAdvancedProgressBar.SetMin(Value : Cardinal) ;
begin
    FMin := Value ;
    Invalidate ;
end ;

{*******************************************************************************
 * Affecte le maximum
 ******************************************************************************}
procedure TAdvancedProgressBar.SetMax(Value : Cardinal) ;
begin
    FMax := Value ;
    Invalidate ;
end ;

{*******************************************************************************
 * Affecte la position
 ******************************************************************************}
procedure TAdvancedProgressBar.SetPosition(Value : Cardinal) ;
begin
    FPosition := Value ;
    Invalidate ;
end ;

{*******************************************************************************
 * Texte de fin
 ******************************************************************************}
procedure TAdvancedProgressBar.SetEndText(Text : String) ;
begin
    FEndText := Text ;
    Invalidate ;
end ;

{*******************************************************************************
 * Dessine le composant
 ******************************************************************************}
procedure TAdvancedProgressBar.Paint ;
var Rect : TRect ;
    X, Y : Integer ;
    text : String ;
    textwidth : Integer ;
    pourcentage : SmallInt ;
    LineRect : TRect ;
begin
    inherited ;

    { 1 - Dessiner le rectangle }
    Canvas.Brush.Style := bsSolid ;
    Canvas.Brush.Color := FBackColor ;
    Canvas.Pen.Style := psSolid ;
    Canvas.Pen.Color := FBackColor ;

    Rect.Top := FBorderSize ;
    Rect.Left := FBorderSize ;
    Rect.Right := Self.Width - FBorderSize ;
    Rect.Bottom := Self.Height - FBorderSize ;

    { On soustrait le texte du rectangle }
    if FTextPosition in [tpBottomCenter, tpBottomLeft, tpBottomRight]
    then begin
        Rect.Bottom := Rect.Bottom - TextHeight ;
    end ;

    Canvas.FillRect(Rect);

    { On utilise des rectangle plutôt q'un trait car sinon les bouts sont arrondis }
    Canvas.Pen.Style := psSolid ;
    Canvas.Brush.Color := FBorderColor ;

    { Trait du haut }
    LineRect.Top := 0 ;
    LineRect.Left := 0 ;
    LineRect.Right := Self.Width ;
    LineRect.Bottom := FBorderSize ;

    Canvas.FillRect(LineRect) ;

    if FTextPosition in [tpBottomCenter, tpBottomLeft, tpBottomRight]
    then begin
        { trait de droite }
        LineRect.Top := 0 ;
        LineRect.Left := Self.Width - FBorderSize ;
        LineRect.Right := Self.Width ;
        LineRect.Bottom := Self.Height - TextHeight ;

        Canvas.FillRect(LineRect) ;

        { Trait du bas }
        LineRect.Top := Self.Height - TextHeight - FBorderSize ;
        LineRect.Left := 0 ;
        LineRect.Right := Self.Width ;
        LineRect.Bottom := LineRect.Top +FBorderSize ;

        Canvas.FillRect(LineRect) ;
    end
    else begin
        { trait de droite }
        LineRect.Top := 0 ;
        LineRect.Left := Self.Width - FBorderSize ;
        LineRect.Right := Self.Width ;
        LineRect.Bottom := Self.Height ;

        Canvas.FillRect(LineRect) ;

        { Trait du bas }
        LineRect.Top := Self.Height - FBorderSize ;
        LineRect.Left := 0 ;
        LineRect.Right := Self.Width ;
        LineRect.Bottom := LineRect.Top +FBorderSize ;

        Canvas.FillRect(LineRect) ;
    end ;

    { Trait de gauche }
    LineRect.Top := 0 ;
    LineRect.Left := 0 ;
    LineRect.Right := FBorderSize ;
    LineRect.Bottom := Self.Height ;

    if FTextPosition in [tpBottomCenter, tpBottomLeft, tpBottomRight]
    then begin
        Dec(LineRect.Bottom, TextHeight) ;
    end ;

    Canvas.FillRect(LineRect) ;

    { 2 - On dessine la jauge }
    pourcentage := (FPosition - FMin) * 100 div FMax ;

    DrawGauge(Rect, pourcentage) ;

    { 3 - Dessine le texte de pourcentage }
    if FTextPosition <> tpNone
    then begin
        Canvas.Brush.Style := bsClear ;

        if (pourcentage = 100) and (FEndText <> '')
        then
            text := FEndText
        else
            text := IntToStr(pourcentage) + '%' ;

        textwidth := Canvas.TextWidth(text) ;

        if FTextPosition = tpCenter
        then begin
            X := (Self.Width - textwidth) div 2 ;
            Y := (Self.Height - Self.TextHeight) div 2 ;
        end
        else if  FTextPosition = tpBottomCenter
        then begin
            X := (Self.Width - textwidth) div 2 ;
            Y := Self.Height - Self.TextHeight ;
        end
        else if  FTextPosition = tpBottomLeft
        then begin
            X := 1 ;
            Y := Self.Height - Self.TextHeight ;
        end
        else //if  FTextPosition = tpBottomRight
        begin
            X := (Self.Width - textwidth) ;
            Y := Self.Height - Self.TextHeight ;
        end ;

        Canvas.TextOut(X, Y, text) ;
    end ;
end ;

{*******************************************************************************
 * Type de gauge
 ******************************************************************************}
procedure TAdvancedProgressBar.SetGaugeType(GaugeType : TGaugeType) ;
begin
    FGaugeType := GaugeType ;
    Invalidate ;
end ;

{*******************************************************************************
 * Direction de la gauge
 ******************************************************************************}
procedure TAdvancedProgressBar.SetDirection(ADirection : TDirection) ;
begin
    FDirection := ADirection ;
    Invalidate ;
end ;

{*******************************************************************************
 * Couleur 1
 ******************************************************************************}
procedure TAdvancedProgressBar.SetColor1(Couleur : TColor) ;
begin
    FColor1 := Couleur ;
    Invalidate ;
end ;

{*******************************************************************************
 * Couleur 2
 ******************************************************************************}
procedure TAdvancedProgressBar.SetColor2(Couleur : TColor) ;
begin
    FColor2 := Couleur ;
    Invalidate ;
end ;

{*******************************************************************************
 * Contraste
 ******************************************************************************}
procedure TAdvancedProgressBar.SetContrast(Contraste : SmallInt) ;
begin
    FContraste := Contraste ;
    Invalidate ;
end ;

{*******************************************************************************
 * Border size
 ******************************************************************************}
procedure TAdvancedProgressBar.SetBorderSize(size : SmallInt) ;
begin
    FBorderSize := size ;

    Invalidate ;
end ;

{*******************************************************************************
 * Modifie le constrast
 ******************************************************************************}
function TAdvancedProgressBar.ModifContraste(C: TColor; Contraste: Integer): TColor;
var
  Red, Green, Blue : SmallInt;
begin
    Blue := (ColorToRGB(C) and $FF0000) shr 16 ;
    Green := (ColorToRGB(C) and $00FF00) shr 8 ;
    Red := ColorToRGB(C) and $0000FF;

    Inc(Red, Contraste);
    Inc(Green, Contraste);
    Inc(Blue, Contraste);

    if Red > 255
    then
        Red := 255
    else if Red < 0
    then
        Red := 0;

    if Green > 255
    then
        Green := 255
    else if Green < 0
    then
        Green := 0;

    if Blue > 255
    then
        Blue := 255
    else if Blue < 0
    then
        Blue := 0;

    Result := RGB(Red, Green, Blue) ;
end;

{*******************************************************************************
 * Modifie l'image de la barre de progression
 ******************************************************************************}
procedure TAdvancedProgressBar.SetBitmap(Image : TBitmap) ;
begin
    FBitmap.Assign(Image) ;
    Invalidate ;
end ;

{*******************************************************************************
 * Dessine la gauge
 ******************************************************************************}
procedure TAdvancedProgressBar.DrawGauge(Rect : TRect; PourCentage : SmallInt) ;
var
    StartRGB   : Array[0..2] of Byte; { RGB de la couleur de départ }
    CurrentRGB : Array[0..2] of Byte; { RGB de la couleur courante }
    DeltaRGB   : Array[0..2] of Integer; { RGB à ajouter à la couleur de
                                           départ pour atteindre la couleur
                                           de fin }
    i : Integer ;
    j : Integer ;
    LRect : TRect ;
    Epaisseur : Integer ;
    Debut : Integer ;
    Fin : Integer ;
    TmpColor1 : TColor ;
    TmpColor2 : Tcolor ;
    Bmp : TBitmap ;
begin
    if FDirection = tdHorizontal
    then begin
        Rect.Right := Rect.Right * PourCentage div 100 ;
    end
    else begin
        Rect.Top := Rect.Bottom - (Rect.Bottom * PourCentage div 100) ;
    end ;

    if FGaugeType = gtSolid
    then begin
        Canvas.Brush.Color := FColor1 ;
        Canvas.FillRect(Rect);
    end
    else if FGaugeType = gtGradien
    then begin
        LRect.Top := Rect.Top ;
        LRect.Left := Rect.Left ;
        LRect.Bottom := Rect.Bottom ;
        LRect.Right := Rect.Right ;

        if FDirection = tdVertical
        then begin
            Debut := LRect.Top ;
            Fin := LRect.Bottom ;

            Epaisseur := (Fin - debut) div 255 ;

            if Epaisseur = 0
            then
                Epaisseur := 1 ;

            LRect.Top := LRect.Bottom - Epaisseur ;
        end
        else begin
            { Par défaut horizontal }
            Debut := LRect.Left ;
            Fin := LRect.Right ;

            Epaisseur := (Fin - debut) div 255 ;

            if Epaisseur = 0
            then
                Epaisseur := 1 ;

            LRect.Right := Debut + Epaisseur ;
        end ;

        { Calcul des valeurs RGB pour la couleur courante }
        StartRGB[0] := GetRValue( ColorToRGB( FColor1 ) );
        StartRGB[1] := GetGValue( ColorToRGB( FColor1 ) );
        StartRGB[2] := GetBValue( ColorToRGB( FColor1 ) );
        { Calcul des valeurs à ajouter pour atteindre la couleur de fin }
        DeltaRGB[0] := GetRValue( ColorToRGB( FColor2 )) - StartRGB[0];
        DeltaRGB[1] := GetgValue( ColorToRGB( FColor2 )) - StartRGB[1];
        DeltaRGB[2] := GetbValue( ColorToRGB( FColor2 )) - StartRGB[2];

        i := Debut ;

        while i < Fin do
        begin
            CurrentRGB[0] := StartRGB[0] + Round((i - debut) / fin * DeltaRGB[0]);
            CurrentRGB[1] := StartRGB[1] + Round((i - debut) / fin * DeltaRGB[1]);
            CurrentRGB[2] := StartRGB[2] + Round((i - debut) / fin * DeltaRGB[2]);

            Canvas.Brush.Color := RGB(CurrentRGB[0], CurrentRGB[1], CurrentRGB[2]) ;
            Canvas.FillRect(LRect);

            if FDirection = tdHorizontal
            then begin
                Inc(LRect.Left, Epaisseur) ;
                Inc(LRect.Right, Epaisseur) ;

                if LRect.Right > Rect.Right
                then begin
                    break ;
                end ;
            end
            else begin
                Dec(LRect.Top, Epaisseur) ;
                Dec(LRect.Bottom, Epaisseur) ;

                if LRect.Top < Rect.Top
                then begin
                    break ;
                end ;
            end ;

            Inc(i, Epaisseur) ;
        end ;
    end
    else if FGaugeType = gt3D
    then begin
        LRect.Top := Rect.Top + 1;
        LRect.Left := Rect.Left + 1 ;
        LRect.Bottom := Rect.Bottom - 1 ;
        LRect.Right := Rect.Right - 1 ;

        Canvas.Pen.Width := 1 ;

        if FDirection = tdVertical
        then begin
            TmpColor2 := ModifContraste(FColor1, FContraste) ;
            TmpColor1 := FColor1 ;
        end
        else begin
            TmpColor1 := ModifContraste(FColor1, FContraste) ;
            TmpColor2 := FColor1 ;
        end ;

        { Calcul des valeurs RGB pour la couleur courante }
        StartRGB[0] := GetRValue( ColorToRGB( TmpColor1 ) );
        StartRGB[1] := GetGValue( ColorToRGB( TmpColor1 ) );
        StartRGB[2] := GetBValue( ColorToRGB( TmpColor1 ) );

        { desine la bordure claire }
        Canvas.Pen.Color := ModifContraste(Fcolor1, 32) ;
        Canvas.MoveTo(Rect.Left, Rect.Bottom - 1) ;
        Canvas.LineTo(Rect.Left, Rect.Top) ;
        Canvas.LineTo(Rect.Right, Rect.Top) ;

        { Dessine la bordure foncée }
        CurrentRGB[0] := StartRGB[0] ;
        CurrentRGB[1] := StartRGB[1] ;
        CurrentRGB[2] := StartRGB[2] ;

        Canvas.Pen.Color := ModifContraste(RGB(CurrentRGB[0], CurrentRGB[1], CurrentRGB[2]), -32) ;
        Canvas.MoveTo(Rect.Right - 1, Rect.Top) ;
        Canvas.LineTo(Rect.Right - 1, Rect.Bottom - 1) ;
        Canvas.LineTo(Rect.Left, Rect.Bottom -1) ;

        { Dessine la fin de bordure }
        Canvas.Brush.Color := FBorderColor ;
        Canvas.FillRect(Classes.Rect(Rect.Right, Rect.Top, Rect.Right + FBorderSize, Rect.Bottom));

        { Dessine la barre foncée }
        if FDirection = tdHorizontal
        then begin
            Debut := LRect.Top ;
            Fin := LRect.Bottom ;

            Epaisseur := (Fin - debut) div 255 ;

            if Epaisseur = 0
            then
                Epaisseur := 1 ;

            LRect.Top := LRect.Bottom - Epaisseur ;
        end
        else begin
            { Par défaut horizontal }
            Debut := LRect.Left ;
            Fin := LRect.Right ;

            Epaisseur := (Fin - debut) div 255 ;

            if Epaisseur = 0
            then
                Epaisseur := 1 ;

            LRect.Right := Debut + Epaisseur ;
        end ;

        { Calcul des valeurs à ajouter pour atteindre la couleur de fin }
        DeltaRGB[0] := GetRValue( ColorToRGB( TmpColor2 )) - StartRGB[0];
        DeltaRGB[1] := GetgValue( ColorToRGB( TmpColor2 )) - StartRGB[1];
        DeltaRGB[2] := GetbValue( ColorToRGB( TmpColor2 )) - StartRGB[2];

        i := Debut ;

        while i < Fin do
        begin
            CurrentRGB[0] := StartRGB[0] + Round((i - debut) / fin * DeltaRGB[0]);
            CurrentRGB[1] := StartRGB[1] + Round((i - debut) / fin * DeltaRGB[1]);
            CurrentRGB[2] := StartRGB[2] + Round((i - debut) / fin * DeltaRGB[2]);

            Canvas.Brush.Color := RGB(CurrentRGB[0], CurrentRGB[1], CurrentRGB[2]) ;

            Canvas.FillRect(LRect);

            if FDirection = tdVertical
            then begin
                Inc(LRect.Left, Epaisseur) ;
                Inc(LRect.Right, Epaisseur) ;

                if LRect.Right > Rect.Right
                then begin
                    break ;
                end ;
            end
            else begin
                Dec(LRect.Top, Epaisseur) ;
                Dec(LRect.Bottom, Epaisseur) ;

                if LRect.Top < Rect.Top
                then begin
                    break ;
                end ;
            end ;

            Inc(i, Epaisseur) ;
        end ;
    end
    else if FGaugeType = gtImage
    then begin
        Bmp := TBitmap.Create ;

        Bmp.Width := Rect.Right - Rect.Left ;
        Bmp.Height := Rect.Bottom - Rect.Top ;

        Bmp.Transparent := False ;

        i := 0 ;

        while i < Rect.Right do
        begin
            j := 0 ;

            while j < Rect.Bottom do
            begin
                Bmp.Canvas.Draw(i, j, Fbitmap);

                Inc(j, FBitmap.Height) ;
            end ;

            Inc(i, FBitmap.Width) ;
        end ;

        Canvas.Draw(Rect.Left, Rect.Top, Bmp);

        Bmp.Free ;
    end ;
end ;

procedure Register;
begin
  RegisterComponents('WinEssential', [TAdvancedProgressBar]);
end;

end.
