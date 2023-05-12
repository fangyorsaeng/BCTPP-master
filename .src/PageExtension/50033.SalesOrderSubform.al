pageextension 50033 "Sales Order Sub Ex" extends "Sales Order Subform"
{
    layout
    {
        modify("No.")
        {
            CaptionClass = 'Part No.';

        }
        modify(Description) { CaptionClass = 'Part Name'; }
        modify("Description 2") { CaptionClass = 'Model'; Visible = true; }
        modify("Item Reference No.") { Visible = false; }
        modify("Qty. to Assemble to Order") { Visible = false; }
        modify("Reserved Quantity") { Visible = false; }
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Qty. to Invoice") { Visible = false; }
        modify("Quantity Invoiced") { Visible = false; }
        modify("Qty. Assigned") { Visible = false; }
        modify("Qty. to Assign") { Visible = false; }
        modify("Qty. to Ship") { Visible = false; }
        //modify("Location Code") { Visible = false; }
        modify("Line Discount %") { Visible = false; }
        modify("Planned Shipment Date") { Visible = false; }
        modify("Shipment Date") { Visible = true; }
        moveafter("Unit of Measure Code"; "Planned Delivery Date")
        moveafter("Line Amount"; "Location Code")
        modify("Shortcut Dimension 1 Code") { Visible = false; }
        modify("Shortcut Dimension 2 Code") { Visible = false; }


        modify(Quantity)
        {
            Style = StrongAccent;
            StyleExpr = true;
        }
        modify("Quantity Shipped")
        {
            Style = Unfavorable;
            StyleExpr = true;
        }

        modify("Unit Price")
        {
            ShowMandatory = false;
            CaptionClass = 'Unit Price';
        }
        modify("Line Amount")
        {
            ShowMandatory = false;
            Editable = false;
            CaptionClass = 'Amount';
        }
        modify("Planned Delivery Date")
        {
            Style = Attention;
            StyleExpr = true;
            trigger OnAfterValidate()
            begin
                if "Shipment Date" <> "Planned Delivery Date" then begin
                    "Shipment Date" := "Planned Delivery Date";
                    "Planned Shipment Date" := "Planned Delivery Date";
                end;

            end;
        }
        addafter("Shipment Date")
        {
            field("Outstanding Quantity"; "Outstanding Quantity")
            {
                ApplicationArea = all;
                Style = Favorable;
                StyleExpr = true;
            }
            field("Invoice No."; "Invoice No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }



    }
    actions
    {

    }
}