// efg, March/April 2000
// www.efg2.com/Lab/FractalsAndChaos/Lyapunov.htm
//
// Re-write of Sun C/Turbo Pascal programs from 1992.
//
// Copyright 1992, 2000, Earl F. Glynn.  All Rights Reserved.
// May be used freely for non-commercial use.
// Not to be sold for profit without permission.
//
// You may want to turn off "Integrated debugging" (Tools | Ddebugging Options)
// or various trapped exceptions may cause problems in the IDE.

unit ScreenLyapunov;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons,
  LyapunovLibrary, ExtDlgs;

type
  TFormLyapunov = class(TForm)
    BitBtnPause: TBitBtn;
    BitBtnReset: TBitBtn;
    BitBtnStart: TBitBtn;

    ButtonPrint: TButton;
    ButtonSave: TButton;

    CheckBoxStretchColor: TCheckBox;
    CheckBoxStretchRaw: TCheckBox;

    ColorDialog: TColorDialog;

    ComboBoxBitmapSize: TComboBox;
    ComboBoxSettings: TComboBox;

    EditAMax: TEdit;
    EditAMin: TEdit;
    EditBMax: TEdit;
    EditBmin: TEdit;
    EditImageName: TEdit;
    EditMaxIterations: TEdit;
    EditPixelsA: TEdit;
    EditPixelsB: TEdit;
    EditSequence: TEdit;
    EditWarmupIterations: TEdit;

    GroupBoxIterations: TGroupBox;
    GroupBoxLyapunovSpace: TGroupBox;

    ImageColorScale: TImage;
    ImageLyapunovColor: TImage;
    ImageLyapunovRaw: TImage;

    Label1A: TLabel;
    Label1B: TLabel;
    Label1C: TLabel;
    Label2A: TLabel;
    Label2B: TLabel;
    Label2C: TLabel;
    Label2D: TLabel;
    Label2E: TLabel;
    Label2F: TLabel;
    Label3A: TLabel;
    Label3B: TLabel;
    Label4A: TLabel;

    LabelA: TLabel;
    LabelB: TLabel;
    LabelBitmapSize: TLabel;
    LabelChaos1: TLabel;
    LabelChaos2: TLabel;
    LabelChaos3: TLabel;
    LabelChaosTo: TLabel;
    LabelColorRGB: TLabel;
    LabelLab1: TLabel;
    LabelLab2: TLabel;
    LabelLambda6: TLabel;
    LabelName: TLabel;
    LabelOrderTo: TLabel;
    LabelSequence: TLabel;
    LabelTimeToGo: TLabel;
    LabelTimeRemainingValue: TLabel;
    LabelWarmupIterations: TLabel;
    LabelLambda1: TLabel;
    LabelLambda2: TLabel;
    LabelLambda4: TLabel;
    LabelLambda5: TLabel;
    LabelLambdaMax: TLabel;
    LabelLambdaMin: TLabel;
    LabelLambdaMaxValue: TLabel;
    LabelLambdaMinValue: TLabel;
    LabelLambdaValue: TLabel;
    LabelMaxIterations: TLabel;
    LabelOrder1: TLabel;
    LabelOrder2: TLabel;
    LabelOrder3: TLabel;
    LabelParameterSet: TLabel;
    LabelPixelsA: TLabel;
    LabelPixelsB: TLabel;
    LabelQuickSettings: TLabel;
    LabelSeconds: TLabel;
    LabelStep1: TLabel;
    LabelStep2: TLabel;
    LabelStep3: TLabel;
    LabelStep4: TLabel;
    LabelTimeElapsed: TLabel;
    LabelTimeElapsedValue: TLabel;

    PanelChaos: TPanel;
    PanelOrder: TPanel;

    PageControlSetup: TPageControl;

    RadioButtonChaosGradient: TRadioButton;
    RadioButtonChaosGradientReverse: TRadioButton;
    RadioButtonChaosRainbow: TRadioButton;
    RadioButtonChaosReverseRainbow: TRadioButton;
    RadioButtonChaosSolidColor: TRadioButton;
    RadioButtonOrderGradient: TRadioButton;
    RadioButtonOrderGradientReverse: TRadioButton;
    RadioButtonOrderRainbow: TRadioButton;
    RadioButtonOrderReverseRainbow: TRadioButton;
    RadioButtonOrderSolidColor: TRadioButton;

    SavePictureDialog: TSavePictureDialog;

    ShapeABottom: TShape;
    ShapeATop: TShape;
    ShapeBRight: TShape;
    ShapeBLeft: TShape;
    ShapeChaosGradientFrom: TShape;
    ShapeChaosGradientTo: TShape;
    ShapeChaosSolidColor: TShape;
    ShapeLyapunovSpace: TShape;
    ShapeOrderGradientFrom: TShape;
    ShapeOrderGradientTo: TShape;
    ShapeOrderSolidColor: TShape;

    TabSheetColor: TTabSheet;
    TabSheetColorScheme: TTabSheet;
    TabSheetCreate: TTabSheet;
    TabSheetSetup: TTabSheet;

    TimerDisplay: TTimer;
    PrinterSetupDialog: TPrinterSetupDialog;


    procedure TimerDisplayTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditFloatKeyPress(Sender: TObject; var Key: Char);
    procedure EditIntegerPress(Sender: TObject; var Key: Char);
    procedure EditSequenceKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtnStartClick(Sender: TObject);
    procedure BitBtnPauseClick(Sender: TObject);
    procedure BitBtnResetClick(Sender: TObject);
    procedure EditLimitsChange(Sender: TObject);
    procedure CheckBoxStretchRawClick(Sender: TObject);
    procedure CheckBoxStretchColorClick(Sender: TObject);
    procedure ComboBoxSettingsChange(Sender: TObject);
    procedure ComboBoxSettingsDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure ComboBoxBitmapSizeChange(Sender: TObject);
    procedure ShapeColorMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure RadioButtonOrderColorClick(Sender: TObject);
    procedure RadioButtonChaosColorClick(Sender: TObject);
    procedure ImageLyapunovRawMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageLyapunovColorMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure EditPixelsChange(Sender: TObject);
    procedure EditIterationsChange(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure LabelLab2Click(Sender: TObject);
    procedure ButtonPrintClick(Sender: TObject);
  private
    BitmapColor         :  TBitmap;
    BlockMultipleUpdates:  BOOLEAN;
    Continue            :  BOOLEAN;
    LyapunovLambdaMap   :  TLyapunovLambdaMap;
    PreviousSeconds     :  DWORD;
    StartTick           :  DWORD;
    ColorSchemeChaos    :  TLyapunovColorScheme;
    ColorSchemeOrder    :  TLyapunovColorScheme;

    FUNCTION  ColoringText(CONST s:  STRING):  STRING;
    PROCEDURE ResetStartPixel;
    PROCEDURE UpdateColorScheme;

  public
    { Public declarations }
  end;

var
  FormLyapunov: TFormLyapunov;

implementation
{$R *.DFM}

  USES
    JPEG,       // TJPEGImage
    Printers,   // Printer
    ShellAPI;   // ShellExecute

  CONST
    Backspace  = #$08;

  // I wish I had seen Peter Below's advice about localization before I
  // buried several floating-point constants in the ComboBoxSettings.Items.
  // Decimal Separator:  http://www.deja.com/[ST_rn=ps]/getdoc.xp?AN=624223515
  // On the same day as Peter's UseNet Post (16 May 2000), I received an
  // E-mail from Andreas Schmidt in German saying my floating-point strings
  // were a problem.  This is my kludge fix to make sure decimal points ae
  // used in the U.S. and commas are used in Germany (and the DecimalSeparator
  // is handled appropriately everywhere).
  //
  //  4.00 becomes 4,00 if the DecimalSeparator is a ','
  FUNCTION LocalizeFloatString(CONST s:  STRING):  STRING;
  BEGIN
    RESULT := s;
    IF   POS('.', RESULT) > 0
    THEN RESULT[POS('.',RESULT)] := DecimalSeparator
  END {LocalizeFloatString};


  // Based on posting to borland.public.delphi.winapi by Rodney E Geraghty, 8/8/97.
  // Used to print bitmap on any Windows printer.
  PROCEDURE PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);
    VAR
      BitmapHeader:  pBitmapInfo;
      BitmapImage :  POINTER;
      HeaderSize  :  DWORD;    // DWORD for D3-D5 compatibility
      ImageSize   :  DWORD;
  BEGIN
    GetDIBSizes(Bitmap.Handle, HeaderSize, ImageSize);
    GetMem(BitmapHeader, HeaderSize);
    GetMem(BitmapImage,  ImageSize);
    TRY
      GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
      StretchDIBits(Canvas.Handle,
                    DestRect.Left, DestRect.Top,      // Destination Origin
                    DestRect.Right  - DestRect.Left,  // Destination Width
                    DestRect.Bottom - DestRect.Top,   // Destination Height
                    0, 0,                             // Source Origin
                    Bitmap.Width, Bitmap.Height,      // Source Width & Height
                    BitmapImage,
                    TBitmapInfo(BitmapHeader^),
                    DIB_RGB_COLORS,
                    SRCCOPY)
    FINALLY
      FreeMem(BitmapHeader);
      FreeMem(BitmapImage)
    END
  END {PrintBitmap};


