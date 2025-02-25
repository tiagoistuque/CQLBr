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

unit cqlbr.register;

{$ifdef fpc}
  {$mode delphi}{$H+}
{$endif}

interface

uses
  SysUtils,
  Generics.Collections,
  cqlbr.interfaces;

type
  TCQLBrRegister = class
  strict private
    class var FCQLSelect: TDictionary<TDBName, ICQLSelect>;
    class var FCQLWhere: TDictionary<TDBName, ICQLWhere>;
    class var FCQLSerialize: TDictionary<TDBName, ICQLSerialize>;
    class var FCQLFunctions: TDictionary<TDBName, ICQLFunctions>;
  private
    class constructor Create;
    class destructor Destroy;
  public
    // Select for database
    class procedure RegisterSelect(const ADBName: TDBName;
      const ACQLSelect: ICQLSelect);
    class function Select(const ADBName: TDBName): ICQLSelect;
    // Select for database
    class procedure RegisterWhere(const ADBName: TDBName;
      const ACQLWhere: ICQLWhere);
    class function Where(const ADBName: TDBName): ICQLWhere;
    // Functions for database
    class procedure RegisterFunctions(const ADBName: TDBName;
      const ACQLFunctions: ICQLFunctions);
    class function Functions(const ADBName: TDBName): ICQLFunctions;
    // Serialize for database
    class procedure RegisterSerialize(const ADBName: TDBName;
      const ACQLSelect: ICQLSerialize);
    class function Serialize(const ADBName: TDBName): ICQLSerialize;
  end;

implementation

const
  TStrDBName: array[dbnMSSQL..dbnNexusDB] of
                  string = ('MSSQL','MySQL','Firebird','SQLite','Interbase','DB2',
                            'Oracle','Informix','PostgreSQL','ADS','ASA',
                            'AbsoluteDB','MongoDB','ElevateDB','NexusDB');


class constructor TCQLBrRegister.Create;
begin
  FCQLSelect := TDictionary<TDBName, ICQLSelect>.Create;
  FCQLWhere := TDictionary<TDBName, ICQLWhere>.Create;
  FCQLSerialize := TDictionary<TDBName, ICQLSerialize>.Create;
  FCQLFunctions := TDictionary<TDBName, ICQLFunctions>.Create;
end;

class destructor TCQLBrRegister.Destroy;
begin
  FCQLSelect.Clear;
  FCQLSelect.Free;
  FCQLWhere.Clear;
  FCQLWhere.Free;
  FCQLSerialize.Clear;
  FCQLSerialize.Free;
  FCQLFunctions.Clear;
  FCQLFunctions.Free;
  inherited;
end;

class function TCQLBrRegister.Functions(const ADBName: TDBName): ICQLFunctions;
begin
  Result := nil;
  if FCQLFunctions.ContainsKey(ADBName) then
    Result := FCQLFunctions[ADBName];
end;

class function TCQLBrRegister.Select(const ADBName: TDBName): ICQLSelect;
begin
  Result := nil;
  if not FCQLSelect.ContainsKey(ADBName) then
    raise Exception
            .Create('O select do banco ' + TStrDBName[ADBName] + ' n�o est� registrado, adicione a unit "cqlbr.select.???.pas" onde ??? nome do banco, na cl�usula USES do seu projeto!');

    Result := FCQLSelect[ADBName];
end;

class procedure TCQLBrRegister.RegisterFunctions(const ADBName: TDBName;
      const ACQLFunctions: ICQLFunctions);
begin
  FCQLFunctions.AddOrSetValue(ADBName, ACQLFunctions);
end;

class procedure TCQLBrRegister.RegisterSelect(const ADBName: TDBName;
  const ACQLSelect: ICQLSelect);
begin
  FCQLSelect.AddOrSetValue(ADBName, ACQLSelect);
end;

class function TCQLBrRegister.Serialize(const ADBName: TDBName): ICQLSerialize;
begin
  if not FCQLSerialize.ContainsKey(ADBName) then
    raise Exception
            .Create('O serialize do banco ' + TStrDBName[ADBName] + ' n�o est� registrado, adicione a unit "cqlbr.serialize.???.pas" onde ??? nome do banco, na cl�usula USES do seu projeto!');

  Result := FCQLSerialize[ADBName];
end;

class function TCQLBrRegister.Where(const ADBName: TDBName): ICQLWhere;
begin
  Result := nil;
  if FCQLWhere.ContainsKey(ADBName) then
    Result := FCQLWhere[ADBName];
end;

class procedure TCQLBrRegister.RegisterSerialize(const ADBName: TDBName;
  const ACQLSelect: ICQLSerialize);
begin
  FCQLSerialize.AddOrSetValue(ADBName, ACQLSelect);
end;

class procedure TCQLBrRegister.RegisterWhere(const ADBName: TDBName; const ACQLWhere: ICQLWhere);
begin
  FCQLWhere.AddOrSetValue(ADBName, ACQLWhere);
end;

end.
