pageextension 50022 "Posted Purch. Recipt Line Ex" extends "Posted Purchase Receipt Lines"
{

    Editable = true;
    layout
    {

        addbefore("Document No.")
        {
            field("Invoice No"; "Invoice No") { ApplicationArea = all; Editable = true; }
            field("Invoice Date"; "Invoice Date") { ApplicationArea = all; Editable = true; }
            field("Ref. Whse No."; "Ref. Whse No.") { ApplicationArea = all; Editable = false; }
            field(Grade; Grade) { ApplicationArea = all; Editable = false; }
            field(Size; Size) { ApplicationArea = all; Editable = false; }
            field(Heat; Heat) { ApplicationArea = all; Editable = false; }
            field(Inspection; Inspection) { ApplicationArea = all; Editable = false; }
            field("Create By"; "Create By") { ApplicationArea = all; Editable = false; }
            field("Create Date"; "Create Date") { ApplicationArea = all; Editable = false; }
        }
        moveafter("Invoice Date"; "Document No.")
        modify("Document No.") { Editable = false; }
        modify("No.") { Editable = false; CaptionClass = 'Part No.'; }
        modify(Description) { CaptionClass = 'Part Name'; }
        modify("Description 2") { CaptionClass = 'Model'; }
        modify(Quantity) { Editable = false; }
        modify("Unit of Measure Code") { Editable = false; }
        modify("Buy-from Vendor No.") { Editable = false; }
        modify("Location Code") { Editable = false; }
    }
    trigger OnDeleteRecord(): Boolean
    begin
        Error('Can not Delete Rec.');
    end;
}