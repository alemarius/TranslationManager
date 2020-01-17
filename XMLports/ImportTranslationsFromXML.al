xmlport 69206 "Import Translation From XML"
{
    Caption = 'Import Translation From XML';
    DefaultNamespace = 'urn:oasis:names:tc:xliff:document:1.2';
    Direction = Import;
    Encoding = UTF8;
    //FileName = 'C:\Users\Simple\Desktop\Translations\ChemDisFull.g.xlf';
    XmlVersionNo = V10;
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
                            textelement(target1)
                            {
                                XmlName = 'target';
                                MinOccurs = Zero;

                                trigger OnAfterAssignVariable()
                                begin

                                end;

                            }

                            textelement(note)
                            {
                                textattribute(from)
                                {

                                }
                                textattribute(annotates)
                                {

                                }
                                textattribute(priority)
                                {

                                }
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
                exit(0);
        end;
    end;

    procedure CreateTempTranslation(ProjCode: Code[10]; Source: Text; Target: Text)
    begin
        If StrLen(Source) > 400 then
            exit;
        TempTranslations.Init;
        TempTranslations."Project Id" := ProjCode;
        TempTranslations.Source := Source;
        TempTranslations.Translation :=
    end;
}