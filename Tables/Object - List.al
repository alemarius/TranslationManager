table 69206 ObjectList
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Project Id"; Code[10])
        {
            DataClassification = CustomerContent;

        }
        field(2; "Object Type"; Option)
        {
            OptionMembers = Table,Page,Report,Codeunit,XMLPort,"TableExtension","PageExtension";
            DataClassification = CustomerContent;
        }
        field(10; "Object Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }

        field(20; Active; Boolean)
        {
            DataClassification = CustomerContent;
        }


    }

    keys
    {
        key(PK; "Project Id", "Object Type", "Object Name")
        {
            Clustered = true;
        }
    }

    var
        "Label - test": Label 'WTFTEST';

    procedure addObject(note2: Text[250]; pProjId: Code[10])
    var
        TempType: Text;
    begin
        Init();
        "Project Id" := pProjId;
        //TempType := CopyStr()

    end;

}