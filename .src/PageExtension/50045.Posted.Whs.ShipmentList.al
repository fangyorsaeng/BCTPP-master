pageextension 50045 "Posted Whs. Shipment List" extends "Posted Whse. Shipment List"
{
    layout
    {
        modify("Posting Date")
        {
            Visible = true;
            Caption = 'Document Date';
        }
        moveafter("No."; "Posting Date")
        modify("No.")
        {
            Caption = 'Ship No.';
        }
        modify("Assigned User ID") { Visible = false; }
        addafter("Assigned User ID")
        {
            field("Ref. Invoice No"; "Ref. Invoice No")
            {
                ApplicationArea = all;
            }
            field("Ship By"; "Ship By")
            {
                ApplicationArea = all;
            }
            field("Create By"; "Create By")
            {
                ApplicationArea = all;
            }
            field("Create Date"; "Create Date")
            {
                ApplicationArea = all;
            }

        }
    }
}