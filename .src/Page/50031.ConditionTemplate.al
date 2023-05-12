page 50031 "Condition Template Sheet"
{
    AutoSplitKey = true;
    Caption = 'Condition Template Sheet';
    //DataCaptionFields = "No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Condition Template Customer";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Condition Code"; "Condition Code")
                {
                    Visible = true;
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Seq."; "Seq.")
                {
                    Editable = true;
                    ApplicationArea = all;
                }
                field(Detail; Detail)
                {
                    Editable = true;
                    ApplicationArea = all;
                }


            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //  SetUpNewLine;
    end;
}

