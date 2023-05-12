pageextension 50048 "Invt. Shipment Subform Ex" extends "Invt. Shipment Subform"
{
    layout
    {
        modify("Unit Amount") { Visible = false; }
        modify("Unit Cost") { Visible = false; }
        modify(Amount) { Visible = false; }
        addafter("Reason Code")
        {
            field("Location Code"; "Location Code")
            {
                ApplicationArea = all;
            }
        }
        modify("Item No.")
        {
            CaptionClass = 'Part No.';
            trigger OnAfterValidate()
            begin
                //  "Reason Code" := 'FACTORY';
            end;
        }
        modify(Description)
        {
            CaptionClass = 'Part Name';
        }
        modify(Quantity)
        {
            Style = StandardAccent;
            StyleExpr = true;
        }

    }
}