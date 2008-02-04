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
 * FOR A PARTICULAR PURPOSE.See the GGNU LESSER GENERAL PUBLIC LICENSE for more
 * details.
 *
 * You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE along
 * with this program; if not, write to the Free Software Foundation, Inc., 59
 * Temple Place, Suite 330, Boston, MA 02111-1307 USA.
 *
 * See http://www.delphidabbler.com/articles?article=16 for more detail
 *
 *******************************************************************************
 * Version 1.1 by MARTINEAU Emeric (php4php.free.fr) - 16/01/2008
 *  - support de l'alignement du texte dans les colonnes,
 *  - ajout de la methode OnColumnClickBeforeSort et OnColumnClickAfterSort,
 *  - concatenation de ColumColor et LineColor en ColorXXXX,
 *  - coloration du texte suivant la ligne/colonne,
 *  - ajout image de le header,
 *
 * Version 1.0 by MARTINEAU Emeric (php4php.free.fr) - 14/01/2008
 ******************************************************************************}
unit AdvancedListView;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ComCtrls, Graphics, CommCtrl,
  ExtCtrls, Registry ;

{$I DelphiVersion.inc}

const
  cShade = $F7F7F7;
  { for display arrow }
  HDF_SORTUP = $0400;
  HDF_SORTDOWN = $0200;

