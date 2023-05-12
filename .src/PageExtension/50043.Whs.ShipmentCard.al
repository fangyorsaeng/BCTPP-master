pageextension 50043 "Whs. Shipment Card" extends "Warehouse Shipment"
{
    layout
    {
        modify("Posting Date")
        {
            Caption = 'Document Date';
        }
        modify("No.")
        {
            Caption = 'Ship No.';
        }
        moveafter("No."; "Posting Date")
        modify("Assigned User ID") { Visible = false; }
        modify("Bin Code") { Visible = false; }
        modify("Zone Code") { Visible = false; }
        addafter("Assigned User ID")
        {
            field("Ref. Invoice No"; "Ref. Invoice No") { ApplicationArea = all; }
            field("Ship By"; "Ship By")
            {
                ApplicationArea = all;
            }
        }

    }
    actions
    {
        modify("Use Filters to Get Src. Docs.")
        {
            Visible = false;
        }
        modify("Autofill Qty. to Ship")
        {
            Visible = true;
        }
        modify("Create Pick")
        {
            Visible = false;
        }
        addbefore("Autofill Qty. to Ship")
        {
            action(getLine)
            {
                Caption = 'Get Sales Line.';
                ApplicationArea = all;
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    GetPage: Page "Whs. Sales Order List";
                begin
                    Clear(GetPage);
                    GetPage.setDocNo(Rec."No.");
                    GetPage.RunModal();
                end;
            }
        }
    }
}