// The purpose of the callback is to let the user interface tell the
// computation engine that computations should not continue.
FUNCTION LyapunovUpdateCallback(CONST i,j:  INTEGER):  BOOLEAN;
BEGIN
  IF   i = 0    // allow break every row so continue variable can be updated
  THEN Application.Processmessages;
  RESULT := FormLyapunov.Continue
END {LyapunovUpdateCallback};


procedure TFormLyapunov.FormCreate(Sender: TObject);
begin
  BlockMultipleUpdates := TRUE;

  ColorSchemeChaos :=  csSolid;
  ColorSchemeOrder :=  csGradient;

  ComboBoxSettings.ItemIndex   := 0;   // Zircon Zity default
  ComboBoxBitmapSize.ItemIndex := 1;   // 128 by 96 default

  // Force update to get a/b limits displayed
  ComboBoxSettingsChange(Sender);

  LyapunovLambdaMap := NIL;

  BlockMultipleUpdates := FALSE;
  ResetStartPixel;
end;


procedure TFormLyapunov.FormDestroy(Sender: TObject);
begin
  IF   Assigned(LyapunovLambdaMap)
  THEN LyapunovLambdaMap.Free;

  IF   Assigned(BitmapColor)
  THEN BitmapColor.Free
end;


// Changing nearly any parameter will reset everything.
PROCEDURE TFormLyapunov.ResetStartPixel;
BEGIN
  IF   NOT BlockMultipleUpdates
  THEN BEGIN

    BitBtnStart.Enabled := TRUE;
    BitBtnPause.Enabled := FALSE;
    BitBtnReset.Enabled := FALSE;

    LabelTimeElapsedValue.Caption := '0';
    LabelTimeRemainingValue.Caption := '?';

    IF   (StrToInt(EditPixelsA.Text) <> ImageLyapunovRaw.Height) OR
         (StrToInt(EditPixelsB.Text) <> ImageLyapunovRaw.Width)
    THEN CheckBoxStretchRaw.Checked := TRUE
    ELSE CheckBoxStretchRaw.Checked := FALSE;

    IF   Assigned(LyapunovLambdaMap)
    THEN LyapunovLambdaMap.Free;

    LyapunovLambdaMap := TLyapunovLambdaMap.Create(
                             StrToInt(EditPixelsB.Text),
                             StrToInt(EditPixelsA.Text),
                             StrToFloat(EditAMin.Text),
                             StrToFloat(EditAMax.Text),
                             StrToFloat(EditBMin.Text),
                             StrToFloat(EditBMax.Text),
                             Lowercase(EditSequence.Text),
                             StrToInt(EditWarmupIterations.Text),
                             StrToInt(EditMaxIterations.Text));

    ImageLyapunovRaw.Picture.Graphic := LyapunovLambdaMap.Bitmap;

    IF   Assigned(BitmapColor)
    THEN BitmapColor.Free;

    BitmapColor := LyapunovLambdaMap.ColorLambdaBitmap;
    ImageLyapunovColor.Picture.Graphic := BitmapColor;

    BitBtnStart.Caption := 'Start'
  END
