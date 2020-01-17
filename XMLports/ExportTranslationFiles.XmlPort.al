xmlport 69200 "ExportTranslationFiles"
{
    Direction = Export;
    Encoding = UTF8;
    UseRequestPage = false;
    DefaultNamespace = 'urn:oasis:names:tc:xliff:document:1.2';
    PreserveWhiteSpace = true;
    UseDefaultNamespace = true;
    XmlVersionNo = V10;



    schema
    {
        textelement(xliff)
        {
            textattribute(version)
            {
                trigger OnBeforePassVariable()
                begin
                    version := '1.2';
                end;
            }
            // textattribute(xmlns)
            // {
            //     trigger OnBeforePassVariable()
            //     begin
            //         version := '1.2';
            //     end;
            // }
            tableelement("Translation Header"; "Translation Header")
            {
                XmlName = 'file';
                textattribute(datatype)
                {
                    trigger OnBeforePassVariable()
                    begin
                        //identify language code
                        datatype := 'xml';
                    end;
                }
                textattribute("source-language")
                {
                    trigger OnBeforePassVariable()
                    begin
                        //identify language code
                        "source-language" := 'en-US';
                    end;
                }
                textattribute("target-language")
                {
                    XmlName = 'target-language';

                    trigger OnBeforePassVariable()
                    begin
                        //identify language code
                        "target-language" := format("Translation Header"."Language Id");
                        case "Translation Header"."Language Id" of
                            2067:
                                "target-language" := 'nl-BE';
                        end;
                        // // 2:
                        // //     "target-language" := "Translation Header".Lang2;
                        // // 3:
                        // //     "target-language" := "Translation Header".Lang3;
                        // // 4:
                        // //     "target-language" := "Translation Header".Lang4;
                        // // 5:
                        // //     "target-language" := "Translation Header".Lang5;
                        // end;
                    end;
                }
                fieldattribute(original; "Translation Header"."Project Id")
                {
                }
                textelement(body)
                {
                    textelement(group)
                    {
                        textattribute(id1)
                        {
                            XmlName = 'id';
                            trigger OnBeforePassVariable()
                            begin
                                id1 := 'body';
                            end;
                        }
                        tableelement("Translation Lines"; "Translation Lines")
                        {
                            XmlName = 'trans-unit';
                            LinkTable = "Translation Header";
                            LinkFields = "Project ID" = field("Project ID");
                            fieldattribute(id; "Translation Lines".id)
                            {
                            }
                            fieldattribute("size-unit"; "Translation Lines"."size-unit")
                            {
                            }
                            fieldattribute(translate; "Translation Lines".translate)
                            {
                            }
                            fieldattribute(xmlspace; "Translation Lines".XMLSpace)
                            {
                                Occurrence = Optional;
                            }
                            fieldattribute("al-object-target"; "Translation Lines"."al-object-target")
                            {
                                Occurrence = Optional;
                            }
                            fieldelement(source; "Translation Lines".source)
                            {
                            }
                            textelement(target)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    case "Translation Header".TranslationNo of

                                        1:
                                            target := "Translation Lines".Lang1;
                                        2:
                                            target := "Translation Lines".Lang2;
                                        3:
                                            target := "Translation Lines".Lang3;
                                        4:
                                            target := "Translation Lines".Lang4;
                                        5:
                                            target := "Translation Lines".Lang5;
                                    end;
                                end;
                            }
                            fieldelement(note; "Translation Lines".note1)
                            {
                                fieldattribute(from; "Translation Lines".Note1From)
                                {
                                }
                                fieldattribute(annotates; "Translation Lines".Note1Annotates)
                                {
                                }
                                fieldattribute(priority; "Translation Lines".Note1Priority)
                                {
                                }
                            }
                            fieldelement(note; "Translation Lines".note2)
                            {
                                fieldattribute(from; "Translation Lines".Note2From)
                                {
                                }
                                fieldattribute(annotates; "Translation Lines".Note2Annotates)
                                {
                                }
                                fieldattribute(priority; "Translation Lines".Note2Priority)
                                {
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    procedure setParameters(Header: Record "Translation Header")
    begin
        "Translation Header".SetRange("Project Id", Header."Project Id");
        "Translation Header".SetRange("Language Id", Header."Language Id");
    end;

}