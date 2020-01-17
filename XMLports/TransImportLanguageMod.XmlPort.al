xmlport 69202 "Trans Import Language Mod"
{
    Format = VariableText;
    UseRequestPage = false;
    FieldSeparator = '<:>';

    schema
    {
        textelement(root)
        {
            tableelement("Language Map"; "Translations")
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

    trigger OnPostXmlPort()
    begin
        // if TempLanguageMap.Source <> '' then
        //     if not TempLanguageMap.Insert then
        //         TempLanguageMap.Modify;
    end;

    trigger OnPreXmlPort()
    var
        Language: Record Language;
    begin
        if ProjectCode = '' then
            Error('No Project Selected');
    end;

    var
        ProjectCode: Code[10];
        //TempLanguageMap: Record "Language Map" temporary;
        //TooLong: Boolean;
        tempTranslation: Record "Translations" temporary;


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

    procedure SetParameter(TranslHeader: Record "Translation Header")
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

    procedure insertTranslation(tempTransl: Record "Translations")
    var
        Translation: Record "Translations";
    begin
        Translation := tempTranslation;

        if not Translation.Insert() then;
    end;

}