END {ResetStartPixel};


procedure TFormLyapunov.TimerDisplayTimer(Sender: TObject);
 VAR
    EstimatedRemainingTicks:  Double;
    EstimatedTotalTicks    :  Double;
    Fraction               :  DOUBLE;
    PixelsProcessed        :  INTEGER;
    PixelsTotal            :  INTEGER;
    ElapsedTicks           :  DWORD;
BEGIN
  ElapsedTicks := 1000*PreviousSeconds + (GetTickCount - StartTick);

  PixelsProcessed := LyapunovLambdaMap.iStart +
                     LyapunovLambdaMap.jStart*LyapunovLambdaMap.Bitmap.Width;
  PixelsTotal := LyapunovLambdaMap.Bitmap.Width*LyapunovLambdaMap.Bitmap.Height - 1;
  Fraction := PixelsProcessed / PixelsTotal;

  LabelTimeElapsedValue.Caption := Format('%.0f', [0.001*ElapsedTicks]);

  IF   Fraction > 0.0
  THEN BEGIN
    EstimatedTotalTicks := ElapsedTicks / Fraction;
    EstimatedRemainingTicks := EstimatedTotalTicks - ElapsedTicks;
     FormLyapunov.LabelTimeRemainingValue.Caption  :=
        Format('%.0f', [0.001*EstimatedRemainingTicks])
  END
  ELSE LabelTimeRemainingValue.Caption := '?';

  ImageLyapunovRaw.Picture.Graphic := LyapunovLambdaMap.Bitmap;
  Application.ProcessMessages;  // force update when triggered by timer
