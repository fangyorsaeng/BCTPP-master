pageextension 50005 "Customer List Ext" extends "Customer List"
{
    layout
    {
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Search Name") { Visible = true; }
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
        modify("Name 2") { Visible = true; Caption = 'Thai Name'; }
        moveafter("No."; "Search Name")
        moveafter(Name; "Name 2")
        addafter(Contact)
        {
            field("E-Mail"; "E-Mail") { ApplicationArea = all; }
            field(Address; Address) { ApplicationArea = all; }
            field("Address 2"; "Address 2") { ApplicationArea = all; }
            //   field("Address 3"; "Address 3") { ApplicationArea = all; }
        }
    }
}