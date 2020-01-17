xmlport 69205 "SPLN Import Translation Source"
{
    Caption = 'Import Translation Source';
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
                                trigger OnAfterAssignVariable()
                                begin
                                    TranslationLines.id := id;
                                end;
                            }
                            textattribute("size-unit")
                            {
                                trigger OnAfterAssignVariable()
                                begin
                                    TranslationLines."size-unit" := "size-unit";
                                end;
                            }
                            textattribute(translate)
                            {

                                trigger OnAfterAssignVariable()
                                begin
                                    TranslationLines.translate := translate;
                                end;
                            }
                            textattribute("al-object-target")
                            {
                                Occurrence = Optional;

                                trigger OnAfterAssignVariable()
                                begin
                                    TranslationLines."al-object-target" := "al-object-target";
                                end;
                            }

                            textelement(source)
                            {

                                trigger OnAfterAssignVariable()
                                begin
                                    TranslationLines.source := source;
                                end;
                            }
                            // textelement(target1)
                            // {
                            //     XmlName = 'target';
                            //     MinOccurs = Zero;

                            // }

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

                                trigger OnAfterAssignVariable()
                                begin
                                    if (from = 'Developer') then begin
                                        TranslationLines.note1 := note;
                                        TranslationLines.Note1Annotates := annotates;
                                        TranslationLines.Note1From := from;
                                        TranslationLines.Note1Priority := priority
                                    end
                                    else begin
                                        TranslationLines.note2 := note;
                                        TranslationLines.Note2Annotates := annotates;
                                        TranslationLines.Note2From := from;
                                        TranslationLines.Note2Priority := priority;
                                    end;
                                end;
                            }

                            trigger OnAfterAssignVariable()
                            begin
                                TranslationLines."Project ID" := TranslationHeader."Project ID";
                                TranslationLines.Insert();
                                TranslationLines.Init();
                            end;
                        }
                    }
                }
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        TranslationLines.Init();
    end;

    var
        TranslationHeader: Record "SPLN Translation Header";
        LanguageId: Integer;
        TranslationLines: Record "SPLN Translation Lines";

    procedure SetParameters(newTranslationHeader: Record "SPLN Translation Header")
    begin
        TranslationHeader := newTranslationHeader;
    end;
}