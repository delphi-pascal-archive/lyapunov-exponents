// efg, March/April 2000
// www.efg2.com/Lab/FractalsAndChaos/Lyapunov.htm
//
// Re-write of Sun C/Turbo Pascal programs from 1992.
//
// Copyright 1992, 2000, Earl F. Glynn.  All Rights Reserved.
// May be used freely for non-commercial use.
// Not to be sold for profit without permission.
//
//
// Lyapunov exponents for logistic equation.  (January 1992)
//
// This program calculates Lyapunov exponents for various values of
// parameter r in the logistic equation:
//
//        x[n+1] = r * x[n] * (1 - x[n])
//
// The Lyapunov exponent (greek lambda) is defined by the formula:
//
//                                  N
//                              1  __      |d x[n+1]|
//        lambda =     lim      -  \  log  |--------|
//                 N->infinity  N  /_    2 |  d x[n]|
//
//                                 n=1
//
// The value for lambda is approximated by using a fairly large N,
// say 4000, after a number of "warmup" iterations, say 600.  For
// the logistic equation, the derivative in the equation above is
// d x[n+1]/ d x[n] = r - 2*r*x[n].
//
// The values for r are defined by a sequence of a's and b's, which
// determine if r is defined for the given iteration by a or b.
// Reference [1] gives sequences such as "ba", "bbaba", "bbababa",
// "bbbbbbaaaaaa", and "bbababa".
//
// Dewdney's "jellyfish" (see [2]) is defined in [1] with the sequence
// "bbaba" with 3.8225 < a < 3.8711 and 3.8218 < b < 3.8607.  Likewise,
// Dewdney's "zircon zity" is created with the sequence "bbbbbbaaaaaa"
// with intervals 3.3936 < a < 4.0000 and 2.516 < b < 3.647.
//
// References
// ----------
// [1] "Chaos in Maps with Continuous and Discontinuous Maxima," Mario Markus,
//     Computers in Physics, Sep/Oct. 1990, pp. 481-493.
//
// [2] "Leaping into Lyapunov Space," Scientific American, A.K. Dewdney,
//     Sept. 91, pp. 178-180.
//
// [3] "Lyapunov Exponents of the Logistic Map with Periodic Forcing,"
//     Mario Markus and Benno Hess, Computers & Graphics, Vol. 13, No. 4,
//     pp. 553-558, 1989.


UNIT LyapunovLibrary;

