page 50040 "Posted Invt. Shipment Line"
{
    //CardPageID = "Invt. Shipment";
    Editable = false;
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableView = sorting("Document No.", "Document Type", "Document Line No.")
                      order(descending)
                      where("Entry Type" = filter(3), "Document Type" = filter(20));
    UsageCategory = Lists;
    ApplicationArea = All;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Entry No."; "Entry No.") { ApplicationArea = all; }
                field("Posting Date"; "Posting Date") { ApplicationArea = all; Caption = 'Shipment Date'; }
                field("Document No."; "Document No.") { ApplicationArea = all; }
                field("Item No."; "Item No.") { ApplicationArea = all; }
                field(Description; Description) { ApplicationArea = all; }
                field(Quantity; Quantity) { ApplicationArea = all; }
                field("Lot No."; "Lot No.") { ApplicationArea = all; }
                field("Unit of Measure Code"; "Unit of Measure Code") { ApplicationArea = all; }
                field("Return Reason Code"; "Return Reason Code") { ApplicationArea = all; CaptionClass = 'Shipment Type'; }
                field("Location Code"; "Location Code") { ApplicationArea = all; }
                field("Item Category Code"; "Item Category Code") { ApplicationArea = all; }
                field("Create By"; "Create By") { ApplicationArea = all; }
                field("Create Date"; "Create Date") { ApplicationArea = all; }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = all; }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = all; }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = all; }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = all; }

            }
        }
    }
    var
        utility: Codeunit Utility;
}