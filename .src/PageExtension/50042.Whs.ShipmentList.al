pageextension 50042 "Whs. Shipment List" extends "Warehouse Shipment List"
{
    layout
    {
        modify("No.")
        {
            Caption = 'Ship No.';
        }
        modify("Assigned User ID") { Visible = false; Caption = 'Ship by'; }
        addafter("Assigned User ID")
        {
            field("Ref. Invoice No"; "Ref. Invoice No") { ApplicationArea = all; }
            field("Ship By"; "Ship By") { ApplicationArea = all; }
            field("Create By"; "Create By") { ApplicationArea = all; }
            field("Create Date"; "Create Date") { ApplicationArea = all; }
        }
        modify("Posting Date")
        {
            Visible = true;
            Caption = 'Document Date';
        }
        moveafter("No."; "Posting Date")

    }
}