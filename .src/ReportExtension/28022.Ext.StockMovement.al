reportextension 50001 "Stock Movement Ext" extends "Stock Movement"
{
    dataset
    {
        add("Item Ledger Entry")
        {
            column(Lot_No_; "Lot No.") { }
            column(Remaining_Quantity; "Remaining Quantity") { }
            column(SalesInv; SalesInv) { }
            column(salesInvDate; salesInvDate) { }
            column(PONO; PONO) { }
        }
        modify("Item Ledger Entry")
        {
            trigger OnAfterAfterGetRecord()
            begin
                Clear(SalesInv);
                Clear(salesInvDate);
                Clear(PONO);
                PurReceiptLine.Reset();
                PurReceiptLine.SetRange("Document No.", "Item Ledger Entry"."Document No.");
                PurReceiptLine.SetRange("Line No.", "Item Ledger Entry"."Document Line No.");
                PurReceiptLine.SetRange("No.", "Item Ledger Entry"."Item No.");
                if PurReceiptLine.Find('-') then begin
                    SalesInv := PurReceiptLine."Invoice No";
                    salesInvDate := PurReceiptLine."Invoice Date";
                    PONO := PurReceiptLine."Order No.";
                end;
            end;
        }
    }
    var
        PONO: Code[20];
        SalesInv: Text[50];
        salesInvDate: Date;
        PurReceiptLine: Record "Purch. Rcpt. Line";
}