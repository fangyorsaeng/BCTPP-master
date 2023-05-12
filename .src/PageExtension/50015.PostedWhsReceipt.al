pageextension 50015 "Posted Whse. Receipt Ex" extends "Posted Whse. Receipt"
{
    layout
    {
        addafter("Vendor Shipment No.")
        {
            field("Invoice No"; "Invoice No") { ApplicationArea = all; }
            field("Invoice Date"; "Invoice Date") { ApplicationArea = all; }
            field("Create By"; "Create By") { ApplicationArea = all; }
            field("Create Date"; "Create Date") { ApplicationArea = all; }
        }
        modify("Assigned User ID") { Visible = false; }
        addafter("Assigned User ID")
        {
            field("Receipt By"; "Receipt By") { ApplicationArea = all; }

        }
    }
}