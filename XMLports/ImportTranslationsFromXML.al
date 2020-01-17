xmlport 69206 "Import Translation From XML"
{
    Caption = 'Import Translation From XML';
    DefaultNamespace = 'urn:oasis:names:tc:xliff:document:1.2';
    Direction = Import;
    Encoding = UTF8;
    XmlVersionNo = V11;
    Format = Xml;
    PreserveWhiteSpace = true;
    UseDefaultNamespace = true;
    UseRequestPage = false;
    UseLax = true;


    schema
    {
        textelement(xliff)
        {
            textattribute(version)
            {
                // trigger OnAfterAssignVariable()
                // begin
                //     TransProject."Xliff Version" := version;
                // end;
            }
            textelement(infile)
            {
                XmlName = 'file';
                textattribute(datatype)
                {

                }
                textattribute("source-language")
                {

                }
                textattribute("target-language")
                {
                    trigger OnAfterAssignVariable()
                    begin
                        TargetLang := GetLangIdFromXML("target-language");
                    end;
                }
                textattribute(original)
                {
                }
                textelement(body)
                {
                    textelement(group)
                    {

                        textattribute(id1)
                        {
                            XmlName = 'id';
                        }
                        textelement("trans-unit")
                        {
                            XmlName = 'trans-unit';

                            textattribute(id)
                            {

                            }
                            textattribute("size-unit")
                            {
                            }
                            textattribute(translate)
                            {

                            }
                            textattribute("al-object-target")
                            {
                                Occurrence = Optional;
                            }

                            textelement(source)
                            {

                            }
                            textelement(target)
                            {
                                // XmlName = 'target';
                                MinOccurs = Zero;

                                trigger OnAfterAssignVariable()
                                begin
                                    CreateTempTranslation(TranslationHeader."Project Id", TargetLang, source, target);
                                end;

                            }

                            textelement(note)
                            {
                                MinOccurs = Zero;
                                textattribute(from)
                                {

                                }
                                textattribute(annotates)
                                {

                                }
                                textattribute(priority)
                                {

                                }

                                trigger OnAfterAssignVariable()
                                begin
                                end;
                            }

                            trigger OnAfterAssignVariable()
                            begin
                            end;
                        }
                    }
                }
            }
        }
    }
    trigger OnInitXmlPort()
    begin
        Error('Work in progress, use line analyzer XML');
    end;

    trigger OnPostXmlPort()
    begin
        InsertTranslations();
    end;

    var
        TargetLang: Integer;

        TranslationHeader: Record "SPLN Translation Header";
        LanguageId: Integer;
        TempTranslations: Record "SPLN Translations" temporary;

    procedure SetParameters(newTranslationHeader: Record "SPLN Translation Header")
    begin
        TranslationHeader := newTranslationHeader;
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