end;


procedure TFormLyapunov.EditFloatKeyPress(Sender: TObject; var Key: Char);
begin
  IF   POS(DecimalSeparator, (Sender AS TEdit).Text) > 0
  THEN BEGIN
    IF   NOT (Key IN [Backspace, '0'..'9'])
    THEN Key := #$00;
  END
  ELSE BEGIN
    IF   NOT (Key IN [Backspace, '0'..'9', DecimalSeparator])
    THEN Key := #$00
  END
end;


procedure TFormLyapunov.EditIntegerPress(Sender: TObject; var Key: Char);
begin
  IF   NOT (Key IN [Backspace, '0'..'9'])
  THEN Key := #$00
end;


procedure TFormLyapunov.EditSequenceKeyPress(Sender: TObject;
  var Key: Char);
begin
  IF   NOT (Key IN [Backspace, 'a', 'b'])
  THEN KEY := #$00
end;


procedure TFormLyapunov.BitBtnStartClick(Sender: TObject);
begin
  PreviousSeconds := StrToInt(LabelTimeElapsedValue.Caption);

  TimerDisplay.Enabled := TRUE;
  Continue := TRUE;  // Changed to FALSE by Stop button

  BitBtnStart.Caption := 'Continue';
  LabelLambdaValue.Caption := '?';
  LabelColorRGB.Caption := 'R=?, G=?, B=?';

  BitBtnStart.Enabled := FALSE;
  BitBtnPause.Enabled := TRUE;
  BitBtnReset.Enabled := FALSE;

  ButtonSave.Enabled := FALSE;
  ButtonPrint.Enabled := FALSE;

  // Lock user out of changing parameters during computations
  TabSheetSetup.Enabled := FALSE;
  TabSheetColorScheme.Enabled := FALSE;
  TabSheetColor.Enabled := FALSE;

  EditSequence.Enabled := FALSE;
  EditImageName.Enabled := FALSE;

  Screen.Cursor := crHourGlass;
  TRY
    StartTick := GetTickCount;
    LyapunovLambdaMap.Compute(LyapunovUpdateCallback);
    TimerDisplay.Enabled := FALSE;

    // Force update to display final time
    TimerDisplayTimer(Sender);

    ImageLyapunovRaw.Picture.Graphic := LyapunovLambdaMap.Bitmap;
    LabelLambdaMinValue.Caption := Format('%.4f', [LyapunovLambdaMap.LambdaMin]);
    LabelLambdaMaxValue.Caption := Format('%.4f', [LyapunovLambdaMap.LambdaMax]);

    UpdateColorScheme
  FINALLY
    Screen.Cursor := crDefault
  END;

  BitBtnPause.Enabled := FALSE;
  BitBtnReset.Enabled := TRUE;

  ButtonSave.Enabled := TRUE;
  ButtonPrint.Enabled := TRUE;

  // Can only recolor once full bitmap has been computed
  TabSheetColorScheme.Enabled := TRUE;
  TabSheetColor.Enabled := TRUE;
  TabSheetSetup.Enabled := TRUE;   // allow changes now

  EditSequence.Enabled   := TRUE;
  EditImageName.Enabled  := TRUE
end;


procedure TFormLyapunov.BitBtnPauseClick(Sender: TObject);
begin
  Continue := FALSE;
  BitBtnStart.Enabled := TRUE;
  BitBtnReset.Enabled := TRUE;

  // Unlock user to allow changing parameters during pause
  TabSheetSetup.Enabled  := TRUE;
  EditSequence.Enabled   := TRUE;
  EditImageName.Enabled  := TRUE
end;


procedure TFormLyapunov.BitBtnResetClick(Sender: TObject);
begin
  ResetStartPixel
end;


procedure TFormLyapunov.EditLimitsChange(Sender: TObject);
  VAR
    value:  Double;
    s    :  STRING;
begin
  s := (Sender AS TEdit).Text;
  IF   LENGTH(s) > 0
  THEN BEGIN
    value := StrToFloat(s);
    IF   value > 4.0
    THEN BEGIN                                      // localize
      ShowMessage('Value cannot be greater than ' + Format('%.2f', [4.00]));
      (Sender AS TEdit).Text := Format('%.2f', [4.00]);
    END;
    ResetStartPixel
  END
