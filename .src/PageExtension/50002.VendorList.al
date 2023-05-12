pageextension 50002 "Vendor List Ext" extends "Vendor List"
{
    layout
    {

        modify("Location Code")
        {
            Visible = false;
        }
        modify("Responsibility Center") { Visible = false; }
        addafter("Location Code")
        {
            field("Supplier Code"; "Supplier Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                ApplicationArea = all;
                Importance = Promoted;
                // Caption = 'Employee Res.';
                //  ShowCaption = true;
            }
        }
        moveafter(Name; "Search Name")
        addafter(Contact)
        {
            field("E-Mail"; "E-Mail") { ApplicationArea = all; }
            field(Address; Address) { ApplicationArea = all; }
            field("Address 2"; "Address 2") { ApplicationArea = all; }
            field("Address 3"; "Address 3") { ApplicationArea = all; }

        }
        addafter("Search Name")
        {
            field("Name TH"; "Name TH")
            {
                ApplicationArea = all;
            }
        }


    }
}