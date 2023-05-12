report 50033 "Inventory by Lot"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/50033.Inventory.AvalibaleByLot.rdl';
    Caption = 'Inventory By Lot';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", Location, "Item Category Code", "Default Process";
            column(PartNo; "No.") { }
            column(Description; Description) { }
            column(model; "Description 2") { }
            column(ItemCat; "Item Category Code") { }
            column(TypeP; Item."Inventory Posting Group") { }
            column(RowsItem; RowsItem) { }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = field("No.");
                column(Document_Date; "Posting Date") { }
                column(Document_No_; "Document No.") { }
                column(Document_Type; "Document Type") { }
                column(Location_Code; "Location Code") { }
                column(Lot_No_; "Lot No.") { }
                column(InvtType; InvtType) { }
                column(Quantity; Quantity) { }
                column(Remaining_Quantity; "Remaining Quantity") { }
                column(RowNo; RowNo) { }
                trigger OnAfterGetRecord()
                begin
                    RowNo += 1;
                    InvtType := 'IN';
                    if Quantity < 0 then begin
                        InvtType := 'OUT';
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SETFILTER("Posting Date", '..%1', DDate);
                    SetFilter("Remaining Quantity", '>%1', 0);
                    if Item.GetFilter(Location) <> '' then begin
                        SetFilter("Location Code", '%1', Item.GetFilter(Location));
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                RowNo := 0;
                RowsItem += 1;
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
                    field(DDate; DDate)
                    {
                        ApplicationArea = all;
                        Caption = 'As of Date';
                    }
                }
            }
        }
    }
    var
        DDate: Date;
        InvtType: Text[20];
        RowNo: Integer;
        RowsItem: Integer;
}