end;


procedure TFormLyapunov.EditPixelsChange(Sender: TObject);
  VAR
    value:  Integer;
    s    :  STRING;
begin
  s := (Sender AS TEdit).Text;
  IF   LENGTH(s) > 0
  THEN BEGIN
    value := StrToInt(s);
    IF   (value = 0) OR (value > 2048)
    THEN BEGIN
      ShowMessage('Value cannot be 0 or > 2048.');
      (Sender AS TEdit).Text := '100';
    END;
    ResetStartPixel
  END
end;


procedure TFormLyapunov.EditIterationsChange(Sender: TObject);
  VAR
    value:  Integer;
    s    :  STRING;
begin
  s := (Sender AS TEdit).Text;
  IF   LENGTH(s) > 0
  THEN BEGIN
    value := StrToInt(s);
    IF   value = 0
    THEN BEGIN
      ShowMessage('Value cannot be 0.');
      (Sender AS TEdit).Text := '100';
    END;
    ResetStartPixel
  END
end;


procedure TFormLyapunov.CheckBoxStretchRawClick(Sender: TObject);
begin
  ImageLyapunovRaw.Stretch     := CheckBoxStretchRaw.Checked;
  CheckBoxStretchColor.Checked := CheckBoxStretchRaw.Checked
end;



procedure TFormLyapunov.CheckBoxStretchColorClick(Sender: TObject);
begin
  ImageLyapunovColor.Stretch := CheckBoxStretchColor.Checked;
  CheckBoxStretchRaw.Checked := CheckBoxStretchColor.Checked
end;


procedure TFormLyapunov.ComboBoxSettingsChange(Sender: TObject);
  VAR
    index:  INTEGER;
    s    :  STRING;
begin
  s := ComboboxSettings.Text;

  // Assume all hardwired settings are error free.
  // Each assignment below triggers corresponding OnChange, which is EditChange.

  index := POS('|', s);
  EditImageName.Text := COPY(s,1,index-1);
  Delete(s, 1,index);

  index := POS('|', s);
  EditSequence.Text := COPY(s,1,index-1);
  Delete(s, 1,index);

  index := POS('|', s);
  EditAMin.Text := LocalizeFloatString( COPY(s,1,index-1) );
  Delete(s, 1,index);

  index := POS('|', s);
  EditAMax.Text := LocalizeFloatString( COPY(s,1,index-1) );
  Delete(s, 1,index);

  index := POS('|', s);
  EditBMin.Text := LocalizeFloatString( COPY(s,1,index-1) );
  Delete(s, 1,index);

  EditBMax.Text := LocalizeFloatString(s)
end;


// Use this trick with csOwnerDrawFixed Style TComboBox to only display
// first part of what really is in the line.  (The rest of the line contains
// various parameters associated with the displayed name.)
procedure TFormLyapunov.ComboBoxSettingsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);

  VAR
    s:  STRING;
begin
  WITH Control AS TComboBox DO
  BEGIN
    Canvas.FillRect(Rect);
    s := Items[Index];
    s := COPY(s, 1, POS('|',s)-1);
    Canvas.TextOut(Rect.Left, Rect.Top, s)
  END
end;


procedure TFormLyapunov.ComboBoxBitmapSizeChange(Sender: TObject);
  CONST
    aSize:  ARRAY[0..10] OF INTEGER =
            (  48,  96, 192, 360, 384, 480, 600,  768,  900, 1200, 1500);
    bSize:  ARRAY[0..10] OF INTEGER =
            (  64, 128, 256, 480, 512, 640, 800, 1024, 1200, 1600, 2000);
  VAR
    index:  INTEGER;
begin
  index := (Sender AS TComboBox).ItemIndex;

  IF   index IN [0..SizeOf(aSize)-1]
  THEN BEGIN
    EditPixelsB.Text := IntToStr( bSize[index] );
    EditPixelsA.Text := IntToStr( aSize[index] )
  END
end;


procedure TFormLyapunov.ShapeColorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IF   ColorDialog.Execute
  THEN (Sender AS TShape).Brush.Color := ColorDialog.Color;

  UpdateColorScheme
end;


PROCEDURE TFormLyapunov.UpdateColorScheme;
  VAR
    BitmapColorScale:  TBitmap;
    i               :  INTEGER;
    x               :  Single;
