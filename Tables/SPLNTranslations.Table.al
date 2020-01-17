table 69204 "SPLN Translations"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Project Id"; Code[10])
        {
            Caption = 'ProjectCode';
            DataClassification = ToBeClassified;
        }
        field(2; "Language Id"; Integer)
        {
        }
        field(3; Source; Text[400])
        {
        }
        field(4; Translation; Text[400])
        {
        }
    }

    keys
    {
        key(PK; "Project Id", "Language Id", Source)
        {
            Clustered = true;
        }
    }

}