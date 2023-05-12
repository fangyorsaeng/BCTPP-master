pageextension 50011 "Item Ledger Entry Ex" extends "Item Ledger Entries"
{
    layout
    {
        movebefore("Posting Date"; "Entry No.")
        moveafter("Location Code"; "Lot No.")
        modify("Lot No.") { Visible = true; Importance = Promoted; }
        moveafter("Shortcut Dimension 3 Code"; "Global Dimension 1 Code")
        moveafter("Global Dimension 1 Code"; "Global Dimension 2 Code")
        moveafter(Quantity; "Remaining Quantity")
        moveafter("Order Type"; Description)
        modify("Cost Amount (Expected)") { Visible = true; }
        moveafter("Cost Amount (Actual)"; "Cost Amount (Expected)")
        modify("Cost Amount (Actual)") { Visible = true; }
        modify("Cost Amount (Non-Invtbl.)") { Visible = false; }
        modify("Sales Amount (Actual)") { Visible = false; }
        modify("Item No.") { CaptionClass = 'Part No.'; }
        modify(Description) { CaptionClass = 'Part Name'; Visible = true; }
        addafter("Shortcut Dimension 8 Code")
        {
            field("Create By"; "Create By")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Create Date"; "Create Date") { ApplicationArea = all; Editable = false; }
            field(Undo; Undo) { ApplicationArea = all; }
            field("Undo Document No."; "Undo Document No.") { ApplicationArea = all; }
        }
        modify("Return Reason Code")
        {
            Caption = 'Reson Code Type';
            Visible = true;

        }
        moveafter("Create Date"; "Return Reason Code")
        modify("Order No.") { Visible = true; }
        modify("Order Line No.") { Visible = true; }
        addafter(Description)
        {
            field("External Document No."; "External Document No.")
            {
                ApplicationArea = all;
            }
            field(Customer; Customer) { ApplicationArea = all; }
        }
    }
    actions
    {
        addafter("Order &Tracking")
        {
            action(undoShipment)
            {
                Caption = 'Undo Shipment';
                Image = Undo;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    if (REc."Document Type" = Rec."Document Type"::"Inventory Shipment") then begin
                        if Confirm('Do you want Undo this Document ' + Rec."Document No." + ' ?') then begin
                            utility.UndoInvtShipmentonItemLedger(Rec);
                            Message('Completed');
                        end;
                    end
                    else begin
                        Error('Document Type is Inventory Shipment only!');
                    end;
                end;

            }
        }
    }
    var
        utility: Codeunit Utility;
}