BEGIN
  BitmapColorScale := TBitmap.Create;
  TRY
    BitmapColorScale.Width  := ImageColorScale.Width;
    BitmapColorScale.Height := ImageColorScale.Height;
    BitmapColorScale.PixelFormat := pf24bit;

    LyapunovLambdaMap.SetColorScheme(ColorSchemeChaos, ColorSchemeOrder);
    LyapunovLambdaMap.SetColorParameters(ShapeChaosSolidColor.Brush.Color,
                       ShapeChaosGradientFrom.Brush.Color,
                       ShapeChaosGradientTo.Brush.Color,

                       ShapeOrderSolidColor.Brush.Color,
                       ShapeOrderGradientFrom.Brush.Color,
                       ShapeOrderGradientTo.Brush.Color);

    FOR i := 0 TO BitmapColorScale.Width DO
    BEGIN
      x := LyapunovLambdaMap.LambdaMin +
           (i/BitmapColorScale.Width)*(LyapunovLambdaMap.LambdaMax - LyapunovLambdaMap.LambdaMin);
      BitmapColorScale.Canvas.Pen.Color := LyapunovLambdaMap.LambdaValueColor(x);
      BitmapColorScale.Canvas.MoveTo(i,0);
      BitmapColorScale.Canvas.LineTo(i, BitmapColorScale.Height);
    END;

    ImageColorScale.Picture.Graphic := BitmapColorScale;
  FINALLY
    BitmapColorScale.Free
  END;

  IF   Assigned(BitmapColor)
  THEN BitmapColor.Free;

  BitmapColor := LyapunovLambdaMap.ColorLambdaBitmap;
  ImageLyapunovColor.Picture.Graphic := BitmapColor
END {UpdateColorMapping};


procedure TFormLyapunov.RadioButtonOrderColorClick(Sender: TObject);
begin
  CASE (Sender AS TRadioButton).Tag OF
    1:  ColorSchemeOrder := csGradient;
    2:  ColorSchemeOrder := csReverseGradient;
    3:  ColorSchemeOrder := csRainbow;
    4:  ColorSchemeOrder := csReverseRainbow;
    ELSE
      ColorSchemeOrder := csSolid;
  END;

  UpdateColorScheme
end;


procedure TFormLyapunov.RadioButtonChaosColorClick(Sender: TObject);
begin
  CASE (Sender AS TRadioButton).Tag OF
    1:  ColorSchemeChaos := csGradient;
    2:  ColorSchemeChaos := csReverseGradient;
    3:  ColorSchemeChaos := csRainbow;
    4:  ColorSchemeChaos := csReverseRainbow;
    ELSE
      ColorSchemeChaos := csSolid;
  END;

  UpdateColorScheme
end;


procedure TFormLyapunov.ImageLyapunovRawMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
  VAR
    xActual   :  INTEGER;
    yActual   :  INTEGER;

    Value     :  Single;
    Bytes     :  Integer ABSOLUTE Value;
begin
  // Don't respond to MouseMove when generating image.  Occasional "white"
  // lines are created for an unknown reason, so this is blocked to prevent
  // that problem.
  IF   NOT TimerDisplay.Enabled
  THEN BEGIN
    IF   CheckBoxStretchRaw.Checked
    THEN BEGIN
      xActual := MulDiv(X, LyapunovLambdaMap.Bitmap.Width,  ImageLyapunovRaw.Width);
      yActual := MulDiv(Y, LyapunovLambdaMap.Bitmap.Height, ImageLyapunovRaw.Height)
    END
    ELSE BEGIN
      xActual := X;
      yActual := Y
    END;

    // If bitmap is smaller than image area, only show values if inside bitmap.
    IF   (xActual < ImageLyapunovRaw.Picture.Bitmap.Width) AND
         (yActual < ImageLyapunovRAw.Picture.Bitmap.Height)
    THEN BEGIN
      Value := pRowSingleArray(LyapunovLambdaMap.Bitmap.Scanline[yActual])[xActual];
      LabelLambdaValue.Caption :=
        Format('%.7g = hex %8.8X  ($xxRRGGBB)', [Value, Bytes])
    END
    ELSE LabelLambdaValue.Caption := '?'
  END
end;


procedure TFormLyapunov.ImageLyapunovColorMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
VAR
    xActual:  INTEGER;
    yActual:  INTEGER;
    Value  :  TRGBTriple;
