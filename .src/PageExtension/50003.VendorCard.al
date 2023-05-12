pageextension 50003 "Vendor Card Ext" extends "Vendor Card"
{
    layout
    {
        addafter(Name)
        {
            field("Name TH"; "Name TH")
            {
                ApplicationArea = all;
                Importance = Promoted;
            }
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
        { field("Address 3"; "Address 3") { ApplicationArea = all; Importance = Promoted; } }
    }
}