INTERFACE

  USES
    Windows,   // TRGBTriple
    SysUtils,  // FloatToStr
    Graphics;  // TBitmap

  TYPE
    TLyapunovColorScheme = (csSolid,
                            csGradient, csReverseGradient,
                            csRainbow,  csReverseRainbow);

    TLyapunovUpdate = FUNCTION (CONST i,j:  INTEGER):  BOOLEAN;

    TRowSingleArray = ARRAY[WORD] OF Single;  // store Single floats as pixels!
    pRowSingleArray = ^TRowSingleArray;

    TRGBTripleArray = ARRAY[WORD] OF TRGBTriple;  // pf24bit Scanline
    pRGBTripleArray = ^TRGBTripleArray;

    TLyapunovLambdaMap =
    CLASS(TObject)
      PRIVATE
        FBitmap       :  TBitmap;    // lambda map of "single" values in
                                     // pf32bit PixelFormat

        FaMax         :  Double;     // parameters defining Lyapunov space
        FaMin         :  Double;
        FbMax         :  Double;
        FbMin         :  Double;

        FSequence     :  STRING;     // "r" sequence for logistic equation

        FWarmup       :  INTEGER;    // iteration parameters
        FMaxIterations:  INTEGER;

        FiStart       :  INTEGER;    // next pixel to compute
        FjStart       :  INTEGER;

        FLambdaMax    :  Single;     // min/max values formed during Compute
        FLambdaMin    :  Single;

        // Parameters for coloring lambda map
        FColorSchemeChaos   :  TLyapunovColorScheme;
        FColorSchemeOrder   :  TLyapunovColorScheme;

        FColorSolidOrder    :  TColor;
        FColorGradientOrder1:  TColor;
        FColorGradientOrder2:  TColor;

        FColorSolidChaos    :  TColor;
        FColorGradientChaos1:  TColor;
        FColorGradientChaos2:  TColor;


      PUBLIC
        CONSTRUCTOR Create(CONST iPixels, jPixels:  WORD;
                           CONST aMin, aMax:  DOUBLE;   // "y"
                           CONST bMin, bMax:  DOUBLE;   // "x"
                           CONST Sequence     :  STRING;
                           CONST Warmup       :  INTEGER;
                           CONST MaxIterations:  INTEGER);
        DESTRUCTOR  Destroy;  Override;

        FUNCTION Compute(CONST Callback:  TLyapunovUpdate):  BOOLEAN;

        FUNCTION  LambdaValueColor(CONST Lambda:  Single):  TColor;
        PROCEDURE SetColorScheme(CONST ChaosScheme, OrderScheme:  TLyapunovColorScheme);
        PROCEDURE SetColorParameters(CONST SolidChaos    :  TColor;
                                     CONST GradientChaos1:  TColor;
                                     CONST GradientChaos2:  TColor;
                                     CONST SolidOrder    :  TColor;
                                     CONST GradientOrder1:  TColor;
                                     CONST GradientOrder2:  TColor);
        FUNCTION  ColorLambdaBitmap:  TBitmap;


        PROPERTY  Bitmap   :  TBitmap  READ FBitmap;
        PROPERTY  iStart   :  INTEGER  READ FiStart;
        PROPERTY  jStart   :  INTEGER  READ FjStart;
        PROPERTY  LambdaMax:  Single   READ FLambdaMax;
        PROPERTY  LambdaMin:  Single   READ FLambdaMin;

    END;


  FUNCTION LyapunovExponent (CONST a,b:  DOUBLE;
                             CONST Sequence:  STRING;
                             CONST xStart:  DOUBLE;
                             CONST Warmup, MaxIterations:  INTEGER):  DOUBLE;


IMPLEMENTATION

  USES
    Math,             // Log2 (base-2 logarithm), MaxDouble
    SpectraLibrary;   // Rainbow


  CONST
    NegativeInfinity =  -1E10;  // OK, just a very big, negative value


  // Compute single Lyapunov lambda value
  FUNCTION LyapunovExponent (CONST a,b:  DOUBLE;
                             CONST Sequence:  STRING;
                             CONST xStart:  DOUBLE;
                             CONST Warmup, MaxIterations:  INTEGER):  DOUBLE;

    VAR
      ActualIterations:  INTEGER;
      exclude:  WORD;
      k      :  WORD;
      r      :  DOUBLE;
      sum    :  DOUBLE;
      temp   :  DOUBLE;
      x      :  DOUBLE;   

  BEGIN
    x       := xStart;
    sum     := 0.0;
    exclude := 0;

    FOR k := 1 TO MaxIterations+WarmUp DO
    BEGIN

      IF   sequence[ (k-1) MOD LENGTH(sequence) + 1 ] = 'a'
      THEN  r := a
      ELSE  r := b;

      x := r * x * (1.0-x);

      IF  k > WarmUp
      THEN BEGIN
        temp := abs(r - 2.0*r*x);
        TRY
          // EZeroDivide raised if temp is 0.0
          sum := sum + Log2(temp)        // trap errors here if temp <= 0?
        EXCEPT
          INC(exclude)   // can't take log of value <= 0.0
        END              // happens with LyapunovSpace image
      END
    END;

    ActualIterations := MaxIterations - exclude;
    IF   ActualIterations = 0
    THEN LyapunovExponent := NegativeInfinity
    ELSE LyapunovExponent := sum/ActualIterations

  END {LyapunovExponent};


