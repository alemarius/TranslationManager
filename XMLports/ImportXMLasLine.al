xmlport 69233 "Import XML transl as Line"
{
    Format = VariableText;
    UseRequestPage = false;
    //FieldSeparator = '<:>';

    schema
    {
        textelement(root)
        {
            tableelement("Language Map"; "SPLN Translations")
            {
                AutoSave = false;
                XmlName = 'LanguageMap';
                UseTemporary = true;
                textelement(Line)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        SolveLine();
                    end;
                }
            }
        }
    }

    trigger OnPreXmlPort()

    begin
        if ProjectCode = '' then
            Error('No Project Selected');
    end;

    var
        ProjectCode: Code[10];
        //TempLanguageMap: Record "SPLN Language Map" temporary;
        //TooLong: Boolean;
        tempTranslation: Record "SPLN Translations" temporary;
        TempTranslations: Record "SPLN Translations" temporary;

    local procedure SolveLine()
    var
        Pos: Integer;
        CodeLine: Text;
        TranslationLine: Text;
        LastCode: Code[10];
        LangCode: Code[10];
        LangId: Integer;
    begin
        Pos := StrPos(Line, ':');
        if Pos = 0 then
            exit;

        CodeLine := CopyStr(Line, 1, Pos - 1);
        TranslationLine := CopyStr(Line, Pos + 1);
        if (TranslationLine = '') or (CodeLine = '') then
            exit;

        GetValues(CodeLine, LastCode, LangCode);

        if (LastCode <> 'L999') or (LangCode = '') or (LangCode = '1') then begin
            SolveTranslation();
            exit;
        end;
        if StrLen(TranslationLine) > 380 then
            exit;
        Evaluate(LangId, LangCode);
        addTranslation(ProjectCode, LangId, TranslationLine);
    end;

    local procedure GetValues(var TextLine: Text; var LastCode: Code[4]; var LangId: Code[10])
    var
        Pos: Integer;
        TempLine: Text[50];
    begin
        while StrLen(TextLine) > 0 do begin
            Pos := StrPos(TextLine, '-');
            if Pos = 0 then begin
                LastCode := TextLine;
                TextLine := '';
            end else begin
                TempLine := CopyStr(TextLine, 1, Pos - 1);
                TextLine := DelStr(TextLine, 1, Pos);
                if StrLen(TempLine) < 12 then
                    if TempLine[1] = 'A' then
                        LangId := CopyStr(TempLine, 2, 5);
            end;
        end;
    end;

    procedure SetParameter(TranslHeader: Record "SPLN Translation Header")
    begin
        ProjectCode := TranslHeader."Project ID";
    end;

    procedure addTranslation(PrCode: code[10]; LangId: Integer; TranslText: Text[1024])
    begin
        tempTranslation.Init();
        tempTranslation."Project Id" := PrCode;
        tempTranslation."Language Id" := LangId;
        tempTranslation.Translation := TranslText;
        if not tempTranslation.Insert() then begin
            solveTranslation();

            tempTranslation.Init();
            tempTranslation."Project Id" := PrCode;
            tempTranslation."Language Id" := LangId;
            tempTranslation.Translation := TranslText;
            tempTranslation.Insert();
            exit;
        end;
    end;

    procedure SolveTranslation()
    var
        translSource: text[400];
    begin
        tempTranslation.SetRange("Language Id", 1033);
        if tempTranslation.FindFirst() then begin
            translSource := tempTranslation.Translation;
            tempTranslation.Delete();
            tempTranslation.Reset();
            if tempTranslation.FindSet() then begin
                repeat
                    tempTranslation.Source := translSource;
                    insertTranslation(tempTranslation);
                until tempTranslation.Next() = 0;
            end;
        end;
        tempTranslation.Reset();
        tempTranslation.DeleteAll();
        Clear(tempTranslation);
    end;

    procedure insertTranslation(tempTransl: Record "SPLN Translations")
    var
        Translation: Record "SPLN Translations";
    begin
        Translation := tempTranslation;

        if not Translation.Insert() then;
    end;

    procedure GetLangIdFromXML(XMlLang: Text): Integer
    begin
        case XMlLang of
            'fr-FR':
                exit(1036);
            'de-DE':
                exit(1031);
            'es-ES':
                exit(1034);
            else
                error('No lang code hardcoded');
        end;
    end;

    procedure CreateTempTranslation(ProjCode: Code[10]; LangID: Integer; Source: Text; Target: Text)
    begin
        If StrLen(Source) > 400 then
            exit;
        TempTranslations.Init;
        TempTranslations."Project Id" := ProjCode;
        TempTranslations."Language Id" := LangID;
        TempTranslations.Source := Source;
        TempTranslations.Translation := Target;
        If not TempTranslations.Insert() then
            TempTranslations.Delete();
    end;

    procedure InsertTranslations()
    var
        Translations: Record "SPLN Translations";
    begin
        if TempTranslations.FindSet() then
            repeat
                Translations := TempTranslations;
                if Translations.Insert() then;
            until TempTranslations.Next() = 0;
    end;
}

