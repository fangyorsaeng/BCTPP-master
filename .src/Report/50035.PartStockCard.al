report 50035 "Material Stock Card"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/50035.MaterialStockCard.rdl';
    Caption = 'Material Stock Card';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code", "Group PD", Location;

            column(PartNo; "No.") { }
            column(PartName; Item.Description) { }
            column(StartDate; StartDate) { }
            column(OpeningBalance; OpeningBalance) { }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = field("No.");
                DataItemTableView = sorting("Item No.", "Location Code", "Posting Date");

                column(RowNo; RowNo) { }
                column(Location_Code; "Location Code") { }
                column(Posting_Date; "Posting Date") { }
                column(Document_No_; "Document No.") { }
                column(Document_Type; "Document Type") { }
                column(Remark; RemarkX) { }
                column(Lot_No_; "Lot No.") { }
                column(ItemType; ItemType) { }
                column(InQty; InQty) { }
                column(OutQty; OutQty) { }
                column(BalanceQ; BalanceQ) { }
                trigger OnAfterGetRecord()
                begin
                    RowNo += 1;
                    if (RowNo = 1) then begin
                        BalanceQ := QtyOfStart;
                    end;
                    InQty := 0;
                    OutQty := 0;
                    if (Quantity < 0) then
                        OutQty := Abs(Quantity);
                    if (Quantity > 0) then
                        InQty := Abs(Quantity);
                    if "External Document No." <> '' then
                        RemarkX := "External Document No."
                    else
                        RemarkX := "Document No.";

                    ItemType := "Return Reason Code";

                    BalanceQ := BalanceQ + "Item Ledger Entry".Quantity;

                end;

                trigger OnPreDataItem()
                begin

                    if Item.GetFilter("Location") <> '' then
                        SetRange("Location Code", Item.GetFilter(Location));
                    SetFilter("Posting Date", '%1..', StartDate);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                OpeningBalance := 0;
                QtyOfStart := 0;
                ItemLedgerE.Reset();

                ItemLedgerE.SetRange("Location Code", Item.GetFilter(Location));
                ItemLedgerE.SetFilter("Posting Date", '..%1', CalcDate('<-1D>', StartDate));
                ItemLedgerE.SetRange("Item No.", Item."No.");
                if ItemLedgerE.Find('-') then begin
                    repeat
                        QtyOfStart := QtyOfStart + ItemLedgerE.Quantity;
                    until ItemLedgerE.Next = 0;
                end;
                OpeningBalance := QtyOfStart;
            end;

            trigger OnPreDataItem()
            begin
                if (StartDate = 0D) then
                    Error('Please Start Date.');
                if Item.GetFilter("No.") = '' then
                    Error('Please Select Part No.');
                if Item.GetFilter("Location") = '' then begin
                    Error('Please Select Location');
                end;
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = all;
                        Caption = 'Start Date';
                    }
                }
            }
        }
    }
    var
        StartDate: Date;
        InQty: Decimal;
        OutQty: Decimal;
        BalanceQ: Decimal;
        RowNo: Integer;
        RemarkX: Text[100];
        ItemType: Text[20];
        QtyOfStart: Decimal;
        ItemLedgerE: Record "Item Ledger Entry";
        OpeningBalance: Decimal;
}