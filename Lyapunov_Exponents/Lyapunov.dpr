// efg, March/April 2000
// www.efg2.com/Lab/FractalsAndChaos/Lyapunov.htm
//
// Re-write of Sun C/Turbo Pascal programs from 1992.
//
// Copyright 1992, 2000, Earl F. Glynn.  All Rights Reserved.
// May be used freely for non-commercial use.
// Not to be sold for profit without permission.

program Lyapunov;

uses
  Forms,
  ScreenLyapunov in 'ScreenLyapunov.pas' {FormLyapunov},
  LyapunovLibrary in 'LyapunovLibrary.PAS',
  SpectraLibrary in 'SpectraLibrary.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormLyapunov, FormLyapunov);
  Application.Run;
end.