begin
  IF   CheckBoxStretchColor.Checked
  THEN BEGIN
    xActual := MulDiv(X, BitmapColor.Width,  ImageLyapunovColor.Width);
    yActual := MulDiv(Y, BitmapColor.Height, ImageLyapunovColor.Height)
  END
  ELSE BEGIN
    xActual := X;
    yActual := Y
  END;

  // If bitmap is smaller than image area, only show values if inside bitmap.
  IF   (xActual < ImageLyapunovColor.Picture.Bitmap.Width) AND
       (yActual < ImageLyapunovColor.Picture.Bitmap.Height)
  THEN BEGIN
    Value := pRGBTripleArray(BitmapColor.Scanline[yActual])[xActual];
    LabelColorRGB.Caption :=
      Format('R=%d, G=%d, B=%d', [Value.rgbtRed, Value.rgbtGreen, Value.rgbtBlue])
  END
  ELSE LabelColorRGB.Caption := 'R=?, G=?, B=?'

end;


procedure TFormLyapunov.ButtonSaveClick(Sender: TObject);
  VAR
    Extension:  STRING;
    JPEG     :  TJPEGImage;
begin
  SavePictureDialog.FileName := EditImageName.Text;
  IF   SavePictureDialog.Execute
  THEN BEGIN
    Extension := UpperCase(ExtractFileExt(SavePictureDialog.FileName));
    IF   Extension = '.JPG'
    THEN BEGIN
      JPEG := TJPEGImage.Create;
      JPEG.CompressionQuality := 50;  // fairly low since artifact don't matter
      JPEG.Assign(BitmapColor);
      JPEG.SaveToFile(SavePictureDialog.FileName)
    END
    ELSE
      IF   Extension = '.BMP'
      THEN BitmapColor.SaveToFile(SavePictureDialog.FileName)
      ELSE ShowMessage('Cannot write "' + Extension + '" file type.')
  END
end;


procedure TFormLyapunov.LabelLab2Click(Sender: TObject);
begin
  ShellExecute(0, 'open', pchar('http://www.efg2.com/lab'),
               NIL, NIL, SW_NORMAL)
end;


FUNCTION TFormLyapunov.ColoringText(CONST s:  STRING):  STRING;
BEGIN
  IF   s = 'Chaos'
  THEN BEGIN
    // Chaos
    IF   RadioButtonChaosSolidColor.Checked
    THEN RESULT := 'Solid Color (' + ColorToString(ShapeChaosSolidColor.Brush.Color) + ')';

    IF   RadioButtonChaosGradient.Checked
    THEN RESULT := 'Gradient (' +
                   ColorToString(ShapeChaosGradientFrom.Brush.Color) + ' to ' +
                   ColorToString(ShapeChaosGradientTo.Brush.Color) + ')';

    IF   RadioButtonChaosGradientReverse.Checked
    THEN RESULT := 'Gradient (' +
                   ColorToString(ShapeChaosGradientTo.Brush.Color) + ' to ' +
                   ColorToString(ShapeChaosGradientFrom.Brush.Color) + ')';

    IF   RadioButtonChaosRainbow.Checked
    THEN RESULT := 'Rainbow';

    IF   RadioButtonChaosReverseRainbow.Checked
    THEN RESULT := 'Reverse Rainbow'
  END
  ELSE BEGIN
    // Order
    IF   RadioButtonOrderSolidColor.Checked
    THEN RESULT := 'Solid Color (' + ColorToString(ShapeOrderSolidColor.Brush.Color) + ')';

    IF   RadioButtonOrderGradient.Checked
    THEN RESULT := 'Gradient (' +
                   ColorToString(ShapeOrderGradientFrom.Brush.Color) + ' to ' +
                   ColorToString(ShapeOrderGradientTo.Brush.Color) + ')';

    IF   RadioButtonOrderGradientReverse.Checked
    THEN RESULT := 'Gradient (' +
                   ColorToString(ShapeOrderGradientTo.Brush.Color) + ' to ' +
                   ColorToString(ShapeOrderGradientFrom.Brush.Color) + ')';

    IF   RadioButtonOrderRainbow.Checked
    THEN RESULT := 'Rainbow';

    IF   RadioButtonOrderReverseRainbow.Checked
    THEN RESULT := 'Reverse Rainbow'
  END
END {ColoringText};


procedure TFormLyapunov.ButtonPrintClick(Sender: TObject);
  VAR
    FromLeft       :  INTEGER;
    FromTop        :  INTEGER;
    PlotRect       :  TRect;
    s              :  STRING;
    TextHeight     :  INTEGER;
