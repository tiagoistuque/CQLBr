{
         CQL Brasil - Criteria Query Language for Delphi/Lazarus


                   Copyright (c) 2019, Isaque Pinheiro
                          All rights reserved.

                    GNU Lesser General Public License
                      Vers�o 3, 29 de junho de 2007

       Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
       A todos � permitido copiar e distribuir c�pias deste documento de
       licen�a, mas mud�-lo n�o � permitido.

       Esta vers�o da GNU Lesser General Public License incorpora
       os termos e condi��es da vers�o 3 da GNU General Public License
       Licen�a, complementado pelas permiss�es adicionais listadas no
       arquivo LICENSE na pasta principal.
}

{ @abstract(CQLBr Framework)
  @created(18 Jul 2019)
  @author(Isaque Pinheiro <isaquesp@gmail.com>)
  @author(Site : https://www.isaquepinheiro.com.br)
}

unit cqlbr.functions.mysql;

interface

uses
  SysUtils,
  cqlbr.functions.abstract;

type
  TCQLFunctionsMySQL = class(TCQLFunctionAbstract)
  public
    constructor Create;
    function Substring(const AVAlue: String; const AStart, ALength: Integer): String; override;
    function Date(const AVAlue: String; const AFormat: String): String; overload; override;
    function Date(const AVAlue: String): String; overload; override;
    function Day(const AValue: String): String; override;
    function Month(const AValue: String): String; override;
    function Year(const AValue: String): String; override;
    function Concat(const AValue: array of string): string; override;
  end;

implementation

uses
  cqlbr.register,
  cqlbr.interfaces;

{ TCQLFunctionsMySQL }

function TCQLFunctionsMySQL.Concat(const AValue: array of string): string;
var
  LFor: Integer;
  LIni: Integer;
  LFin: Integer;
const
  cCONCAT = 'CONCAT(%s)';
begin
  Result := '';
  LIni := Low(AValue);
  LFin := High(AValue);

  for LFor := LIni to LFin do
  begin
    Result := Result + AValue[LFor];
    if LFor < LFin then
      Result := Result + ', ';
  end;
  Result := Format(cCONCAT, [Result]);
end;

constructor TCQLFunctionsMySQL.Create;
begin
  inherited;
end;

function TCQLFunctionsMySQL.Date(const AVAlue: String; const AFormat: String): String;
begin
  Result := 'DATE_FORMAT(' + AValue + ', ' + AFormat + ')';
end;

function TCQLFunctionsMySQL.Date(const AVAlue: String): String;
begin
  Result := 'DATE_FORMAT(' + AValue + ', ''yyyy-MM-dd'')';
end;

function TCQLFunctionsMySQL.Substring(const AVAlue: String; const AStart,
  ALength: Integer): String;
begin
  Result := 'SUBSTRING(' + AValue + ', ' + IntToStr(AStart) + ', ' + IntToStr(ALength) + ')';
end;

function TCQLFunctionsMySQL.Day(const AValue: String): String;
begin
  Result := 'DAY(' + AValue + ')';
end;

function TCQLFunctionsMySQL.Month(const AValue: String): String;
begin
  Result := 'MONTH(' + AValue + ')';
end;

function TCQLFunctionsMySQL.Year(const AValue: String): String;
begin
  Result := 'YEAR(' + AValue + ')';
end;

initialization
  TCQLBrRegister.RegisterFunctions(dbnMySQL, TCQLFunctionsMySQL.Create);

end.
