page 69201 "Translation Header"
{
    PageType = List;
    SourceTable = "Translation Header";
    ApplicationArea = All;
    UsageCategory = Administration;
    AdditionalSearchTerms = 'MAL';
    Caption = 'Translations Management';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Project ID"; "Project ID")
                {
                    ApplicationArea = All;
                }
                field(LangCode; LangCode)
                {
                    ApplicationArea = All;
                }
                field(LangId; "Language Id")
                {
                    Caption = 'Language IDIS';
                    //CaptionML = ENU='TESG',ENG='TESGB';
                    ApplicationArea = All;
                }
                field(TranslationNo; TranslationNo)
                {
                    ApplicationArea = All;
                }

                field(LanguageCases; LanguageCases)
                {
                    ApplicationArea = All;
                }

            }
            group("Translations Preview")
            {
                part(Control1000000008; "Translation Lines SP")
                {
                    ApplicationArea = All;
                    SubPageLink = "Project ID" = FIELD("Project ID");
                }
            }
            group("By Language")
            {
                part(Control1000000013; "Translations")
                {
                    ApplicationArea = All;
                    SubPageLink = "Language Id" = FIELD("Language Id");
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Import VSC generated translation base")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    ImportOriginal: XMLport "Import Translation Source";
                begin
                    ImportOriginal.SetParameters(Rec);
                    ImportOriginal.Run();
                    CurrPage.Update();
                end;
            }
            action("Import Language module txt")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    ImportLangModule: XmlPort "Trans Import Language Mod";
                    ErrorTxt: Label 'Language not selected';
                    Tempblob: Record TempBlob temporary;
                    Instream: InStream;
                    FileManagment: Codeunit "File Management";
                    SourceFilePathGbl: Text;
                begin
                    SourceFilePathGbl := FileManagment.OpenFileDialog('Select File', SourceFilePathGbl, '');
                    Tempblob.Blob.Import(SourceFilePathGbl);
                    Tempblob.Blob.CreateInStream(Instream, TextEncoding::UTF16);
                    ImportLangModule.SetSource(Instream);
                    ImportLangModule.SetParameter(Rec);
                    ImportLangModule.Import();

                    addLanguageHeaders("Project ID");
                end;
            }

            action("Import Language from XML (not yet working)")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    ImportXML: XmlPort "Import Translation From XML";
                begin
                    if "Project Id" = '' then
                        Error('Create project ID first');
                    ImportXML.SetParameters(Rec);
                    ImportXML.Run();
                    CurrPage.Update();

                    addLanguageHeaders("Project ID");
                end;
            }

            action("Import Language from XML as line")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    ImportXML: XmlPort "Import XML transl as Line";
                begin
                    if "Project Id" = '' then
                        Error('Create project ID first');
                    ImportXML.SetParameters(Rec);
                    ImportXML.Run();
                    CurrPage.Update();

                    addLanguageHeaders("Project ID");
                end;
            }

            action("Recreate Language Headers")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if "Project ID" <> '' then
                        addLanguageHeaders("Project ID");
                end;

            }
            action("Apply translations")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    TranslationLines: Record "Translation Lines";
                    Translations: Record "Translations";
                begin
                    TranslationLines.SetRange("Project ID", "Project ID");
                    if TranslationLines.FindSet() then
                        repeat
                            case TranslationNo of
                                1:
                                    addTranslation("Project ID", "Language Id", TranslationLines.source, TranslationLines.Lang1)
                                      ;
                                2:
                                    addTranslation("Project ID", "Language Id", TranslationLines.source, TranslationLines.Lang2)
                                      ;
                                3:
                                    addTranslation("Project ID", "Language Id", TranslationLines.source, TranslationLines.Lang3)
                                      ;
                                4:
                                    addTranslation("Project ID", "Language Id", TranslationLines.source, TranslationLines.Lang4)
                                      ;
                                5:
                                    addTranslation("Project ID", "Language Id", TranslationLines.source, TranslationLines.Lang5)
                                      ;
                                else
                                    Error('Wrong Translation no, Select 1 to 5');
                            end;
                            TranslationLines.Modify();
                        until TranslationLines.Next() = 0;

                    CurrPage.Update();
                    CurrPage.Control1000000008.Page.Update();
                end;
            }

            action(ExportSelectedLanguage)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    ExportXml: XMLport "ExportTranslationFiles";
                    // tempBlob: Codeunit "Temp Blob";
                    varOutStream: OutStream;
                    FileManagement: Codeunit "File Management";
                begin
                    ExportXml.setParameters(Rec);

                    ExportXml.Run();
                end;
            }

            action(DeleteTranslationLines)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    TranslationHeader: Record "Translation Header";
                    TranslationLines: Record "Translation Lines";
                begin
                    TranslationLines.SetRange("Project ID", "Project ID");
                    TranslationLines.DeleteAll();
                end;
            }

            action("Delete Translations")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    LanguageMap: Record "Translations";
                begin
                    LanguageMap.SetRange("Project Id", "Project ID");
                    LanguageMap.DeleteAll();
                end;
            }

            action(ShowMissing)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    TranslationLines: Record "Translation Lines";
                begin
                    TranslationLines.SetRange("Project ID", "Project ID");
                    case TranslationNo of
                        1:
                            TranslationLines.SetRange(Lang1, '');
                        2:
                            TranslationLines.SetRange(Lang2, '');
                        3:
                            TranslationLines.SetRange(Lang3, '');
                        4:
                            TranslationLines.SetRange(Lang4, '');
                        5:
                            TranslationLines.SetRange(Lang5, '');
                        else
                            Error('Please select Translation No');
                    end;
                    Page.Run(Page::"Translation Lines", TranslationLines);
                end;
            }
        }
    }

    local procedure addTranslation(ProjCode: code[10]; LangId: Integer; SourceCode: Text; var translationText: Text)
    var
        Translations: Record "Translations";
    begin
        if Translations.get(ProjCode, LangId, SourceCode) then
            translationText := Translations.Translation;
    end;

    local procedure addLanguageHeaders(ProjId: Code[10])
    var
        tempHeaders: Record "Translation Header" temporary;
        Translations: Record "Translations";
        tempLang: Integer;
        Headers: record "Translation Header";
    begin
        Translations.SetRange("Project Id", ProjId);

        if Translations.FindSet() then begin
            tempLang := Translations."Language Id";

            tempHeaders.Init();
            tempHeaders."Project ID" := ProjId;
            tempHeaders."Language Id" := Translations."Language Id";
            tempHeaders.Insert();

            while Translations.Next() <> 0 do
                if tempLang <> Translations."Language Id" then begin
                    tempLang := Translations."Language Id";

                    tempHeaders.Init();
                    tempHeaders."Project ID" := ProjId;
                    tempHeaders.Validate("Language Id", Translations."Language Id");
                    tempHeaders.Insert();
                end;

        end else
            exit;

        Headers.SetRange("Project ID", "Project ID");

        if Headers.FindSet() then
            Headers.DeleteAll();

        tempHeaders.FindSet();
        repeat
            Headers := tempHeaders;
            Headers.Insert();
        until tempHeaders.Next() = 0;
    end;

}