BEGIN
  IF   PrinterSetupDialog.Execute
  THEN BEGIN

    Screen.Cursor := crHourGlass;
    TRY
     // Assume square pixels

      Printer.BeginDoc;
      TRY
        // Image will be distortd if pixels are not square (fairly rare)
        ASSERT(GetDeviceCaps(Printer.Handle, LOGPIXELSX) =
               GetDeviceCaps(Printer.handle, LOGPIXELSY),
               'Printer pixels are not square');

        // Print Image
        IF   Printer.PageHeight > Printer.PageWidth  // i.e., poPortrait
        THEN BEGIN
          TextHeight := MulDiv(Printer.PageWidth, 2, 100);

          // center on page top-to-bottom
          FromTop  := (Printer.PageHeight - Printer.PageWidth) DIV 2;
          FromLeft := MulDiv(Printer.PageWidth, 8, 100);  // 8%
          PlotRect := Rect(FromLeft,
                           FromTop,
                           FromLeft + MulDiv(Printer.PageWidth, 84, 100),         // 84% width
                           FromTop  + 3*MulDiv(Printer.PageWidth, 84, 100) DIV 4) // 4:3 aspect ratio
        END
        ELSE BEGIN  // poLandscape
          TextHeight := MulDiv(Printer.PageHeight, 2, 100);

          // center on page left-to-right
          FromLeft := MulDiv(Printer.PageWidth, 8, 100);
          FromTop := MulDiv(Printer.PageHeight, 8, 100);  // 8 %
          PlotRect := Rect(FromLeft,
                           FromTop,
                           FromLeft + MulDiv(Printer.PageWidth, 84, 100),         // 80% width
                           FromTop  + 3*MulDiv(Printer.PageWidth, 84, 100) DIV 4) // 4:3 aspect ratio
        END;

        PrintBitmap(Printer.Canvas, PlotRect, BitmapColor);

        // Header
        Printer.Canvas.Brush.Color := clWhite;
        Printer.Canvas.Font.Height := TextHeight;
        Printer.Canvas.Font.Name := 'Arial';
        Printer.Canvas.Font.Color := clBlack;
        Printer.Canvas.Font.Style := [fsBold];
        s := 'Lyapunov Image:  ' + EditImageName.Text;
        Printer.Canvas.TextOut(FromLeft,
                               FromTop -
                               Printer.Canvas.TextHeight(s),
                               s);

        Printer.Canvas.Font.Height := TextHeight DIV 2;
        s := 'Sequence:  ' + EditSequence.Text;
        Printer.Canvas.TextOut(PlotRect.Right - Printer.Canvas.TextWidth(s),
                               FromTop -
                               Printer.Canvas.TextHeight(s),
                               s);


        // Footer
        Printer.Canvas.Brush.Color := clWhite;
        Printer.Canvas.Font.Style := [];
        s := 'a(' + EditAMin.Text + ' to ' + EditAMax.Text + ', ' +
             EditPixelsA.Text + ' pixels) vs b(' +
             EditBMin.Text + ' to ' + EditBMax.Text + ', ' +
             EditPixelsB.Text + ' pixels); Iterations/point:  ' +
             EditWarmupIterations.Text + ' warmup, ' +
             EditMaxIterations.Text + ' maximum';
        Printer.Canvas.TextOut(FromLeft,
                               PlotRect.Bottom + 2*Printer.Canvas.TextHeight('X'),
                               s);

        s := LabelTimeElapsedValue.Caption + ' seconds creation time; Coloring:  ' +
        'Order=' + ColoringText('Order') + ', Chaos=' + ColoringText('Chaos');
        Printer.Canvas.TextOut(FromLeft,
                               PlotRect.Bottom + 3*Printer.Canvas.TextHeight('X'),
                               s);


        Printer.Canvas.Brush.Color := clWhite;
        Printer.Canvas.Font.Height := TextHeight;
        Printer.Canvas.Font.Name := 'Arial';
        Printer.Canvas.Font.Color := clBlue;
        Printer.Canvas.Font.Style := [fsBold, fsItalic];
        s := 'efg''s Computer Lab';
        Printer.Canvas.TextOut(FromLeft,
                               Printer.PageHeight - Printer.Canvas.TextHeight(s),
                               s);

        Printer.Canvas.Font.Style := [fsBold];
        s := 'www.efg2.com/lab';
        Printer.Canvas.TextOut(Printer.PageWidth - FromLeft   -
                                 Printer.Canvas.TextWidth(s),
                               Printer.PageHeight - Printer.Canvas.TextHeight(s),
                               s)

      FINALLY
        Printer.EndDoc
      END

    FINALLY
      Screen.Cursor := crDefault;
    END

  END

end;

end.