//////////////////////////////////////////////////////////////////////////////

  CONSTRUCTOR TLyapunovLambdaMap.Create(CONST iPixels, jPixels:  WORD;
                                        CONST aMin, aMax:  DOUBLE;   // "y"
                                        CONST bMin, bMax:  DOUBLE;   // "x"
                                        CONST Sequence     :  STRING;
                                        CONST Warmup       :  INTEGER;
                                        CONST MaxIterations:  INTEGER);
  BEGIN
    // May want to validate parameters some day.  For now, assume user interface
    // prevents unwise values.
    FaMin := aMin;               // order isn't important:  will only flip image
    FaMax := aMax;
    FbMin := bMin;               // order isn't important:  will only reverse image
    FbMax := bMax;
    FSequence := Sequence;
    FWarmup   := Warmup;
    FMaxIterations := MaxIterations;

    FiStart := 0;                // starting pixel for a new lambday map
    FjStart := 0;

    FLambdaMin :=  MaxSingle;  // all values are less than this
    FLambdaMax := -MaxSingle;  // all values are greater than this

    FBitmap := TBitmap.Create;
    FBitmap.Width  := iPixels;
    FBitmap.Height := jPixels;
    FBitmap.PixelFormat := pf32bit;  // each "pixel" is "single" floating-point
                                     // value

    // Kludge workaround to avoid pf32bit "NaN" on some machines,
    // i.e., new bitmap is sometimes $01FFFFFF and sometimes
    // $FFFFFFFF.  The latter value is treated as a NaN and would
    // cause problems in floating-point comparisons.  10 April 2000, efg.
    FBitmap.Canvas.Brush.Color := clBlack;
    FBitmap.Canvas.FillRect(FBitmap.Canvas.ClipRect);

    SetColorScheme({chaos} csGradient, {order} csSolid);

    SetColorParameters({chaos} clWhite, clBlack, clYellow,
                       {order} clBlack, clBlack, clBlue);
  END {Create};


  DESTRUCTOR TLyapunovLambdaMap.Destroy;
  BEGIN
    IF   Assigned(FBitmap)
    THEN FBitmap.Free
  END {Destroy};


  FUNCTION TLyapunovLambdaMap.Compute(CONST Callback:  TLyapunovUpdate):  BOOLEAN;
    CONST
      xStart = 0.5;    // Possibly should make this a parameter some day;
                       // Markus only used this starting iteration value

    VAR
      a          :  DOUBLE;
      aSteps     :  INTEGER;
      b          :  DOUBLE;
      bSteps     :  INTEGER;
      Continue   :  BOOLEAN;
      lambda     :  Single;
      RowSingle  :  pRowSingleArray;

  BEGIN
    Continue := TRUE;

    aSteps := FBitmap.Height;
    bSteps := FBitmap.Width;

    WHILE Continue AND (FjStart < aSteps) DO
    BEGIN
      RowSingle := FBitmap.Scanline[FjStart];

      // top to bottom (could have used a "pantograph" object here but did not)
      a := FaMax - (FjStart / (aSteps-1)) * (FaMax - FaMin);

      WHILE Continue AND (FiStart < bSteps) DO
      BEGIN
        Continue := Callback(FiStart, FjStart);

        // left to right
        b := FbMin + (FiStart / (bSteps-1)) * (FbMax - FbMin);

        lambda := LyapunovExponent (a,b,
                                    FSequence,
                                    xStart,
                                    FWarmUp,
                                    FMaxIterations);



        IF   lambda <> NegativeInfinity  // Ignore this; present in "LyapunovSpace"
        THEN BEGIN
          RowSingle[FiStart] := lambda;

          IF   lambda < FLambdaMin
          THEN FLambdaMin := lambda
          ELSE
            IF   lambda > FLambdaMax
            THEN FLambdaMax := lambda;
        END;

        INC(FiStart)
      END;

      FiStart := 0;

      INC(FjStart)
    END;

    IF   NOT Continue
    THEN DEC(FjStart);

    RESULT := Continue  // set to FALSE if aborted
  END {Compute};


  FUNCTION TLyapunovLambdaMap.LambdaValueColor(CONST Lambda:  Single):  TColor;
    VAR
      complement:  Single;
      fraction  :  Single;
  BEGIN
    IF   Lambda <= 0.0
    THEN BEGIN
      // "order"
      CASE FColorSchemeOrder OF
        csReverseGradient:
          BEGIN
            fraction := Lambda/FLambdaMin;  // both should be negative
            ASSERT ((fraction >= 0.0) AND
                    (fraction <= 1.0), 'ReverseGradient (order)');
            RESULT := SpectraLibrary.ColorInterpolate(fraction,
                           FColorGradientOrder1, FColorGradientOrder2)
          END;

        csGradient:
          BEGIN
            complement := 1.0 - Lambda/FLambdaMin;
            ASSERT ((complement >= 0.0) AND
                    (complement <= 1.0), 'Gradient (order) ' +
                    FloatToStr(complement) + ' ' +
                    FloatToStr(Lambda) + ' ' +
                    FloatToStr(FLambdaMin));
            RESULT := SpectraLibrary.ColorInterpolate(complement,
                           FColorGradientOrder1, FColorGradientOrder2)
          END;

        csRainbow:
          BEGIN
            complement := 1.0 - Lambda/FLambdaMin;
            ASSERT ((complement >= 0.0) AND
                    (complement <= 1.0), 'Rainbow (order)');
            RESULT := SpectraLibrary.Rainbow(complement)
          END;

        csReverseRainbow:
          BEGIN
            fraction := Lambda/FLambdaMin;
            ASSERT ((fraction >= 0.0) AND
                    (fraction <= 1.0), 'ReverseRainbow (order)');
            RESULT := SpectraLibrary.Rainbow(fraction)
          END;

        ELSE
          // csSolid is default
          RESULT := FColorSolidOrder
      END

    END
    ELSE BEGIN
      // "chaos"
      CASE FColorSchemeChaos OF
        csGradient:
          BEGIN
            fraction := Lambda/FLambdaMax;  // both should be negative
            RESULT := SpectraLibrary.ColorInterpolate(fraction,
                           FColorGradientChaos1, FColorGradientChaos2)
          END;

        csReverseGradient:
          BEGIN
            complement := 1.0 - Lambda/FLambdaMax;
            RESULT := SpectraLibrary.ColorInterpolate(complement,
                           FColorGradientChaos1, FColorGradientChaos2)
          END;

        csReverseRainbow:
          BEGIN
            complement := 1.0 - Lambda/FLambdaMax;
            RESULT := SpectraLibrary.Rainbow(complement)
          END;

        csRainbow:
          BEGIN
            fraction := Lambda/FLambdaMax;
            RESULT := SpectraLibrary.Rainbow(fraction)
          END;

        ELSE
          // csSolid is default
          RESULT := FColorSolidChaos
      END

    END

  END {LambdaValueColor};


  PROCEDURE TLyapunovLambdaMap.SetColorScheme
              (CONST ChaosScheme, OrderScheme:  TLyapunovColorScheme);
  BEGIN
    FColorSchemeChaos := ChaosScheme;
    FColorSchemeOrder := OrderScheme
  END {SetColorScheme};


  PROCEDURE TLyapunovLambdaMap.SetColorParameters(CONST SolidChaos    :  TColor;
                                                  CONST GradientChaos1:  TColor;
                                                  CONST GradientChaos2:  TColor;
                                                  CONST SolidOrder    :  TColor;
                                                  CONST GradientOrder1:  TColor;
                                                  CONST GradientOrder2:  TColor);
  BEGIN
    FColorSolidChaos     :=  SolidChaos;
    FColorGradientChaos1 :=  GradientChaos1;
    FColorGradientChaos2 :=  GradientChaos2;

    FColorSolidOrder     :=  SolidOrder;
    FColorGradientOrder1 :=  GradientOrder1;
    FColorGradientOrder2 :=  GradientOrder2;
  END {SetColorParameters};


  FUNCTION  TLyapunovLambdaMap.ColorLambdaBitmap:  TBitmap;
    VAR
      i        :  INTEGER;
      j        :  INTEGER;
      rowSingle:  pRowSingleArray;
      rowTriple:  pRGBTripleArray;
  BEGIN
    RESULT        := TBitmap.Create;
    RESULT.Width  := FBitmap.Width;
    RESULT.Height := FBitmap.Height;
    RESULT.PixelFormat := pf24bit;

    FOR j := 0 TO RESULT.Height-1 DO
    BEGIN
      rowTriple := RESULT.Scanline[j];
      rowSingle := FBitmap.Scanline[j];

      FOR i := 0 TO RESULT.Width-1 DO
      BEGIN
        rowTriple[i] := ColorToRGBTriple( LambdaValueColor(rowSingle[i]) )
      END
    END
  END {ColorLambdaBitmap};

  
END.

