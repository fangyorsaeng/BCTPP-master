pageextension 50019 "Purchase Quote Subform Ex" extends "Purchase Quote Subform"
{
    layout
    {

        modify("No.") { CaptionClass = 'Part No.'; }
        modify(Description) { CaptionClass = 'Part Name'; }
        modify("Item Reference No.") { Visible = false; }
        modify("Location Code") { Visible = false; }

        // moveafter("Over-Receipt Quantity"; "Bin Code")
        // moveafter("Bin Code"; "Reserved Quantity")
        modify("Tax Area Code") { Visible = false; }
        modify("Tax Group Code") { Visible = false; }
        modify("Tax Liable") { Visible = false; }
        modify("Qty. to Assign") { Visible = false; }
        modify("Qty. Assigned") { Visible = false; }
        addafter("Unit of Measure Code")
        {

            field("Supplier Name"; "Supplier Name")
            {
                ApplicationArea = all;
                Importance = Promoted;
            }
            field("Ref Quote No."; "Ref Quote No.")
            {
                ApplicationArea = all;
                Importance = Promoted;
            }

        }
        modify("Line Discount %") { Visible = false; }
        modify("Expected Receipt Date") { Visible = true; }
        moveafter("Unit of Measure Code"; "Expected Receipt Date")
        addafter("Line Amount")
        {
            field(Maker; Maker)
            {
                ApplicationArea = all;
            }
            field(LeadTime; LeadTime)
            {
                ApplicationArea = all;
            }
            field("PO Status"; "PO Status")
            {
                ApplicationArea = all;
            }
            field("Kanban No."; "Kanban No.")
            {
                ApplicationArea = all;
            }
        }
        modify("Description 2")
        {
            Visible = true;
            Caption = 'Model';
        }
        moveafter("Ref Quote No."; "Expected Receipt Date")
        moveafter("Unit of Measure Code"; "Direct Unit Cost")

    }
}