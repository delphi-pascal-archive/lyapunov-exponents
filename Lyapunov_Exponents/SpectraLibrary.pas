// SpectraLibrary
// Copyright (C) 1998, 2000, Earl F. Glynn, Overland Park, KS.
// May be copied freely for non-commercial use.
// Not to be sold for profit without permission.
//
// This unit originally appeared in the Spectra Lab Report
// www.efg2.com/Lab/ScienceAndEngineering/Spectra.htm
//
// All TColor values used in this unit are assumed to be of the form
// $00bbggrr.  For details about TColor, see "TColor" at
// www.efg2.com/Lab/Library/Delpi/Graphics/VCLRTL.htm.

UNIT SpectraLibrary;

INTERFACE

  USES
    Windows,   // TRGBTriple
    Graphics;  // TColor

  TYPE
    Nanometers = DOUBLE;

  CONST
    WavelengthMinimum = 380;  // Nanometers
    WavelengthMaximum = 780;

  // Overload for later convenience
  FUNCTION  WavelengthToRGB(CONST Wavelength: Nanometers):  TColor;           OVERLOAD;
  PROCEDURE WavelengthToRGB(CONST Wavelength:  Nanometers; VAR R,G,B:  BYTE); OVERLOAD;

  FUNCTION Rainbow(CONST fraction:  DOUBLE):  TColor;
  FUNCTION ColorInterpolate(CONST fraction:  DOUBLE;
                            CONST Color1, Color2:  TColor):  TColor;

  FUNCTION  ColorToRGBTriple(CONST Color:  TColor):  TRGBTriple;


IMPLEMENTATION

  USES
    Math;     // Power


  FUNCTION WavelengthToRGB(CONST Wavelength: Nanometers): TColor;
    VAR
      R:  BYTE;
      G:  BYTE;
      B:  BYTE;
  BEGIN
    WavelengthToRGB(Wavelength, R, G, B);
    Result := RGB(R, G, B);
  END {WavelengthToRGB};


  // Adapted from www.isc.tamu.edu/~astro/color.html
  PROCEDURE WavelengthToRGB(CONST Wavelength:  Nanometers; VAR R,G,B:  BYTE);

    CONST
      Gamma        =   0.80;
      IntensityMax = 255;

    VAR
      Blue  :  DOUBLE;
      factor:  DOUBLE;
      Green :  DOUBLE;
      Red   :  DOUBLE;

    FUNCTION Adjust(CONST Color, Factor:  DOUBLE):  INTEGER;
    BEGIN
      IF   Color = 0.0
      THEN RESULT := 0     // Don't want 0^x = 1 for x <> 0
      ELSE RESULT := ROUND(IntensityMax * Power(Color * Factor, Gamma))
    END {Adjust};

  BEGIN

    CASE TRUNC(Wavelength) OF
      380..439:
        BEGIN
          Red   := -(Wavelength - 440) / (440 - 380);
          Green := 0.0;
          Blue  := 1.0
        END;

      440..489:
        BEGIN
          Red   := 0.0;
          Green := (Wavelength - 440) / (490 - 440);
          Blue  := 1.0
        END;

      490..509:
        BEGIN
          Red   := 0.0;
          Green := 1.0;
          Blue  := -(Wavelength - 510) / (510 - 490)
        END;

      510..579:
        BEGIN
          Red   := (Wavelength - 510) / (580 - 510);
          Green := 1.0;
          Blue  := 0.0
        END;

      580..644:
        BEGIN
          Red   := 1.0;
          Green := -(Wavelength - 645) / (645 - 580);
          Blue  := 0.0
        END;

      645..780:
        BEGIN
          Red   := 1.0;
          Green := 0.0;
          Blue  := 0.0
        END;

      ELSE
        Red   := 0.0;
        Green := 0.0;
        Blue  := 0.0
    END;

    // Let the intensity fall off near the vision limits
    CASE TRUNC(Wavelength) OF
      380..419:  factor := 0.3 + 0.7*(Wavelength - 380) / (420 - 380);
      420..700:  factor := 1.0;
      701..780:  factor := 0.3 + 0.7*(780 - Wavelength) / (780 - 700)
      ELSE       factor := 0.0
    END;

    R := Adjust(Red,   Factor);
    G := Adjust(Green, Factor);
    B := Adjust(Blue,  Factor)
  END {WavelengthToRGB};


  // Fraction ranges from 0.0 (WavelengthMinimum) to 1.0 (WavelengthMaximum)
  FUNCTION Rainbow(CONST fraction:  DOUBLE):  TColor;
  BEGIN
    IF   (fraction < 0.0) OR (fraction > 1.0)
    THEN RESULT := clBlack
    ELSE BEGIN
      RESULT := WavelengthToRGB(WavelengthMinimum +
                                fraction * (WavelengthMaximum - WavelengthMinimum))
    END
  END {Raindbow};

  // While a mathematical "linear interpolation" is used here, this is a
  // non-linear interpolation in color perception space.  Fraction is assumed
  // to be from 0.0 to 1.0, but this is not enforced.  Returns Color1 for
  // fraction = 0.0 and Color2 for fraction = 1.0.
  FUNCTION ColorInterpolate(CONST fraction:  DOUBLE;
                            CONST Color1, Color2:  TColor):  TColor;
    VAR
      complement:  Double;
      R1,R2     :  BYTE;
      G1,G2     :  BYTE;
      B1,B2     :  BYTE;
  BEGIN
    IF   fraction <= 0
    THEN RESULT := Color1
    ELSE
      IF   fraction >= 1.0
      THEN RESULT := Color2
      ELSE BEGIN
        R1 := GetRValue(Color1);
        G1 := GetGValue(Color1);
        B1 := GetBValue(Color1);

        R2 := GetRValue(Color2);
        G2 := GetGValue(Color2);
        B2 := GetBValue(Color2);

        complement := 1.0 - fraction;
        RESULT := RGB( ROUND(complement*R1 + fraction*R2),
                       ROUND(complement*G1 + fraction*G2),
                       ROUND(complement*B1 + fraction*B2) )
      END
  END {ColorInterpolate};


  // Conversion utility routines
  FUNCTION  ColorToRGBTriple(CONST Color:  TColor):  TRGBTriple;
  BEGIN
    WITH RESULT DO
    BEGIN
      rgbtRed   := GetRValue(Color);
      rgbtGreen := GetGValue(Color);
      rgbtBlue  := GetBValue(Color)
    END
  END {ColorToRGBTriple};


  FUNCTION  RGBTripleToColor(CONST Triple:  TRGBTriple):  TColor;
  BEGIN
    RESULT := RGB(Triple.rgbtRed, Triple.rgbtGreen, Triple.rgbtBlue)
  END {RGBTripleToColor};


END.
