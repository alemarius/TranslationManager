table 69201 "SPLN Translation Header"
{

    fields
    {
        field(1; "Project Id"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Language Id"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Language: Record Language;
            begin
                Language.SetRange("Windows Language ID", "Language Id");
                Language.FindFirst();
                LangCode := Language.Code;
            end;

        }

        field(4; LangCode; Code[10])
        {
            TableRelation = Language.Code;

            trigger OnValidate()
            var
                Language: Record Language;
            begin
                Language.get(LangCode);

                "Language Id" := Language."Windows Language ID";
            end;
        }
        field(5; TranslationNo; Integer)
        {
            Caption = 'TranslationNo';
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 5;
        }

        field(20; LanguageDataType; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(30; LanguageCases; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("SPLN Translations" where(
                        "Project Id" = field("Project ID"),
                        "Language Id" = field("Language Id")
                        ));
        }
    }

    keys
    {
        key(Key1; "Project ID", "Language Id")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Translations: Record "SPLN Translations";
    begin
        Translations.SetRange("Project Id", "Project ID");
        Translations.SetRange("Language Id", "Language Id");
        if Translations.FindSet() then
            Translations.DeleteAll();
    end;
}

