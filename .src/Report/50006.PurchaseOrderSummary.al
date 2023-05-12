report 50006 "Purchase Order Summary"
{
    ProcessingOnly = true;
    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code", BOI, "Location Filter";
            trigger OnAfterGetRecord()
            begin
                Total1 := 0;
                Total2 := 0;
                Row1 += 1;

                TempPO.Init();
                TempPO.RowNo := Row1;
                TempPO."Part No." := Item."No.";
                TempPO."Part Name" := Item.Description;
                TempPO."Item Cat." := Item."Item Category Code";
                TempPO.Year := format(SYear);
                TempPO.SUserID := UserId;
                TempPO.SType := 'PUR';
                /////Set Month////
                TempPO.JAN := getData(1, "No.", "Location Filter", SYear);
                TempPO.FEB := getData(2, "No.", "Location Filter", SYear);
                TempPO.MAR := getData(3, "No.", "Location Filter", SYear);
                TempPO.APR := getData(4, "No.", "Location Filter", SYear);
                TempPO.MAY := getData(5, "No.", "Location Filter", SYear);
                TempPO.JUN := getData(6, "No.", "Location Filter", SYear);
                TempPO.JUL := getData(7, "No.", "Location Filter", SYear);
                TempPO.AUG := getData(8, "No.", "Location Filter", SYear);
                TempPO.SEP := getData(9, "No.", "Location Filter", SYear);
                TempPO.OCT := getData(10, "No.", "Location Filter", SYear);
                TempPO.NOV := getData(11, "No.", "Location Filter", SYear);
                TempPO.DEC := getData(12, "No.", "Location Filter", SYear);
                Total1 := TempPO.JAN + TempPO.FEB + TempPO.MAR + TempPO.APR + TempPO.MAY + TempPO.JUN;
                Total2 := TempPO.JUL + TempPO.AUG + TempPO.SEP + TempPO.OCT + TempPO.NOV + TempPO.DEC;
                TempPO.Total := Total1 + Total2;
                TempPO.Insert();
                ////////End /////////
                if (SetCompare = SetCompare::Year) and (SYear2 <> 0) then begin
                    Row2 += 1;
                    TempPO.Init();
                    TempPO.RowNo := Row2;
                    TempPO."Part No." := Item."No.";
                    TempPO."Part Name" := Item.Description;
                    TempPO."Item Cat." := Item."Item Category Code";
                    TempPO.Year := format(SYear2);
                    TempPO.SUserID := UserId;
                    TempPO.SType := 'PUR';
                    /////Set Month////
                    TempPO.JAN := getData(1, "No.", "Location Filter", SYear2);
                    TempPO.FEB := getData(2, "No.", "Location Filter", SYear2);
                    TempPO.MAR := getData(3, "No.", "Location Filter", SYear2);
                    TempPO.APR := getData(4, "No.", "Location Filter", SYear2);
                    TempPO.MAY := getData(5, "No.", "Location Filter", SYear2);
                    TempPO.JUN := getData(6, "No.", "Location Filter", SYear2);
                    TempPO.JUL := getData(7, "No.", "Location Filter", SYear2);
                    TempPO.AUG := getData(8, "No.", "Location Filter", SYear2);
                    TempPO.SEP := getData(9, "No.", "Location Filter", SYear2);
                    TempPO.OCT := getData(10, "No.", "Location Filter", SYear2);
                    TempPO.NOV := getData(11, "No.", "Location Filter", SYear2);
                    TempPO.DEC := getData(12, "No.", "Location Filter", SYear2);
                    Total1 := TempPO.JAN + TempPO.FEB + TempPO.MAR + TempPO.APR + TempPO.MAY + TempPO.JUN;
                    Total2 := TempPO.JUL + TempPO.AUG + TempPO.SEP + TempPO.OCT + TempPO.NOV + TempPO.DEC;
                    TempPO.Total := Total1 + Total2;
                    TempPO.Insert();
                end;

            end;

            trigger OnPreDataItem()
            begin
                Row1 := 0;
                Row2 := 0;
                TempPO.Reset();
                TempPO.SetRange(SUserID, UserId);
                if TempPO.Find('-') then
                    TempPO.DeleteAll();
                SetRange(Blocked, false);
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    field(SetCompare; SetCompare)
                    {
                        Caption = 'Select Compare';
                        ApplicationArea = all;
                    }
                    field(Year; Year)
                    {
                        Caption = 'Select Year';
                        ApplicationArea = all;
                    }
                    field(SetValue; SetValue)
                    {
                        Caption = 'Select Data';
                        ApplicationArea = all;
                    }

                }
                group(Compare)
                {
                    field(Year2; Year2)
                    {
                        ApplicationArea = all;
                        Caption = 'Compare Year';
                    }
                }
            }
        }
        actions
        {

        }
    }
    trigger OnPreReport()
    begin
        if Format(Year) = '' then
            Error('Please.. Select Year!!');
        SYear := Date2DMY(Today, 3);
        SYear2 := 0;
        Evaluate(SYear, Format(Year));
        Evaluate(SYear2, Format(Year2));


    end;

    trigger OnInitReport()
    begin
        SetValue := SetValue::Value;
        SetCompare := SetCompare::Item;
    end;

    trigger OnPostReport()
    var
        sRow: Integer;
    begin
        TempPO.Reset();
        TempPO.SetRange(SUserID, UserId);
        TempPO.SetRange(Total, 0);
        if TempPO.Find('-') then
            TempPO.DeleteAll();
        if SetCompare = SetCompare::Year then begin
            SetTotal(9997, format(SYear), 'Year ' + Format(SYear));
            SetTotal(9998, format(SYear2), 'Year ' + Format(SYear2));
            //Delete Row//
            TempPO.Reset();
            TempPO.SetRange(SUserID, UserId);
            TempPO.SetFilter("Part Name", '<>%1', '');
            if TempPO.Find('-') then begin
                TempPO.DeleteAll();
                // Message('delete completed.');
            end;

        end;

        sRow := 0;
        // TempPO.Reset();
        // TempPO.SetRange(SUserID, UserId);
        // if TempPO.FindLast() then
        //     sRow := TempPO.RowNo;
        // sRow += 1;
        SetTotal(9999, format(SYear), 'TOTAL');

    end;

    var
        Year: Enum "Select Year";
        Year2: Enum "Select Year";
        SYear: Integer;
        SYear2: Integer;
        TempPO: Record "Temp Report";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Row1: Integer;
        Row2: Integer;
        SetValue: Option Value,Quantity;
        SetCompare: Option Item,Year;
        Total1: Decimal;
        Total2: Decimal;

    procedure getData(MM: Integer; ItemNo: Code[50]; LocaT: Code[10]; YY: Integer): Decimal;
    var
        RT: Decimal;
        ValueS: Decimal;
        Qty: Decimal;
        PDate1: Date;
        PDate2: Date;
        PurL: Record "Purchase Line";
    begin
        RT := 0;
        PDate1 := DMY2Date(1, MM, YY);
        PDate2 := CalcDate('<CM>', PDate1);
        /*
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        if LocaT <> '' then
            ItemLedgerEntry.SetRange("Location Code", LocaT);
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
        ItemLedgerEntry.SetFilter("Posting Date", '%1..%2', PDate1, PDate2);
        if ItemLedgerEntry.Find('-') then begin
            repeat
                if SetValue = SetValue::Value then begin
                    ItemLedgerEntry.CalcFields("Cost Amount (Expected)");
                    RT += ItemLedgerEntry."Cost Amount (Expected)";
                end
                else begin
                    RT += ItemLedgerEntry.Quantity;
                end;
            until ItemLedgerEntry.Next = 0;
        end;
        */
        PurL.Reset();
        PurL.CalcFields("Document Date");
        PurL.SetRange("No.", ItemNo);
        PurL.SetRange("Document Type", PurL."Document Type"::Order);
        PurL.SetFilter("PO Status", '%1|%2', PurL."PO Status"::Open, PurL."PO Status"::Discon);
        if LocaT <> '' then
            PurL.SetFilter("Location Code", LocaT);
        PurL.SetFilter("Document Date", '%1..%2', PDate1, PDate2);
        if PurL.find('-') then begin
            repeat
                if SetValue = SetValue::Value then begin
                    //ItemLedgerEntry.CalcFields("Cost Amount (Expected)");
                    RT += PurL."Line Amount";
                end
                else begin
                    RT += PurL.Quantity;
                end;
            until PurL.Next = 0;
        end;

        exit(RT);
    end;

    procedure SetTotal(Row2: Integer; YY1: Code[10]; SetData: Code[30])
    var
        YY: Integer;
        DText: Code[10];
    begin
        Total1 := 0;
        Total2 := 0;
        if Evaluate(YY, format(YY1)) then;
        if Row2 = 9999 then
            DText := ''
        else
            DText := Format(YY1);

        TempPO.Init();
        TempPO.RowNo := Row2;
        TempPO."Part No." := setData;
        TempPO."Part Name" := '';
        TempPO."Item Cat." := '';
        TempPO.Year := DText;
        TempPO.SUserID := UserId;
        TempPO.SType := 'PUR';
        ///Set Month//
        TempPO.JAN := getTotal(1, YY);
        TempPO.FEB := getTotal(2, YY);
        TempPO.MAR := getTotal(3, YY);
        TempPO.APR := getTotal(4, YY);
        TempPO.MAY := getTotal(5, YY);
        TempPO.JUN := getTotal(6, YY);
        TempPO.JUL := getTotal(7, YY);
        TempPO.AUG := getTotal(8, YY);
        TempPO.SEP := getTotal(9, YY);
        TempPO.OCT := getTotal(10, YY);
        TempPO.NOV := getTotal(11, YY);
        TempPO.DEC := getTotal(12, YY);
        Total1 := TempPO.JAN + TempPO.FEB + TempPO.MAR + TempPO.APR + TempPO.MAY + TempPO.JUN;
        Total2 := TempPO.JUL + TempPO.AUG + TempPO.SEP + TempPO.OCT + TempPO.NOV + TempPO.DEC;
        TempPO.Total := Total1 + Total2;
        ////End ///
        TempPO.Insert();
    end;

    procedure getTotal(MM: Integer; YY: Integer): Decimal
    var
        RT: Decimal;
        TM2: Record "Temp Report";
    begin
        RT := 0;
        TM2.Reset();
        TM2.SetRange(SUserID, UserId);
        if YY <> 9999 then
            TM2.SetRange(Year, format(YY));
        if TM2.Find('-') then begin
            repeat
                if MM = 1 then
                    RT += TM2.JAN;
                if MM = 2 then
                    RT += TM2.FEB;
                if MM = 3 then
                    RT += TM2.MAR;
                if MM = 4 then
                    RT += TM2.APR;
                if MM = 5 then
                    RT += TM2.MAY;
                if MM = 6 then
                    RT += TM2.JUN;
                if MM = 7 then
                    RT += TM2.JUL;
                if MM = 8 then
                    RT += TM2.AUG;
                if MM = 9 then
                    RT += TM2.SEP;
                if MM = 10 then
                    RT += TM2.OCT;
                if MM = 11 then
                    RT += TM2.NOV;
                if MM = 12 then
                    RT += TM2.DEC;
            until TM2.Next = 0;
        end;
        exit(RT);
    end;
}