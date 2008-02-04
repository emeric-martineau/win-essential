unit SelectDirectory;
{*******************************************************************************
 * TSelectDirectory
 * Component of WinEssential project (http://php4php.free.fr/winessential/
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
 * Version 1.0 by MARTINEAU Emeric (php4php.free.fr) - 23/01/2008
 ******************************************************************************}
interface

uses
  Windows, Messages, SysUtils, Classes, ShlObj;

type
  TSelectDirectory = class(TComponent)
  private
    { Déclarations privées }
    FSelectedDirectory : String ;
    FInitialDir : String ;
    FAllowCreateDirectory : boolean ;
    FTitle : String ;
  protected
    { Déclarations protégées }
  public
    { Déclarations publiques }
    constructor Create(Owner:TComponent); override;
    procedure Execute ;
  published
    { Déclarations publiées }
    property InitialDir : String read FInitialDir write FInitialDir ;
    property SelectedDir : String read FSelectedDirectory write FSelectedDirectory ;
    property AllowCreateDirectory : Boolean read FAllowCreateDirectory write FAllowCreateDirectory default true ;
    property Title : String read FTitle write FTitle ;
  end;

procedure Register;

const BFFM_INITIALIZED = 1 ;
      BIF_RETURNONLYFSDIRS = 1 ;
      BIF_NEWDIALOGSTYLE = $40 ;
      BFFM_SELCHANGED = 2 ;
      BFFM_VALIDATEFAILED = 3 ;
      BFFM_SETSELECTION = (WM_USER + 102) ;

var InitialDir : String ;

implementation


{*******************************************************************************
 * Constructeur
 ******************************************************************************}
constructor TSelectDirectory.Create(Owner:TComponent);
begin
    inherited ;

    FAllowCreateDirectory := True ;
    FTitle := '' ;
end ;

{*******************************************************************************
 * Fonction appelée par la boite de dialogue Sélectionner un réperoire
 *
 * La fonction ne doit pas être dans l'objet sinon ça ne fonctionne pas
 ******************************************************************************}
function BrowseFolderCallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
    if uMsg = BFFM_INITIALIZED
    then
      SendMessage(Wnd, BFFM_SETSELECTION, 1, Integer(@InitialDir[1]));
    result := 0;
end;

procedure TSelectDirectory.Execute ;
var
  browse_info: TBrowseInfo;
  folder: array[0..MAX_PATH] of char;
  find_context: PItemIDList;
begin
    InitialDir := FInitialDir ;
    
    FillChar(browse_info,SizeOf(browse_info),#0);
    browse_info.pszDisplayName := @folder[0];
    browse_info.lpszTitle := PChar(Title);
    // Pour avoir le bouton Créer dossier
    browse_info.ulFlags := BIF_RETURNONLYFSDIRS ;

    if AllowCreateDirectory
    then
        browse_info.ulFlags := browse_info.ulFlags or BIF_NEWDIALOGSTYLE ;
        
    browse_info.hwndOwner := 0;

    if FInitialDir <> ''
    then
        browse_info.lpfn := BrowseFolderCallBack;

    find_context := SHBrowseForFolder(browse_info);

    if Assigned(find_context)
    then begin
        if SHGetPathFromIDList(find_context, folder)
        then
            FSelectedDirectory := folder
        else
            FSelectedDirectory := '';

        GlobalFreePtr(find_context);
    end
    else
        FSelectedDirectory := '';
end ;

procedure Register;
begin
  RegisterComponents('WinEssential', [TSelectDirectory]);
end;

end.
