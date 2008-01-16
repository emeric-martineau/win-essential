TAdvancedListView
by MARTINEAU Emeric
Version 1.1
Jan - 16, 2008
this component is GPL software

DESCRIPTION
-----------
Component heretied of ListView and add, sort when you click on colum and color one line/colum on two, add image background, image on header.


NEW PROPERTIES:
---------------

* ColorImpair

* ColorPair

* TextColorPair

* TextColorImpair

* AutoSortOnHeaderClick

* BackgroundPicture
  Display picture in background

* PictureOffsetX, PictureOffsetY : offset where start background image 

* CustumStyle
  ctNone  : like a classic ListView
  ctColum : Change lolor of column
  ctLine  : Change color of line
  ctFixedImageBackGround : Display fixed picture in background (Work only when Theme of
                           windows run)
  ctRepeatImageBackGround : Display repeat picture in background (Work only when Theme of
                            windows run)

* DisplayArrow : display arrow in header when sorted 

* DisplayArrowPosition : where arrow show rigth or left. Don't work in UserArrowUp and 
                         UserArrowUp unset and Visual Theme active.

* UserArrowUp : picture diplay when sorted

* UserArrowDown : picture diplay when sorted

* OnColumnClickBeforeSort : call after sort and display image.
                            CanSort           : sort column
                            ChangeHeaderImage : change image of header

* OnColumnClickBeforeSort : call after sort and display image
                            Is like than OnColumnClick

WARNING :
---------
If you use UserArrowUp or UserArrowDown and UserArrowUp or UserArrowUp not affecte, diplay default arrow (no theme window style)

If you assign OnColumnClick, OnColumnClickBeforeSort and OnColumnClickAfterSort are not called.
 
KNOW BUG :
----------
You cannot change image. If do that, stange display appear.