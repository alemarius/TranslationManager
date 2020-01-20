page 69205 "Translation Lines"
{
    PageType = List;
    SourceTable = "Translation Lines";
    Caption = 'Translation Lines';
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
                    ApplicationArea = All;
                }
                field(Lang2; Lang2)
                {
                    ApplicationArea = All;
                }
                field(Lang3; Lang3)
                {
                    ApplicationArea = All;
                }
                field(Lang4; Lang4)
                {
                    ApplicationArea = All;
                }
                field(Lang5; Lang5)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

