pageextension 50006 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        modify("Search Name")
        {
            Importance = Promoted;
            Visible = true;
        }
        moveafter(Name; "Search Name")
        addafter("Search Name")
        {
            field("Supplier Code"; "Supplier Code")
            {
                ApplicationArea = all;
                Importance = Promoted;
            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                ApplicationArea = all;
                Importance = Promoted;
                Caption = 'Employee Res.';
                ShowCaption = true;
            }
        }
        addafter("Address 2")
        {
            field("Address 3"; "Address 3")
            {
                ApplicationArea = all;
                Importance = Promoted;
            }
            field("Thai Address"; "Thai Address")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
        }
        modify("Name 2")
        {
            Visible = true;
            Caption = 'Thai Name';
        }
        modify("Post Code")
        {
            Caption = 'Short Name';
        }


    }
    actions
    {
        addafter(NewReminder)
        {
            action(Condition)
            {
                ApplicationArea = all;
                Caption = 'Canditions';
                Image = ConditionalBreakpoint;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Condition Template Sheet";
                RunPageLink = "Condition Code" = field("No."), "Condition Type" = filter(Quote);
                ToolTip = 'View or add Condition for the record.';
            }
        }
    }
}