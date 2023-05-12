pageextension 50013 "Whse. Receipt SubForm Ex" extends "Whse. Receipt Subform"
{
    layout
    {
        modify("Bin Code")
        {
            Visible = false;
        }
        modify("Due Date") { Visible = false; }
        modify("Qty. to Cross-Dock") { Visible = false; }
        modify("Qty. to Receive")
        {
            Style = Attention;
            StyleExpr = true;
        }
        modify("Qty. Received")
        {
            Style = Favorable;
            StyleExpr = true;
        }
        moveafter(Quantity; "Qty. Outstanding")
        addafter("Over-Receipt Code")
        {
            field(Grade; Grade)
            { ApplicationArea = all; }
            field(Size; Size)
            { ApplicationArea = all; }
            field(Heat; Heat)
            { ApplicationArea = all; }
            field(Inspection; Inspection) { ApplicationArea = all; }
        }
        modify("Item No.") { CaptionClass = 'Part No.'; }
        modify(Description) { CaptionClass = 'Part Name'; }
    }
}