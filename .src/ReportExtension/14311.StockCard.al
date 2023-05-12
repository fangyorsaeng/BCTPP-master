reportextension 50003 "Stock Card Ex" extends "Stock Card"
{
    dataset
    {
        add("Item Ledger Entry")
        {
            column(Document_Type; "Document Type") { }
            column(NewInQty; NewInQty) { }
            column(NewIssueQty; NewIssueQty) { }
            column(NewBalance; NewBalance) { }
        }
        modify("Item Ledger Entry")
        {
            trigger OnAfterAfterGetRecord()
            begin
                NewInQty := 0;
                NewIssueQty := 0;

                if "Item Ledger Entry".Quantity < 0 then
                    NewIssueQty := Abs("Item Ledger Entry".Quantity)
                else
                    NewInQty := Abs("Item Ledger Entry".Quantity);

                BeginQty := BeginQty + NewInQty - NewIssueQty;

            end;

            trigger OnBeforePreDataItem()
            begin
                StartDate := "Item Ledger Entry".GetRangeMin("Posting Date");
                EndDate := "Item Ledger Entry".GetRangeMax("Posting Date");

                if StartDate <> 0D then begin
                    Itemledger2.Reset();
                    Itemledger2.SetFilter("Posting Date", '..%1', CalcDate('<-1D>', StartDate));
                    if "Item Ledger Entry".GetFilter("Location Code") <> '' then
                        Itemledger2.SetRange("Location Code", "Item Ledger Entry".GetFilter("Location Code"));
                    Itemledger2.SetRange("Item No.", "Item Ledger Entry"."Item No.");
                    if Itemledger2.Find('-') then begin
                        repeat
                            BeginQty += Itemledger2.Quantity;
                        until Itemledger2.Next = 0;
                    end;

                end;
            end;
        }
    }
    var
        NewInQty: Decimal;
        NewIssueQty: Decimal;
        NewBalance: Decimal;
        StartDate: Date;
        EndDate: Date;
        BeginQty: Decimal;
        Itemledger2: Record "Item Ledger Entry";

}