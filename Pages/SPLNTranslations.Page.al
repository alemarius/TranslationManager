page 69206 "SPLN Translations"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "SPLN Translations";

    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                field(ProjectCode; "Project Id")
                {
                    ApplicationArea = All;

                }
                field(LanguageId; "Language Id")
                {
                    ApplicationArea = All;

                }
                field(Source; Source)
                {
                    ApplicationArea = All;

                }
                field(Translation; Translation)
                {
                    ApplicationArea = All;

                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}