xmlport 69233 "Import XML transl as Line"
{
    Format = VariableText;
    UseRequestPage = false;
    Direction = Import;
    FieldSeparator = '<:::::>';

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

    trigger OnPreXmlPort()

    begin
        if ProjectCode = '' then
            Error('No Project Selected');
    end;

    trigger OnPostXmlPort()
    begin
        InsertTranslations();
    end;

    var
        ProjectCode: Code[10];

        TempTranslations: Record "Translations" temporary;

    local procedure SolveLine()
    var
        Pos: Integer;
        PosEnd: Integer;
        CodeLine: Text;
        TranslationLine: Text;
        LangId: Integer;
    begin
        if TargetLang = 0 then begin
            Pos := StrPos(Line, 'target-language=');
            if Pos = 0 then
                exit;
            Line := CopyStr(Line, Pos + 17, 5);
            TargetLang := GetLangIdFromXML(Line);
        end;


        Pos := StrPos(Line, '<source>');
        if Pos <> 0 then begin
            Source := CopyStr(Line, Pos + 8, StrPos(Line, '</source>') - Pos - 8);
            exit;
        end;

        Pos := StrPos(Line, '<target>');
        if Pos <> 0 then begin
            Target := CopyStr(Line, Pos + 8, StrPos(Line, '</target>') - Pos - 8);
            CreateTempTranslation(ProjectCode, TargetLang, Source, Target);
            exit;
        end;
    end;

    procedure SetParameters(TranslHeader: Record "Translation Header")
    begin
        ProjectCode := TranslHeader."Project ID";
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

    procedure CreateTempTranslation(pProjCode: Code[10]; pLangID: Integer; pSource: Text; pTarget: Text)
    begin
        If StrLen(pSource) > 400 then
            exit;
        TempTranslations.Init;
        TempTranslations."Project Id" := pProjCode;
        TempTranslations."Language Id" := pLangID;
        TempTranslations.Source := pSource;
        TempTranslations.Translation := pTarget;
        If not TempTranslations.Insert() then
            TempTranslations.Delete();
    end;

    procedure InsertTranslations()
    var
        Translations: Record "Translations";
    begin
        if TempTranslations.FindSet() then
            repeat
                Translations := TempTranslations;
                if Translations.Insert() then;
            until TempTranslations.Next() = 0;
    end;

    var
        TargetLang: Integer;
        Source: Text;
        Target: Text;
}

