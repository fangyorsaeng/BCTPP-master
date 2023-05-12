pageextension 50009 "Purchase Line Sub. Ex" extends "Purchase Order Subform"
{
    layout
    {

        modify("No.") { CaptionClass = 'Part No.'; }
        modify(Description) { CaptionClass = 'Part Name'; }
        modify("Description 2") { CaptionClass = 'Model'; Visible = true; }
        modify("Item Reference No.") { Visible = false; }
        moveafter("Over-Receipt Quantity"; "Bin Code")
        moveafter("Bin Code"; "Reserved Quantity")
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Tax Liable") { Visible = false; }
        modify("Qty. to Assign") { Visible = false; }
        modify("Qty. Assigned") { Visible = false; }
        modify("Qty. to Invoice") { Visible = false; }
        modify("Quantity Invoiced") { Visible = false; }
        modify("Promised Receipt Date") { Visible = false; }
        modify("Bin Code") { Visible = false; }
        addafter("Quantity Received")
        {
            field("Outstanding Quantity"; "Outstanding Quantity")
            {
                ApplicationArea = all;
                Style = Attention;
                StyleExpr = true;
            }
        }
        addafter("Over-Receipt Code")
        {
            field("Ref Quote No."; "Ref Quote No.")
            {
                ApplicationArea = all;
            }
            field("Quote No."; "Quote No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Quote Line"; "Quote Line")
            {
                ApplicationArea = all;
            }
            field("PO Status"; "PO Status")
            {
                ApplicationArea = all;

            }

        }
        moveafter("PO Status"; "VAT Prod. Posting Group")
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        addafter("VAT Prod. Posting Group")
        {
            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
        modify("Planning Flexibility") { ApplicationArea = all; Visible = true; }
        moveafter("PO Status"; "Planning Flexibility")


    }
}