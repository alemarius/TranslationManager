page 69200 "Translation Lines SP"
{
    PageType = ListPart;
    SourceTable = "Translation Lines";
    AdditionalSearchTerms = 'MAL';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Project ID"; "Project ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(id; id)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("al-object-target"; "al-object-target")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(note2; note2)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(source; source)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Lang1; Lang1)
                {
                    Caption = 'Translation 1';
                    ApplicationArea = All;
                }
                field(Lang2; Lang2)
                {
                    Caption = 'Translation 2';
                    ApplicationArea = All;
                }
                field(Lang3; Lang3)
                {
                    Caption = 'Translation 3';
                    ApplicationArea = All;
                }
                field(Lang4; Lang4)
                {
                    Caption = 'Translation 4';
                    ApplicationArea = All;
                }
                field(Lang5; Lang5)
                {
                    Caption = 'Translation 5';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

