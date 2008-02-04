TAdvancedProgressBar
by MARTINEAU Emeric
Version 1.0
Feb - 01, 2008
this component is public domain software

DESCRIPTION
-----------
Progress bar, flat, gardient, 3D.


NEW PROPERTIES:
---------------

* BorderColor
  Color of border

* BackColor
  BackGround color

* Font
  Text font

* TextPosition
  Position of percent indicator
  - tpNone         : not text
  - tpCenter       : text on progress bar at center
  - tpBottomCenter : text under progress bar at center of progress bar
  - tpBottomLeft   : text under progress bar at left of progress bar
  - tpBottomRight  : text under progress bar at right of progress bar

* Min
  Minimum value

* Max
  Maximum value

* Position
  Current position between min and max

* EndText
  Display text when progress bar is 100%. If blank, no display

* GaugeType
  Type display of gauge
  - gtSolid   : simple rectangle of Color1
  - gtGradien : rectangle fill with gradient Color1 to Color2
  - gt3D      : a beautiful bar use Color1
  - dtImage   : use Bitmap

* Direction
  - tdVertical   : progress bar is vertical
  - tdHorizontal : progress bar is horizontal

* Color1, Color2

* Contrast
  Use when GaugeType is gt3D. Difference contrast between first line and end line
  when bar display

* BorderSize

* Bitmap
  Use when GaugeType is dtImage