type
  { DLLVERSIONINFO structure }
  PDLLVerInfo = ^TDLLVersionInfo ;
  TDLLVersionInfo=Record
    cbSize,               { Size of the structure, in bytes. }
    dwMajorVersion,       { Major version of the DLL }
    dwMinorVersion,       { Minor version of the DLL }
    dwBuildNumber,        { Build number of the DLL }
    dwPlatformID: DWord;  { Identifies the platform for which the DLL was built }
  end;

  TCustomType = (ctNone, ctColum, ctLine, ctFixedImageBackGround, ctRepeatImageBackGround) ;
  TArrowDisplayPosition = (adRight, adLeft) ;

  TLVColumnClickAfterSortEvent = procedure(Sender: TObject; Column: TListColumn; var CanSort : Boolean; var ChangeHeaderImage : Boolean) of object;

  TAdvancedListView = class(TListView)
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
    { color of impair line }
    FColor1 : TColor ;
    { color of pair line }
    FColor2 : TColor ;
    { color of text impair line }
    FTextColor1 : TColor ;
    { color of text pair line }
    FTextColor2 : TColor ;
    { type of advanced }
    FCustom : TCustomType ;
    { Numéro de la colone dernièrement cliquée }
    Colonne : Integer ;
    { Odre croissant }
    OrdreCroissant : Boolean ;
    { Indique si on trie automatiquement lorsqu'on clique sur l'entête }
    FASOHC : Boolean ;
    { Image de fond }
    FBackGroundImage : TImage ;
    { Offset X of picture }
    FPictureOffsetX : Integer ;
    { Offset Y of picture }
    FPictureOffsetY : Integer ;
    { Display arrow ? }
    FDisplayArrow : boolean ;
    { position of arrow }
    FDisplayArrowPosition : TArrowDisplayPosition ;
    { Déclarations publiques }
    { Rectangle de l'image de la flèche 16x16}
    Rectangle : TRect ;
    { Flèche par défaut vers le bas }
    BitmapArrowDown : TBitmap ;
    { Flèche par défaut vers le haut }
    BitmapArrowUp : TBitmap ;
    { Fleche haute utilisateur }
    FImageArrowDown : TBitmap ;
    { Fleche basse utilisateur }
    FImageArrowUp : TBitmap ;
    { Colonne par défaut de trié }
    FDefaultSortColumn : Integer ;
    FOnColumnClickBeforeSort : TLVColumnClickAfterSortEvent;
    FOnColumnClickAfterSort : TLVColumnClickEvent ;

    procedure AdvancedListViewCustomDrawItem(Sender: TCustomListView;
                             Item: TListItem; State: TCustomDrawState;
                                            var DefaultDraw: Boolean);
    procedure AdvancedListViewCustomDrawSubItem(Sender: TCustomListView;
             Item: TListItem; SubItem: Integer; State: TCustomDrawState;
                                              var DefaultDraw: Boolean);
    procedure AdvancedListViewColumnClick(Sender: TObject;
              Column: TListColumn);
    procedure SetColor1(couleur : TColor) ;
    procedure SetColor2(couleur : TColor) ;
    procedure SetCustomStyle(Style : TCustomType) ;
    procedure SetASOHC(status : boolean) ;
    procedure SetTextColor1(couleur : TColor) ;
    procedure SetTextColor2(couleur : TColor) ;
    procedure WndProc(var Message: TMessage); override;
    procedure ListViewBackGroundImage;
    procedure ListViewBackGroundImageClear;
    procedure WMLButtonDown(var msg: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMRButtonDown(var msg: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure SetImageWindowStyle(Index: Integer);
    procedure RemoveImage(Index: Integer);
    procedure SetColumnImage(Colonne: Integer; Down: Boolean);
    procedure SetDisplayArrowPosition(Position : TArrowDisplayPosition) ;
    procedure SetDisplayArrow(Display : boolean) ;
    function  CheckCommonControlVersion6OrAbove : boolean ;
    procedure SetImageWindowWithoutStyle(Index: Integer);
    procedure DrawArrowDown ;
    procedure DrawArrowUp ;
    procedure SetBitmapUserArrowDown(value:TBitmap);
    procedure SetBitmapUserArrowUp(value:TBitmap);
    procedure SetDefaultSortColumn(index:Integer) ;
  public
    constructor Create(Owner:TComponent); override;
    destructor Destroy; override;
  published
    { Déclarations publiées }
  published
    property Action;
    property Align;
    property AllocBy;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind default bkNone;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property Checkboxes;
    property Color;
    property Columns;
    property ColumnClick;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property FlatScrollBars;
    property FullDrag;
    property GridLines;
    property HideSelection;
    property HotTrack;
    property HotTrackStyles;
    property IconOptions;
    property Items;
    property LargeImages;
    property MultiSelect;
    property OwnerData;
    property OwnerDraw;
    property ReadOnly default False;
    property RowSelect;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowColumnHeaders;
    property ShowHint;
    property SmallImages;
    property SortType;
    property StateImages;
    property TabOrder;
    property TabStop default True;
    property ViewStyle;
    property Visible;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnColumnClick;
    property OnCompare;
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnCustomDrawSubItem;
    property OnData;
    property OnDataFind;
    property OnDataHint;
    property OnDataStateChange;
    property OnDblClick;
    property OnDeletion;
    property OnDrawItem;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex;
    property OnDragDrop;
    property OnDragOver;
    property OnInsert;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnSelectItem;
    property OnStartDock;
    property OnStartDrag;
    { DELPHI 6 PROPERTY }
    {$IFDEF Delphi6}
    property OnContextPopup;
    property OnColumnDragged;
    property OnColumnRightClick;
    property OnAdvancedCustomDraw;
    property OnAdvancedCustomDrawItem;
    property OnAdvancedCustomDrawSubItem;
    property ShowWorkAreas;
    property HoverTime;
    property OnGetSubItemImage;
    property OnInfoTip;
    {$ENDIF}
    { AdvancedListView property }
    property ColorImpair : TColor read FColor1 write SetColor1 default clWindow ;
    property ColorPair : TColor read FColor2 write SetColor2 default cShade ;
    property CustomStyle : TCustomType read FCustom write SetCustomStyle default ctLine ;
    property AutoSortOnHeaderClick : Boolean read FASOHC write SetASOHC default true ;
    property TextColorImpair : TColor read FTextColor1 write SetTextColor1 default clWindowText ;
    property TextColorPair : TColor read FTextColor2 write SetTextColor2 default clWindowText ;
    property BackgroundPicture : TImage read FBackGroundImage write FBackGroundImage ;
    property PictureOffsetX : Integer read FPictureOffsetX write FPictureOffsetX ;
    property PictureOffsetY : Integer read FPictureOffsetY write FPictureOffsetY ;
    property DisplayArrow : boolean read FDisplayArrow write SetDisplayArrow default true ;
    property DisplayArrowPosition : TArrowDisplayPosition read FDisplayArrowPosition write SetDisplayArrowPosition default adRight ;
    property UserArrowUp : TBitmap read FImageArrowUp write SetBitmapUserArrowUp ;
    property UserArrowDown : TBitmap read FImageArrowDown write SetBitmapUserArrowDown ;
    property DefaultSortColumn : Integer read FDefaultSortColumn write SetDefaultSortColumn default 0 ;
    property OnColumnClickBeforeSort : TLVColumnClickAfterSortEvent read FOnColumnClickBeforeSort write FOnColumnClickBeforeSort ;
    property OnColumnClickAfterSort : TLVColumnClickEvent read FOnColumnClickAfterSort write FOnColumnClickAfterSort ;
  end;

procedure Register;

implementation

{*******************************************************************************
 * Constructeur
 ******************************************************************************}
constructor TAdvancedListView.Create(Owner:TComponent);
begin
    inherited ;

    Self.OnCustomDrawItem := AdvancedListViewCustomDrawItem ;
    Self.OnCustomDrawSubItem := AdvancedListViewCustomDrawSubItem ;
    Self.OnColumnClick := AdvancedListViewColumnClick ;

    Self.ViewStyle := vsReport ;

    FColor1 := clWindow ;
    FColor2 := cShade ;

    FCustom := ctLine ;

    Colonne := - 1;
    OrdreCroissant := True ;

    FASOHC := True ;

    FBackGroundImage := TImage.Create(Self) ;

    FDisplayArrow := True ;

    FDisplayArrowPosition := adRight ;

    Rectangle.Left := 0 ;
    Rectangle.Top := 0 ;
    Rectangle.Right := 16 ;
    Rectangle.Bottom := 16 ;

    FImageArrowDown := TBitmap.Create ;
    FImageArrowUp := TBitmap.Create ;

    DrawArrowDown ;

    DrawArrowUp ;

    DefaultSortColumn := 0 ;
end ;

{*******************************************************************************
 * Destructeur
 ******************************************************************************}
destructor TAdvancedListView.Destroy;
begin
    FBackGroundImage.free;

    FImageArrowDown.Free ;
    FImageArrowUp.Free ;

    if Assigned(BitmapArrowDown)
    then
        BitmapArrowDown.Free ;

    if Assigned(BitmapArrowUp)
    then
        BitmapArrowUp.Free ;
    inherited;
end;

{*******************************************************************************
 * Affecte la couleur 1 et redessine le composant
 ******************************************************************************}
procedure TAdvancedListView.SetColor1(couleur : TColor) ;
begin
    FColor1 := Couleur ;
    Refresh ;
end ;

{*******************************************************************************
 * Affecte la couleur 2 et redessine le composant
 ******************************************************************************}
procedure TAdvancedListView.SetColor2(couleur : TColor) ;
begin
    FColor2 := Couleur ;
    Refresh ;
end ;

{*******************************************************************************
 * Configure le style de composant et redessine le composant
 ******************************************************************************}
procedure TAdvancedListView.SetCustomStyle(Style : TCustomType) ;
begin
    FCustom := Style ;

    if ((Style = ctFixedImageBackGround) or (Style = ctRepeatImageBackGround)) and Assigned(Self.Parent) and (not FBackGroundImage.Picture.Bitmap.Empty)
    then begin
        if CheckCommonControlVersion6OrAbove
        then ListViewBackGroundImage
    end
    else begin
        if CheckCommonControlVersion6OrAbove
        then ListViewBackGroundImageClear ;
    end ;

    Refresh ;
end ;

{*******************************************************************************
 * Indique si la liste est auto-trié
 ******************************************************************************}
procedure TAdvancedListView.SetASOHC(status : boolean) ;
begin
    FASOHC := Status ;

    if Status = True
    then
        Self.OnColumnClick := AdvancedListViewColumnClick
    else
        Self.OnColumnClick := nil ;

end ;

{*******************************************************************************
 * Affecte couleur 1 du text
 ******************************************************************************}
procedure TAdvancedListView.SetTextColor1(couleur : TColor) ;
begin
    FTextColor1 := Couleur ;
    Refresh ;
end ;

{*******************************************************************************
 * Affecte couleur 1 du text
 ******************************************************************************}
procedure TAdvancedListView.SetTextColor2(couleur : TColor) ;
begin
    FTextColor2 := Couleur ;
    Refresh ;
end ;


{*******************************************************************************
 * Dessine un élément de la liste (première colone)
 ******************************************************************************}
procedure TAdvancedListView.AdvancedListViewCustomDrawItem(Sender: TCustomListView;
                                   Item: TListItem; State: TCustomDrawState;
                                                  var DefaultDraw: Boolean);
begin
  if FCustom = ctLine
  then begin
      if Odd(Item.Index)
      then begin
          TAdvancedListView(Sender).Canvas.Brush.Color := FColor2 ;
          TAdvancedListView(Sender).Canvas.Font.Color := FTextColor2 ;
      end
      else begin
          TAdvancedListView(Sender).Canvas.Brush.Color := FColor1 ;
          TAdvancedListView(Sender).Canvas.Font.Color := FTextColor1 ;
      end ;
  end
  else if FCustom = ctColum
  then begin
      TAdvancedListView(Sender).Canvas.Brush.Color := FColor1 ;
  end ;
end;

{*******************************************************************************
 * Dessine un sous-élément colone 1 à N
 ******************************************************************************}
procedure TAdvancedListView.AdvancedListViewCustomDrawSubItem(Sender: TCustomListView;
                           Item: TListItem; SubItem: Integer; State: TCustomDrawState;
                                                            var DefaultDraw: Boolean);
begin
  { Pour delphi 4 }
  if SubItem >= 1
  then begin
      if FCustom = ctColum
      then begin
          if Odd(SubItem)
          then begin
              TAdvancedListView(Sender).Canvas.Brush.Color := FColor2 ;
              TAdvancedListView(Sender).Canvas.Font.Color := FTextColor2 ;
          end
          else begin
              TAdvancedListView(Sender).Canvas.Brush.Color := FColor1 ;
              TAdvancedListView(Sender).Canvas.Font.Color := FTextColor1 ;
          end ;
      end ;
  end ;
end;

{*******************************************************************************
 * Appelé lorsqu'on clique sur une entête de colone
 ******************************************************************************}
procedure TAdvancedListView.AdvancedListViewColumnClick(Sender: TObject;
  Column: TListColumn);
var i, j, NumSubItem : Integer ;
    temp : TListItems ;
    ListItem: TListItem;
    NewListView : TListView ;
    Found : Boolean ;
    Condition : Boolean ;
    CanSort : Boolean ;
    ChangeHeaderImage : Boolean ;

    { Recopie tous les sous-items et leurs propriétés }
    procedure CopieSubItem(Sender : TListView; ListItem: TListItem; i : Integer) ;
    Var k : Integer ;
    begin
        { Copie les sous items }
        For k := 0 to Sender.Items.Item[i].SubItems.Count - 1 do
        begin
            with Sender.Items.Item[i] do
            begin
                { Copie tout les élements de configurations }
                ListItem.SubItems.Add(SubItems[k]);

                ListItem.Cut := Cut ;
                ListItem.Data := Data ;
                ListItem.DropTarget := DropTarget ;
                ListItem.Focused := Focused ;
                ListItem.Indent := Indent ;
                ListItem.Left := Left ;
                ListItem.OverlayIndex := OverlayIndex ;
                ListItem.Selected := Selected ;
                ListItem.StateIndex := StateIndex ;
                ListItem.Top := Top ;
            end ;
        end ;
    end ;
begin
    CanSort := True ;
    ChangeHeaderImage := True ;

    if Assigned(FOnColumnClickBeforeSort)
    then
        FOnColumnClickBeforeSort(Sender, Column, CanSort, ChangeHeaderImage) ;

    if not CanSort
    then
        exit ;

    Condition := False ;

    { Si on clique sur la même colone, on inverse l'ordre }
    if Colonne = Column.ID
    then
        OrdreCroissant := not OrdreCroissant
    else
        OrdreCroissant := True ;

    { Mémorise la colone }
    //Colonne := Column.ID - 6 ;
    Colonne := Column.ID ;

    { Affiche la flèche de trie }
    if FDisplayArrow and ChangeHeaderImage
    then
        SetColumnImage(Colonne, OrdreCroissant) ;

    { Créer une liste view }
    NewListView := TListView.Create(Self) ;
    NewListView.Visible := False ;

    { L'affecte à la feuille courante }
    NewListView.Parent := Self;
    { On mémorise s'il y a les case à cocher car lors de la recopie elles
      apparaissent sans qu'on leur demande quelque chose }
    NewListView.Checkboxes := (Sender as TListView).Checkboxes ;

    { Créer une liste }
    temp := TListItems.Create(NewListView) ;

    {** On trie la première colone **}
    if Column.ID = 0
    then begin
        { Pour chaque élement de la liste qu'on doit trier }
        For i := 0 to (Sender as TListView).Items.Count - 1 do
        begin
            { Indique qu'on n'a pas trouver de position pour l'occurence en
              cours }
            Found := False ;

            { On la trie par rapport à la nouvelle liste }
            For j := 0 to temp.Count -1 do
            begin
                {** Si l'élément se situe avant **}

                { Ci-dessous la condition quand on est en ordre croissant }
                Condition := (Sender as TListView).Items.Item[i].Caption < temp.Item[j].Caption ;

                { Si on veut l'ordre décroissant, on inverse la condition }
                if OrdreCroissant = False
                then
                    Condition := not Condition ;

                if Condition
                then begin
                    { Copie l'item principale }
                    ListItem := temp.Insert(j) ;
                    ListItem.Caption := (Sender as TListView).Items.Item[i].Caption ;

                    CopieSubItem((Sender as TListView), ListItem, i) ;

                    Found := True ;
                    { On sort de la boucle pour ne pas répéter l'élément }
                    Break ;
                end ;
            end ;

            if Found = False
            { Sinon on le copie après }
            then begin
                { Copie l'item principale }
                ListItem := temp.Add ;
                ListItem.Caption := (Sender as TListView).Items.Item[i].Caption ;

                CopieSubItem((Sender as TListView), ListItem, i) ;
            end ;
        end ;
    end
    else begin
        { Mémorise la colone dans une variable évitant ainsi de recalculer a
          chaque fois et gagnant donc du temps en exécution }
        //NumSubItem := Column.ID - 6 ;
        { -1 car c'est les sous-item or le premier item est 0 alors que son
          numéro Column est 1 }
        NumSubItem := Column.ID - 1 ;

        { Pour chaque élement de la liste qu'on doit trier }
        For i := 0 to (Sender as TListView).Items.Count - 1 do
        begin
            { Indique qu'on n'a pas trouver de position pour l'occurence en
              cours }
            Found := False ;

            { On la trie par rapport à la nouvelle liste }
            For j := 0 to temp.Count -1 do
            begin
                if (NumSubItem < temp.Item[j].SubItems.Count) and ((Sender as TListView).Items.Item[i].SubItems.Count > NumSubItem)
                then
                    Condition := (Sender as TListView).Items.Item[i].SubItems.Strings[NumSubItem] < temp.Item[j].SubItems.Strings[NumSubItem] ;

                { Si on veut l'ordre décroissant, on inverse la condition }
                if OrdreCroissant = False
                then
                    Condition := not Condition ;

                if Condition
                then begin
                    { Copie l'item principale }
                    ListItem := temp.Insert(j) ;
                    ListItem.Caption := (Sender as TListView).Items.Item[i].Caption ;

                    CopieSubItem((Sender as TListView), ListItem, i) ;

                    Found := True ;
                    { On sort de la boucle pour ne pas répéter l'élément }
                    Break ;
                end ;
            end ;

            if Found = False
            { Sinon on le copie après }
            then begin
                { Copie l'item principale }
                ListItem := temp.Add ;
                ListItem.Caption := (Sender as TListView).Items.Item[i].Caption ;

                CopieSubItem((Sender as TListView), ListItem, i) ;
            end ;
        end ;
    end ;

    (Sender as TListView).Items.BeginUpdate ;

    (Sender as TListView).Items := NewListView.Items ;
    (Sender as TListView).Checkboxes := NewListView.Checkboxes ;

    (Sender as TListView).Items.EndUpdate ;

    if Assigned(FOnColumnClickAfterSort)
    then
        FOnColumnClickAfterSort(Sender, Column) ;
end;

{*******************************************************************************
 * Procedure pour gérer l'image de fond
 ******************************************************************************}
procedure TAdvancedListView.WndProc(var Message: TMessage);
begin
  if Message.Msg = WM_ERASEBKGND then
    DefaultHandler(Message)
  else
    inherited WndProc(Message);
end;

{*******************************************************************************
 * Affecte une image en fond
 ******************************************************************************}
procedure TAdvancedListView.ListViewBackGroundImage;
var
    LVBKImage : TLVBKIMAGE;
begin
    FillChar(LVBKImage, SizeOf(LVBKImage), 0);

    if FCustom = ctRepeatImageBackGround
    then
        LVBKImage.ulFlags := LVBKIF_SOURCE_HBITMAP or LVBKIF_STYLE_TILE
    else
        LVBKImage.ulFlags := LVBKIF_SOURCE_HBITMAP ;

    LVBKImage.pszImage := nil ;
    LVBKImage.hbm := FBackGroundImage.Picture.Bitmap.Handle ;
    LVBKImage.xOffsetPercent := FPictureOffsetX;
    LVBKImage.yOffsetPercent := FPictureOffsetX;
    ListView_SetBkImage(Handle, @LVBKImage);
    ListView_SetBKColor(Handle, CLR_NONE);
end;

{*******************************************************************************
 * Efface l'image en fond
 ******************************************************************************}
procedure TAdvancedListView.ListViewBackGroundImageClear;
var
  LVBKImage : TLVBKIMAGE;
begin
    FillChar(LVBKImage, SizeOf(LVBKImage), 0);

    LVBKImage.ulFlags := LVBKIF_SOURCE_NONE ;
    ListView_SetBkImage(Handle, @LVBKImage);
end;

{ A cause d'un bug d'affichage, on est obligé de redessiner le composant }
procedure TAdvancedListView.WMLButtonDown(var msg: TWMLButtonDown);
begin
     inherited;
     repaint;
end;

{ A cause d'un bug d'affichage, on est obligé de redessiner le composant }
procedure TAdvancedListView.WMRButtonDown(var msg: TWMRButtonDown);
begin
     inherited;
     repaint;
end;

{*******************************************************************************
 * Supprime l'image de trie
 ******************************************************************************}
procedure TAdvancedListView.RemoveImage(Index: Integer);
var Header : THandle;
    HDItem : THDItem;
begin
    { Get the ListView Header Handle }
    Header := ListView_GetHeader(Self.Handle);

    FillChar(HDItem, SizeOf(HDItem), 0);

    HDItem.Mask := HDI_BITMAP or HDI_IMAGE or HDI_FORMAT;

    { current status secure }
    Header_GetItem(Header, Index, HDItem);

    { delete arrow }
    HDItem.fmt := HDItem.fmt and not HDF_SORTUP and not HDF_SORTDOWN
                  and not HDF_BITMAP_ON_RIGHT and not HDF_IMAGE and not HDF_BITMAP ;


    if not CheckCommonControlVersion6OrAbove
    then
        DeleteObject(HDItem.hbm);

    { New header }
    Header_SetItem(Header, Index, HDItem);
end;

{*******************************************************************************
 * Ajoute l'image de trie sous Windows XP et après avec le style
 ******************************************************************************}
procedure TAdvancedListView.SetImageWindowStyle(Index: Integer);
var Header: THandle;
    HDItem: THDItem;
begin
    { Get the ListView Header Handle }
    Header := ListView_GetHeader(Handle);

    FillChar(HDItem, SizeOf(HDItem), 0);

    HDItem.Mask := HDI_BITMAP or HDI_IMAGE or HDI_FORMAT;

    Header_GetItem(Header, Index, HDItem);

    { clear direction of arrow }
    HDItem.fmt := HDItem.fmt and not HDF_SORTUP and not HDF_SORTDOWN and not HDF_IMAGE ;

    case Columns[Index].Alignment of
        taLeftJustify:  Hditem.fmt := Hditem.fmt or HDF_LEFT;
        taCenter:       Hditem.fmt := Hditem.fmt or HDF_CENTER;
        taRightJustify: Hditem.fmt := Hditem.fmt or HDF_RIGHT;
    else
        Hditem.fmt := Hditem.fmt or HDF_LEFT;
    end;
        
    if OrdreCroissant = true
    then begin
        HDItem.fmt := HDItem.fmt or HDF_SORTUP ;
    end
    else begin
        HDItem.fmt := HDItem.fmt or HDF_SORTDOWN;
    end ;

    { Display arrow to left or right ? }
    if FDisplayArrowPosition = adRight
    then
        HDItem.fmt := HDItem.fmt or HDF_BITMAP_ON_RIGHT
    else
        HDItem.fmt := HDItem.fmt and (not HDF_BITMAP_ON_RIGHT) ;            

    { New header }
    Header_SetItem(Header, Index, HDItem);
end;

{*******************************************************************************
 * Ajoute l'image de trie
 ******************************************************************************}
procedure TAdvancedListView.SetImageWindowWithoutStyle(Index: Integer);
var Header: THandle;
    HDItem: THDItem;
begin
    { Get the ListView Header Handle }
    Header := ListView_GetHeader(Handle);

    FillChar(HDItem, SizeOf(HDItem), 0);

    HDItem.Mask := HDI_FORMAT;

    Header_GetItem(Header, Index, HDItem);

    Hditem.Mask := Hditem.Mask or HDI_FORMAT or HDI_BITMAP ;

    { clear direction of arrow }
    HDItem.fmt := HDItem.fmt or HDF_BITMAP and not HDF_SORTUP and not HDF_SORTDOWN ;

    case Columns[Index].Alignment of
        taLeftJustify:  Hditem.fmt := Hditem.fmt or HDF_LEFT;
        taCenter:       Hditem.fmt := Hditem.fmt or HDF_CENTER;
        taRightJustify: Hditem.fmt := Hditem.fmt or HDF_RIGHT;
    else
        Hditem.fmt := Hditem.fmt or HDF_LEFT;
    end;

    if (HDItem.hbm <> 0)
    then
        DeleteObject(HDItem.hbm);

    if OrdreCroissant = true
    then begin
        { Windows efface l'image au bout d'un moment }
        DrawArrowUp ;
        HDItem.hbm := BitmapArrowUp.Handle ;
    end
    else begin
        DrawArrowDown ;
        HDItem.hbm := BitmapArrowDown.Handle ;
    end ;

    { Display arrow to left or right ? }
    if FDisplayArrowPosition = adRight
    then
        HDItem.fmt := HDItem.fmt or HDF_BITMAP_ON_RIGHT
    else
        HDItem.fmt := HDItem.fmt and (not HDF_BITMAP_ON_RIGHT) ;

    { New header }
    Header_SetItem(Header, Index, HDItem);
end;

{*******************************************************************************
 * Ajoute l'image de trie à une colonne et efface celle des autres
 ******************************************************************************}
procedure TAdvancedListView.SetColumnImage(Colonne: Integer; Down: Boolean);
var i : Integer;
begin
  if (Colonne > - 1) and (Colonne < Self.Columns.Count)
  then begin
      { remove icons }
      for i := 0 to Self.Columns.Count - 1 do
      begin
        RemoveImage(i) ;
      end ;

      if CheckCommonControlVersion6OrAbove and FImageArrowDown.Empty and FImageArrowUp.Empty
      then
          SetImageWindowStyle(Colonne)
      else
          SetImageWindowWithoutStyle(Colonne);
  end ;
end;

{*******************************************************************************
 * Fonction qui affecte la valeur d'affichage de l'indicateur de trie
 ******************************************************************************}
procedure TAdvancedListView.SetDisplayArrow(Display : boolean) ;
begin
    FDisplayArrow := Display ;

    if Display = False
    then
        SetColumnImage(-1, true)
    else
        SetColumnImage(Colonne, OrdreCroissant) ;
end ;

{*******************************************************************************
 * Fonction qui affecte la valeur de position d'affichage
 ******************************************************************************}
procedure TAdvancedListView.SetDisplayArrowPosition(Position : TArrowDisplayPosition) ;
begin
    FDisplayArrowPosition := Position ;

    if FDisplayArrow
    then
        SetColumnImage(Colonne, OrdreCroissant) ;
end ;

{*******************************************************************************
 * Vérifie qu'il s'agit des CommonControl version 6 ou supérieur
 ******************************************************************************}
function TAdvancedListView.CheckCommonControlVersion6OrAbove ;
var HandleDll: THandle;
    pDllVersionInfo: pDLLVerInfo;
    DLLVersionInfo: TDLLVersionInfo ;
    DllGetVersion: function(dvi: PDLLVerInfo): PDLLVerInfo; stdcall;
begin
    Result := False ;

    HandleDll := LoadLibrary('comctl32.dll') ;

    if HandleDll <> 0
    then begin
        @DllGetVersion := GetProcAddress(HandleDll, 'DllGetVersion') ;

        if (@DllGetVersion) <> nil
        then begin
            new(pDllVersionInfo);

            try
                ZeroMemory(pDllVersionInfo, SizeOf(pDllVersionInfo^));
                pDllVersionInfo^.cbSize := SizeOf(pDllVersionInfo^);

                DllGetVersion(pDllVersionInfo);
                DLLVersionInfo.dwMajorVersion := pDllVersionInfo^.dwMajorVersion;
                DLLVersionInfo.dwMinorVersion := pDllVersionInfo^.dwMinorVersion;
                
                if DLLVersionInfo.dwMajorVersion > 5
                then
                    Result := True ;

            finally
                dispose(pDllVersionInfo);
            end;
        end ;
        
        FreeLibrary(HandleDll) ;
    end ;
end ;

{*******************************************************************************
 * Dessine L'image vers le bas
 ******************************************************************************}
procedure TAdvancedListView.DrawArrowDown ;
begin
    if Assigned(BitmapArrowDown)
    then
        BitmapArrowDown.Free ;

    BitmapArrowDown := TBitmap.Create ;

    if not FImageArrowDown.Empty
    then begin
        BitmapArrowDown.Assign(UserArrowDown);
    end
    else begin
        BitmapArrowDown.Height := 10 ;
        BitmapArrowDown.Width := 10 ;

        { Crée un rectangle de couleur du header }
        BitmapArrowDown.Canvas.Brush.Style := bsSolid ;
        BitmapArrowDown.Canvas.Brush.Color := clBtnFace ;
        BitmapArrowDown.Canvas.FillRect(Rectangle);

        { Créer la flèche vers le bas }
        { Ligne du dessus }
        BitmapArrowDown.Canvas.Pen.Color := clBtnShadow ;
        BitmapArrowDown.Canvas.MoveTo(0, 0) ;
        BitmapArrowDown.Canvas.LineTo(9, 0) ;
        { Côté droit }
        BitmapArrowDown.Canvas.LineTo(5, 9) ;
        { Côté gauche }
        BitmapArrowDown.Canvas.Pen.Color := clWindow ;
        BitmapArrowDown.Canvas.LineTo(0, 0) ;
    end ;
end ;

{*******************************************************************************
 * Dessine L'image vers le haut
 ******************************************************************************}
procedure TAdvancedListView.DrawArrowUp ;
begin
    if Assigned(BitmapArrowUp)
    then
        BitmapArrowUp.Free ;

    BitmapArrowUp := TBitmap.Create ;

    if not FImageArrowUp.Empty
    then begin
        BitmapArrowUp.Assign(UserArrowUp);
    end
    else begin
        BitmapArrowUp.Height := 10 ;
        BitmapArrowUp.Width := 10 ;

        { Crée un rectangle de couleur du header }
        BitmapArrowUp.Canvas.Brush.Style := bsSolid ;
        BitmapArrowUp.Canvas.Brush.Color := clBtnFace ;
        BitmapArrowUp.Canvas.FillRect(Rectangle);

        { Créer la flèche }
        { Ligne du dessus vers le haut}
        BitmapArrowUp.Canvas.Pen.Color := clBtnShadow ;
        BitmapArrowUp.Canvas.MoveTo(0, 9) ;
        BitmapArrowUp.Canvas.LineTo(9, 9) ;
        { Côté droit }
        BitmapArrowUp.Canvas.LineTo(5, 0) ;
        { Côté gauche }
        BitmapArrowUp.Canvas.Pen.Color := clWindow ;
        BitmapArrowUp.Canvas.LineTo(0, 9) ;
    end ;
end ;

{*******************************************************************************
 * Affecte l'image
 ******************************************************************************}
procedure TAdvancedListView.SetBitmapUserArrowUp(value:TBitmap);
begin
     FImageArrowUp.Assign(value) ;

     if not FImageArrowUp.Empty
     then
          FImageArrowUp.Dormant ;

    if FDisplayArrow
    then
        SetColumnImage(Colonne, OrdreCroissant) ;
end;

{*******************************************************************************
 * Affecte l'image
 ******************************************************************************}
procedure TAdvancedListView.SetBitmapUserArrowDown(value:TBitmap);
begin
     FImageArrowDown.Assign(value) ;

     if not FImageArrowDown.Empty
     then
          FImageArrowDown.Dormant ;

    if FDisplayArrow
    then
        SetColumnImage(Colonne, OrdreCroissant) ;
end;

{*******************************************************************************
 * Affecte la colonne de trie par défault
 ******************************************************************************}
procedure TAdvancedListView.SetDefaultSortColumn(index:Integer) ;
begin
    FDefaultSortColumn := Index ;

    if (Index > -1) and (Index < Self.Columns.Count)
    then
        AdvancedListViewColumnClick(Self, Self.Column[Index]);
end ;

procedure Register;
begin
  RegisterComponents('WinEssential', [TAdvancedListView]);
end;

end.
