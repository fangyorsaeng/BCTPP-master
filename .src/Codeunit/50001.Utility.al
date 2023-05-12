codeunit 50000 "Utility"
{
    Permissions = tabledata "Item Ledger Entry" = ridm,
    tabledata "Sales Line" = ridm,
    tabledata "Sales Header" = ridm,
    tabledata "Invt. Document Header" = ridm,
    tabledata "Invt. Receipt Line" = ridm,
    tabledata "Material Delivery Header" = ridm,
    tabledata "Transfer Production Header" = ridm,
    tabledata "Assembly Header" = ridm,
    tabledata "Assembly Line" = ridm,
    tabledata "Value Entry" = ridm,
    tabledata "Item Application Entry" = ridm;

    trigger OnRun()
    begin

    end;

    var
        WhseRC: Codeunit "Whse.-Post Receipt (Yes/No)";
        OnesText: array[20] of Text[30];//	30 | Dim:20
        TensText: array[10] of Text[30];//	30 | Dim:10
        ThousText: array[5] of Text[30];//	30 | Dim:5

    procedure UserFullName(UIDS: Code[250]): Text[50];
    var
        UserS: Record User;
    begin
        UserS.Reset();
        UserS.SetRange("User Name", UIDS);
        if UserS.Find('-') then
            exit(UserS."Full Name")
        else
            exit('');

    end;

    procedure getNameSalesPeson(UserS: Code[250]): Text[50];
    var
        SalesPerS: Record "Salesperson/Purchaser";
    begin
        SalesPerS.Reset();
        SalesPerS.SetRange(Code, UserS);
        if SalesPerS.Find('-') then
            exit(SalesPerS.Name);
        exit(UserS);

    end;



    procedure CheckUseLogReceipt(WarehouseReceiptLine: Record "Warehouse Receipt Line"): Boolean
    var
        Cok: Boolean;
        ItemS: Record Item;
        CK: Integer;
        ReservEntry: Record "Reservation Entry";
        SumQ: Decimal;
        Text000: Label 'Do you want to post the receipt?';
    begin
        Cok := true;

        if not Confirm(Text000, false) then
            exit;
        with WarehouseReceiptLine do begin
            repeat
                SumQ := 0;
                CK := 0;
                ItemS.Reset();
                ItemS.SetRange("No.", WarehouseReceiptLine."Item No.");
                ItemS.SetFilter("Item Tracking Code", '<>%1', '');

                if ItemS.Find('-') then begin
                    ReservEntry.Reset();
                    ReservEntry.SetRange("Item No.", WarehouseReceiptLine."Item No.");
                    ReservEntry.SetFilter("Source Type", '%1', 39);
                    ReservEntry.SetFilter("Source Subtype", '%1', 1);
                    ReservEntry.SetRange("Source ID", WarehouseReceiptLine."Source No.");
                    ReservEntry.SetRange("Source Ref. No.", WarehouseReceiptLine."Source Line No.");
                    ReservEntry.SetRange(Positive, true);
                    if ReservEntry.Find('-') then begin
                        repeat
                            SumQ += ReservEntry."Quantity (Base)";
                        until ReservEntry.Next = 0;
                    end;
                    if (SumQ <> WarehouseReceiptLine."Qty. to Receive") then begin
                        CK += 1;
                    end;
                end;
                if CK > 0 then
                    Cok := false;
            until WarehouseReceiptLine.Next = 0;
        end;
        if NOT Cok then
            Error('Lot No. Not match Quantity!');
        exit(Cok);
    end;

    procedure CalculatePurchaeReport()
    var
        TempP: Record "Temp Report";
        ReportCal: Report "Purchase Order Summary";
    begin
        ///////Delete/////
        Clear(ReportCal);
        // TempP.Reset();
        // TempP.SetRange(UserID, UserId);
        // if TempP.Find('-') then
        //     TempP.DeleteAll();
        /////Insert///////
        ReportCal.Run();
        //////////////////

    end;

    procedure ReplaceString(String: Text[250]; FindWhat: Text[250]; ReplaceWith: Text[250]) NewString: Text
    begin
        WHILE STRPOS(String, FindWhat) > 0 DO
            String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
        NewString := String;
    end;

    procedure ConvertText(MM: Integer; YY: Integer): Text
    begin
        IF MM = 1 THEN
            EXIT('01' + FORMAT(YY))
        ELSE
            IF MM = 2 THEN
                EXIT('02' + FORMAT(YY))
            ELSE
                IF MM = 3 THEN
                    EXIT('03' + FORMAT(YY))
                ELSE
                    IF MM = 4 THEN
                        EXIT('04' + FORMAT(YY))
                    ELSE
                        IF MM = 5 THEN
                            EXIT('05' + FORMAT(YY))
                        ELSE
                            IF MM = 6 THEN
                                EXIT('06' + FORMAT(YY))
                            ELSE
                                IF MM = 7 THEN
                                    EXIT('07' + FORMAT(YY))
                                ELSE
                                    IF MM = 8 THEN
                                        EXIT('08' + FORMAT(YY))
                                    ELSE
                                        IF MM = 9 THEN
                                            EXIT('09' + FORMAT(YY))
                                        ELSE
                                            IF MM = 10 THEN
                                                EXIT('10' + FORMAT(YY))
                                            ELSE
                                                IF MM = 11 THEN
                                                    EXIT('11' + FORMAT(YY))
                                                ELSE
                                                    IF MM = 12 THEN
                                                        EXIT('12' + FORMAT(YY))
                                                    ELSE
                                                        EXIT('');
    end;

    procedure ConvertMonth(MonS: Code[10]): Text
    begin
        IF MonS = 'JAN' THEN
            EXIT('1')
        ELSE
            IF MonS = 'FEB' THEN
                EXIT('2')
            ELSE
                IF MonS = 'MAR' THEN
                    EXIT('3')
                ELSE
                    IF MonS = 'APR' THEN
                        EXIT('4')
                    ELSE
                        IF MonS = 'MAY' THEN
                            EXIT('5')
                        ELSE
                            IF MonS = 'JUN' THEN
                                EXIT('6')
                            ELSE
                                IF MonS = 'JUL' THEN
                                    EXIT('7')
                                ELSE
                                    IF MonS = 'AUG' THEN
                                        EXIT('8')
                                    ELSE
                                        IF MonS = 'SEP' THEN
                                            EXIT('9')
                                        ELSE
                                            IF MonS = 'OCT' THEN
                                                EXIT('10')
                                            ELSE
                                                IF MonS = 'NOV' THEN
                                                    EXIT('11')
                                                ELSE
                                                    IF MonS = 'DEC' THEN
                                                        EXIT('12');

        EXIT('01');
    end;

    procedure ConvertMMtoText(MM: Integer): Text[20]
    begin
        case MM of
            1:
                exit('JAN');
            2:
                exit('FEB');
            3:
                exit('MAR');
            4:
                exit('APR');
            5:
                exit('MAY');
            6:
                exit('JUN');
            7:
                exit('JUL');
            8:
                exit('AUG');
            9:
                exit('SEP');
            10:
                exit('OCT');
            11:
                exit('NOV');
            12:
                exit('DEC');
        end;
    end;

    procedure getDayWeek(cDate: Date): Text[10]
    var
        DinW: Integer;
    begin
        DinW := DATE2DWY(cDate, 1);
        case DinW of
            1:
                exit('Mon');
            2:
                exit('Tue');
            3:
                exit('Wen');
            4:
                exit('Thu');
            5:
                exit('Fri');
            6:
                exit('Sat');
            7:
                exit('Sun');
        end;
    end;

    procedure Gen_ReportPlanP1()
    var
        ItemS: Record Item;
        ItemOnReport: Record "List Item On Report";
        TempReport: Record "Temp Report";
        Crow: Integer;
    // TempPlan: Record "Plan Header";
    begin
        /*
        TempReport.Reset();
        TempReport.SetRange(SUserID, UserId);
        TempReport.SetRange(YEAR, 'PD1');
        if TempReport.Find('-') then
            TempReport.DeleteAll(true);
        Clear(TempReport);

        ItemOnReport.Reset();
        ItemOnReport.SetRange("Group PD", ItemOnReport."Group PD"::PD1);
        if ItemOnReport.Find('-') then begin
            repeat
                Crow += 1;
                TempReport.Init();
                TempReport.RowNo := ItemOnReport.Seq;
                TempReport.CRow := Crow;
                TempReport.Year := Format(ItemOnReport."Group PD"::PD1);
                TempReport."Part No." := ItemS."No.";
                TempReport.Description := ItemS.Description;
                TempReport."Description 2" := ItemS."Description 2";
                TempReport."Part Name" := ItemS.Description;
                if ItemS."Inventory Posting Group" = 'FG' then
                    TempReport.SType := 'FG1'
                else
                    TempReport.SType := 'WIP1';
                TempReport.SUserID := UserId;
                TempReport."Inventory Posting Group" := ItemS."Inventory Posting Group";
                TempReport."Item Cat." := ItemS."Item Category Code";
                TempReport.Insert(true);

                if ItemS."Inventory Posting Group" = 'WIP' then begin
                    Crow += 1;
                    TempReport.Init();
                    TempReport.RowNo := ItemOnReport.Seq;
                    TempReport.CRow := Crow;
                    TempReport.Year := Format(ItemOnReport."Group PD"::PD1);
                    TempReport."Part No." := ItemS."No.";
                    TempReport.Description := ItemS.Description;
                    TempReport."Description 2" := ItemS."Description 2";
                    TempReport."Part Name" := ItemS.Description;
                    TempReport.SType := 'WIP2';
                    TempReport.SUserID := UserId;
                    TempReport."Inventory Posting Group" := ItemS."Inventory Posting Group";
                    TempReport."Item Cat." := ItemS."Item Category Code";
                    TempReport.Insert(true);
                end;
            Until ItemOnReport.Next = 0;
        end;
        */

    end;

    procedure FormatNoThaiText(Amount: Decimal): Text[200]
    var
        AmountText: Text[30];
        x: Integer;
        l: Integer;
        p: Integer;
        adigit: Text[1];
        dflag: Boolean;
        WHTAmtThaiText: Text[200];
    begin

        IF Amount = 0 THEN
            EXIT('ศูนย์บาท');

        AmountText := FORMAT(Amount, 0);
        x := STRPOS(AmountText, '.');
        CASE TRUE OF
            x = 0:
                AmountText := AmountText + '.00';
            x = STRLEN(AmountText) - 1:
                AmountText := AmountText + '0';
            x > STRLEN(AmountText) - 2:
                AmountText := COPYSTR(AmountText, 1, x + 2);
        END;
        l := STRLEN(AmountText);
        REPEAT
            dflag := FALSE;
            p := STRLEN(AmountText) - l + 1;
            adigit := COPYSTR(AmountText, p, 1);
            IF (l IN [4, 12, 20]) AND (l < STRLEN(AmountText)) AND (adigit = '1') THEN
                dflag := TRUE;
            WHTAmtThaiText := WHTAmtThaiText + FormatDigitThai(adigit, l - 3, dflag);
            l := l - 1;
        UNTIL l = 3;

        IF COPYSTR(AmountText, STRLEN(AmountText) - 2, 3) = '.00' THEN
            WHTAmtThaiText := WHTAmtThaiText + 'บาทถ้วน'
        ELSE BEGIN
            IF WHTAmtThaiText <> '' THEN
                WHTAmtThaiText := WHTAmtThaiText + 'บาท';
            l := 2;
            REPEAT
                dflag := FALSE;
                p := STRLEN(AmountText) - l + 1;
                adigit := COPYSTR(AmountText, p, 1);
                IF (l = 1) AND (adigit = '1') AND (COPYSTR(AmountText, p - 1, 1) <> '0') THEN
                    dflag := TRUE;
                WHTAmtThaiText := WHTAmtThaiText + FormatDigitThai(adigit, l, dflag);
                l := l - 1;
            UNTIL l = 0;
            WHTAmtThaiText := WHTAmtThaiText + 'สตางค์';
        END;

        EXIT(WHTAmtThaiText);
    end;

    procedure FormatDigitThai(adigit: Text[1]; pos: Integer; dflag: Boolean): Text[100]
    var
        fdigit: Text[30];
        fcount: Text[30];
    begin
        CASE adigit OF
            '1':
                BEGIN
                    IF (pos IN [1, 9, 17]) AND dflag THEN
                        fdigit := 'เอ็ด'
                    ELSE
                        IF pos IN [2, 10, 18] THEN
                            fdigit := ''
                        ELSE
                            fdigit := 'หนึ่ง';
                END;
            '2':
                BEGIN
                    IF pos IN [2, 10, 18] THEN
                        fdigit := 'ยี่'
                    ELSE
                        fdigit := 'สอง';
                END;
            '3':
                fdigit := 'สาม';
            '4':
                fdigit := 'สี่';
            '5':
                fdigit := 'ห้า';
            '6':
                fdigit := 'หก';
            '7':
                fdigit := 'เจ็ด';
            '8':
                fdigit := 'แปด';
            '9':
                fdigit := 'เก้า';
            '0':
                BEGIN
                    IF pos IN [9, 17, 25] THEN
                        fdigit := 'ล้าน';
                END;
            '-':
                fdigit := 'ลบ';
        END;
        IF (adigit <> '0') AND (adigit <> '-') THEN BEGIN
            CASE pos OF
                2, 10, 18:
                    fcount := 'สิบ';
                3, 11, 19:
                    fcount := 'ร้อย';
                5, 13, 21:
                    fcount := 'พัน';
                6, 14, 22:
                    fcount := 'หมื่น';
                7, 15, 23:
                    fcount := 'แสน';
                9, 17, 25:
                    fcount := 'ล้าน';
            END;
        END;
        EXIT(fdigit + fcount);
    end;


    procedure NumberInWords(number: Decimal; CurrencyName: Text[30]; DenomName: Text[30]): Text[300]
    var
        WholePart: Integer;
        DecimalPart: Integer;
        WholeInWords: Text;
        DecimalInWords: Text;
        AmountInWords: Text[300];
    begin
        WholePart := ROUND(ABS(number), 1, '<');
        DecimalPart := ABS((ABS(number) - WholePart) * 100);


        WholeInWords := NumberToWords(WholePart, CurrencyName);

        IF DecimalPart <> 0 THEN BEGIN
            DecimalInWords := NumberToWords(DecimalPart, DenomName);
            WholeInWords := WholeInWords + ' and ' + DecimalInWords;
        END;

        AmountInWords := '****' + WholeInWords + ' Only';
        EXIT(AmountInWords);
    end;

    procedure NumberToWords(number: Decimal; appendScale: Text[30]): Text[300]
    var
        numString: Text[300];
        pow: Integer;
        powStr: Text[50];
        log: Integer;
    begin


        numString := '';
        IF number < 100 THEN
            IF number < 20 THEN BEGIN
                IF number <> 0 THEN numString := OnesText[number];
            END ELSE BEGIN
                numString := TensText[number DIV 10];
                IF (number MOD 10) > 0 THEN
                    numString := numString + ' ' + OnesText[number MOD 10];
            END
        ELSE BEGIN
            pow := 0;
            powStr := '';
            IF number < 1000 THEN BEGIN // number is between 100 and 1000
                pow := 100;
                powStr := ThousText[1];
            END ELSE BEGIN // find the scale of the number
                log := ROUND(STRLEN(FORMAT(number DIV 1000)) / 3, 1, '>');
                pow := POWER(1000, log);
                powStr := ThousText[log + 1];
            END;


            numString := NumberToWords(number DIV pow, powStr) + ' ' + NumberToWords(number MOD pow, '');
        END;

        EXIT(DELCHR(numString, '<>', ' ') + ' ' + appendScale);
    end;

    procedure SetArrayNumber()
    begin
        OnesText[1] := 'one';
        OnesText[2] := 'two';
        OnesText[3] := 'three';
        OnesText[4] := 'four';
        OnesText[5] := 'five';
        OnesText[6] := 'six';
        OnesText[7] := 'seven';
        OnesText[8] := 'eight';
        OnesText[9] := 'nine';
        OnesText[10] := 'ten';
        OnesText[11] := 'eleven';
        OnesText[12] := 'twelve';
        OnesText[13] := 'thirteen';
        OnesText[14] := 'fourteen';
        OnesText[15] := 'fifteen';
        OnesText[16] := 'sixteen';
        OnesText[17] := 'seventeen';
        OnesText[18] := 'eighteen';
        OnesText[19] := 'nineteen';

        TensText[1] := '';
        TensText[2] := 'twenty';
        TensText[3] := 'thirty';
        TensText[4] := 'forty';
        TensText[5] := 'fivty';
        TensText[6] := 'sixty';
        TensText[7] := 'seventy';
        TensText[8] := 'eighty';
        TensText[9] := 'ninty';

        ThousText[1] := 'hundred';
        ThousText[2] := 'thousand';
        ThousText[3] := 'million';
        ThousText[4] := 'billion';
        ThousText[5] := 'trillion';
    end;

    procedure UpdateSalesOrderLine()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesL: Record "Sales Line";
        CheckA: Integer;
        QtyItemLedger: Decimal;
        ShippedQ: Decimal;
        ShipQ: Decimal;
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Use Sales Order", false);
        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Inventory Shipment");
        ItemLedgerEntry.SetFilter("Location Code", '%1', 'WHS');
        ItemLedgerEntry.SetFilter("Return Reason Code", 'DELIVERY');
        ItemLedgerEntry.SetFilter(Customer, '<>%1', '');
        if ItemLedgerEntry.Find('-') then begin
            repeat
                CheckA := 0;
                QtyItemLedger := Abs(ItemLedgerEntry.Quantity);
                SalesL.Reset();
                SalesL.SetRange("Document Type", SalesL."Document Type"::Order);
                SalesL.SetRange("No.", ItemLedgerEntry."Item No.");
                SalesL.SetFilter("Outstanding Qty. (Base)", '>%1', 0);
                SalesL.SetRange("Planned Delivery Date", ItemLedgerEntry."Document Date");
                SalesL.SetRange("Sell-to Customer No.", ItemLedgerEntry.Customer);
                if SalesL.Find('-') then begin
                    repeat
                        if QtyItemLedger > 0 then begin
                            if QtyItemLedger >= SalesL."Outstanding Qty. (Base)" then begin
                                ShipQ := SalesL."Outstanding Qty. (Base)";
                                QtyItemLedger := QtyItemLedger - ShipQ;
                            end
                            else begin
                                ShipQ := QtyItemLedger;
                                QtyItemLedger := 0;
                            end;

                            ShippedQ := SalesL."Quantity Shipped";
                            ShippedQ := ShippedQ + ShipQ;
                            if ShipQ > 0 then begin
                                CheckA := 1;

                                SalesL.Validate("Qty. Shipped (Base)", ShippedQ);
                                SalesL.Validate("Quantity Shipped", ShippedQ);
                                SalesL.InitOutstanding();
                                SalesL.InitOutstandingAmount();
                                SalesL.Modify(false);

                                ItemLedgerEntry."Use Sales Order" := true;
                                ItemLedgerEntry."Order No." := SalesL."Document No.";
                                ItemLedgerEntry."Order Line No." := SalesL."Line No.";
                                ItemLedgerEntry.Modify(false);
                            end;

                        end;

                    until SalesL.Next = 0;
                end;


            until ItemLedgerEntry.Next = 0;
        end;
    end;

    procedure UpdateSales_Invoiced()
    var
        SalesL: Record "Sales Line";
        SalesH: Record "Sales Header";
        CK: Integer;
    begin
        SalesH.Reset();
        SalesH.SetRange(Invoiced, false);
        if SalesH.Find('-') then begin
            CK := 0;
            SalesL.SetRange("Document Type", SalesL."Document Type"::Order);
            SalesL.SetRange("Document No.", SalesH."No.");
            if SalesL.Find('-') then begin
                repeat
                    SalesL.CalcFields("Invoice No.");
                    if SalesL."Invoice No." = '' then begin
                        CK += 1;
                    end;
                until SalesL.Next = 0;
            end;
            if CK > 0 then begin
                SalesH.Invoiced := false;
                SalesH.Modify(false);
            end;
        end;
    end;

    procedure DeleteSalesInvoiceLine(SalesLine: Record "Sales Line")
    var
        SalesL: Record "Sales Line";
    begin
        SalesL.Reset();
        SalesL.SetRange("Document Type", SalesL."Document Type"::Invoice);
        SalesL.SetRange("Document No.", SalesLine."Document No.");
        SalesL.SetRange("Line No.", SalesLine."Line No.");
        if SalesL.Find('-') then begin
            SalesL.Delete();
        end;
    end;

    procedure UndoInvtShipmentonItemLedger(ItemL: Record "Item Ledger Entry")
    var
        ItemLed: Record "Item Ledger Entry";
        ItemLedUpdate: Record "Item Ledger Entry";
        PostedRec: Codeunit "Invt. Doc.-Post Receipt XTH";
        InvtH: Record "Invt. Document Header";
        InvtL: Record "Invt. Document Line";
        SalesL: Record "Sales Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        WHSSetup: Record "Warehouse Setup";
        docNew: Code[20];
        CostAM: Decimal;
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        UQty: Decimal;
        ShippedQ: Decimal;
    begin
        if ItemL.Undo then
            Error('This Document is Undo Already!');

        UQty := Abs(ItemL.Quantity);
        ShippedQ := UQty;
        ItemLed.Reset();
        ItemLed.SetRange("Entry No.", ItemL."Entry No.");
        ItemLed.SetRange("Document Type", ItemL."Document Type"::"Inventory Shipment");
        ItemLed.SetRange(Undo, false);
        if ItemLed.Find('-') then begin
            WHSSetup.Get();
            docNew := NoSeriesMgt.GetNextNo(WHSSetup."Whse. Receipt Nos.", Today, true);
            InvtH.Reset();
            InvtH.Init();
            InvtH."No. Series" := WHSSetup."Whse. Receipt Nos.";
            InvtH."No." := docNew;
            InvtH."Document Type" := InvtH."Document Type"::Receipt;
            InvtH."Posting No. Series" := WHSSetup."Posted Whse. Receipt Nos.";
            InvtH."Posting Date" := ItemL."Posting Date";
            InvtH."Document Date" := ItemL."Posting Date";
            InvtH."Create By" := UserFullName(UserId);
            InvtH."Create Date" := CurrentDateTime;
            InvtH.Validate("Location Code", ItemL."Location Code");
            InvtH."Salesperson/Purchaser Code" := UserFullName(UserId);
            InvtH."Posting Description" := 'Undo Document';
            InvtH."External Document No." := ItemL."Document No.";
            InvtH."Gen. Bus. Posting Group" := 'DOMESTIC';
            if ItemL.Customer <> '' then
                InvtH.Customer := ItemL.Customer;
            InvtH.Validate("Posting No.", docNew);
            InvtH.Insert();
            //Insert Line//
            ItemL.CalcFields("Cost Amount (Actual)");
            ItemL.CalcFields("Cost Amount (Expected)");
            CostAM := abs(ItemL."Cost Amount (Actual)") + abs(ItemL."Cost Amount (Expected)");
            //  Message(Format(CostAM));
            InvtL.Init();
            InvtL."Document No." := docNew;
            InvtL."Line No." := 10000;
            InvtL.Validate("Item No.", ItemL."Item No.");
            InvtL."Location Code" := ItemL."Location Code";
            InvtL."Posting Date" := ItemL."Posting Date";
            InvtL."Gen. Bus. Posting Group" := 'DOMESTIC';
            InvtL.Validate(Quantity, abs(ItemL.Quantity));
            InvtL.Validate("Unit Amount", 0);
            if abs(CostAM) > 0 then begin
                InvtL.Validate("Unit Amount", abs(ItemL.Quantity) / abs(CostAM));
            end;
            // InvtL.Amount := abs(CostAM);
            // InvtL."Amount (ACY)" := abs(CostAM);
            if InvtL."Inventory Posting Group" = 'FG' then
                InvtL."Reason Code" := 'DELIVERY'
            else
                InvtL."Reason Code" := 'FACTORY';
            if ItemL."Return Reason Code" <> '' then
                InvtL."Reason Code" := ItemL."Return Reason Code";
            InvtL."Unit of Measure Code" := ItemL."Unit of Measure Code";
            InvtL.Insert();

            //Insert Lot No//
            if ItemL."Lot No." <> '' then begin
                //Insert Lot//
                ItemTacking.RESET;
                IF (ItemTacking.FINDLAST) THEN
                    ItemEntryNo := ItemTacking."Entry No." + 1;
                ItemTacking.INIT;
                ItemTacking."Entry No." := ItemEntryNo;
                ItemTacking."Item No." := InvtL."Item No.";
                ItemTacking."Source ID" := InvtL."Document No.";
                ItemTacking."Source Type" := 5851;
                ItemTacking."Source Batch Name" := '';
                ItemTacking."Source Prod. Order Line" := 0;
                ItemTacking."Source Ref. No." := InvtL."Line No.";
                ItemTacking.Positive := true;
                ItemTacking."Location Code" := InvtL."Location Code";
                ItemTacking."Quantity (Base)" := UQty;
                ItemTacking.Quantity := UQty;
                ItemTacking."Qty. to Handle (Base)" := UQty;
                ItemTacking."Qty. to Invoice (Base)" := UQty;
                ItemTacking."Lot No." := ItemL."Lot No.";
                ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"0";
                ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
                ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                ItemTacking."Creation Date" := WORKDATE;
                ItemTacking."Created By" := USERID;
                ItemTacking."Expected Receipt Date" := InvtL."Document Date";
                ItemTacking.INSERT();

            end;
            //POSTED//
            PostedRec.Run(InvtH);
            //Update Item Ledger//
            if ItemL."Order No." <> '' then begin
                SalesL.Reset();
                SalesL.SetRange("Document No.", ItemL."Order No.");
                SalesL.SetRange("Line No.", ItemL."Order Line No.");
                SalesL.SetRange("Sell-to Customer No.", ItemL.Customer);
                if SalesL.Find('-') then begin
                    if ShippedQ > 0 then begin
                        ShippedQ := SalesL."Quantity Shipped" - ShippedQ;
                        if ShippedQ < 0 then
                            ShippedQ := 0;
                        SalesL.Validate("Quantity Shipped", ShippedQ);
                        SalesL.Validate("Qty. Shipped (Base)", ShippedQ);
                        SalesL.InitOutstanding();
                        SalesL.InitOutstandingAmount();
                        SalesL.Modify(false);
                    end;

                end;
            end;

            //////////////////////
            ItemLedUpdate.Reset();
            ItemLedUpdate.SetRange("Entry No.", ItemL."Entry No.");
            if ItemLedUpdate.Find('-') then begin
                ItemLedUpdate.Undo := true;
                ItemLedUpdate."Undo Document No." := docNew;
                ItemLedUpdate.Modify(false);
            end;
        end;
    end;

    procedure InvtDocumentUpdateShipt()
    var
        MaterialH: Record "Material Delivery Header";
    begin
        MaterialH.Reset();
        MaterialH.SetAutoCalcFields("Shipment No.");
        MaterialH.SetFilter("Shipment No.", '%1', '');
        if MaterialH.Find('-') then begin
            repeat
                MaterialH.Status := MaterialH.Status::Open;
                MaterialH.Modify(false);
            until MaterialH.Next = 0;
        end;
    end;

    procedure InvtDocumentUpdateRec()
    var
        MaterialH: Record "Transfer Production Header";
    begin
        MaterialH.Reset();
        MaterialH.SetAutoCalcFields("Receipt No.");
        MaterialH.SetFilter("Receipt No.", '%1', '');
        if MaterialH.Find('-') then begin
            repeat
                MaterialH.Status := MaterialH.Status::Open;
                MaterialH.Modify(false);
            until MaterialH.Next = 0;
        end;
    end;

    procedure ProductionRecordPosted(ProRecH: Record "Production Record Header"; ProRecL: Record "Production Record Line")
    var
        ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        UQty: Decimal;
        PostedStock: Codeunit "Posted Stock";
    begin
        UQty := ProRecL.Quantity;
        ItemS.Reset();
        ItemS.SetRange("No.", ProRecL."Part No.");
        if ItemS.Find('-') then begin
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-AUTO');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);

            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-AUTO';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Posted Assembly";
            ItemJnlLine."Document No." := ProRecH."Req. No.";
            ItemJnlLine."Document Date" := ProRecH."Req. Date";
            ItemJnlLine."Document Line No." := ProRecL."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := ProRecL."Part No.";
            ItemJnlLine."External Document No." := ProRecH."Ref. Document";
            ItemJnlLine."Posting Date" := ProRecH."Req. Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := ProRecL."Part No.";
            ItemJnlLine.VALIDATE("Location Code", ItemS.Location);
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";

            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := UQty;
            ItemJnlLine."Invoiced Quantity" := UQty;
            ItemJnlLine."Quantity (Base)" := UQty;
            ItemJnlLine."Invoiced Qty. (Base)" := UQty;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;

            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'PROD.REC';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine.Insert();

            if ItemS."Item Tracking Code" <> '' then
                if ProRecL."Lot No." <> '' then begin
                    ItemTacking.Reset();
                    ItemTacking.SetRange("Source ID", 'ITEM');
                    ItemTacking.SetRange("Source Batch Name", 'Z-AUTO');
                    ItemTacking.SetRange("Item No.", ProRecL."Part No.");
                    if ItemTacking.Find('-') then
                        ItemTacking.DeleteAll(true);

                    ItemTacking.RESET;
                    IF (ItemTacking.FINDLAST) THEN
                        ItemEntryNo := ItemTacking."Entry No." + 1;

                    ItemTacking.INIT;
                    ItemTacking."Entry No." := ItemEntryNo;
                    ItemTacking."Item No." := ItemS."No.";
                    ItemTacking."Source ID" := 'ITEM';
                    ItemTacking."Source Batch Name" := 'Z-AUTO';
                    ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"2";
                    ItemTacking."Source Type" := 83;

                    ItemTacking."Source Prod. Order Line" := 0;
                    ItemTacking."Source Ref. No." := 10000;
                    ItemTacking.Positive := true;
                    ItemTacking."Location Code" := ItemS.Location;
                    ItemTacking."Qty. to Handle (Base)" := UQty;
                    ItemTacking."Qty. to Invoice (Base)" := UQty;
                    ItemTacking.Validate(Quantity, UQty);
                    ItemTacking.Validate("Quantity (Base)", UQty);

                    ItemTacking."Lot No." := ProRecL."Lot No.";

                    ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
                    ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                    ItemTacking."Creation Date" := WORKDATE;
                    ItemTacking."Created By" := USERID;
                    ItemTacking."Expected Receipt Date" := ProRecH."Req. Date";
                    ItemTacking.INSERT();
                end;

            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);
            if ProRecL."NG Qty" > 0 then
                PostedStock.ProductionRecordPosted_NG(ProRecH, ProRecL);
            if (ItemS."Cut Stock" = ItemS."Cut Stock"::BEFORE) and (ItemS."From Material Item" <> '') then begin
                //Cust Stock Before as -R (Cut M) , -I (Cut R)
                PostedStock.ProductionRecordPosted_Before(ProRecH, ProRecL, ItemS."From Material Item");
            end
            else
                if (ItemS."Cut Stock" = ItemS."Cut Stock"::ONPROCESS) and (ItemS."From Material Item" <> '') then begin
                    //Cut Stock on Location PROCESS
                    PostedStock.ProductionRecordPosted_Onprocess(ProRecH, ProRecL, ItemS."No.", 'PROCESS');
                end;

        end;
    end;

    LOCAL procedure PostItemJnlLine(VAR ItemJnlLine: Record "Item Journal Line"; VAR ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
    var
        OrigItemJnlLine: Record "Item Journal Line";
        ItemShptEntry: Integer;
    begin
        OrigItemJnlLine := ItemJnlLine;
        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
        ItemShptEntry := ItemJnlLine."Item Shpt. Entry No.";
        ItemJnlLine := OrigItemJnlLine;
        ItemJnlLine."Item Shpt. Entry No." := ItemShptEntry;
    end;

    procedure ProductionRecordPostedReOpen(ProRecH: Record "Production Record Header"; ProRecL: Record "Production Record Line")
    var
        ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        PostedStock: Codeunit "Posted Stock";
    begin
        ItemS.Reset();
        ItemS.SetRange("No.", ProRecL."Part No.");
        if ItemS.Find('-') then begin
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-AUTO');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);
            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-AUTO';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Posted Assembly";
            ItemJnlLine."Document No." := ProRecH."Req. No.";
            ItemJnlLine."Document Date" := ProRecH."Req. Date";
            ItemJnlLine."Document Line No." := ProRecL."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := ProRecL."Part No.";

            ItemJnlLine."Posting Date" := ProRecH."Req. Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := ProRecL."Part No.";
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";

            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := ProRecL.Quantity;
            ItemJnlLine."Invoiced Quantity" := ProRecL.Quantity;
            ItemJnlLine."Quantity (Base)" := ProRecL.Quantity;
            ItemJnlLine."Invoiced Qty. (Base)" := ProRecL.Quantity;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;
            ItemJnlLine.VALIDATE("Location Code", ItemS.Location);
            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'PROD.REC';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine.Insert();

            if ItemS."Item Tracking Code" <> '' then
                if ProRecL."Lot No." <> '' then begin
                    ItemTacking.Reset();
                    ItemTacking.SetRange("Source ID", 'ITEM');
                    ItemTacking.SetRange("Source Batch Name", 'Z-AUTO');
                    ItemTacking.SetRange("Item No.", ProRecL."Part No.");
                    if ItemTacking.Find('-') then
                        ItemTacking.DeleteAll(true);

                    ItemTacking.RESET;
                    IF (ItemTacking.FINDLAST) THEN
                        ItemEntryNo := ItemTacking."Entry No." + 1;
                    ItemTacking.INIT;
                    ItemTacking."Entry No." := ItemEntryNo;
                    ItemTacking."Item No." := ItemS."No.";
                    ItemTacking."Source ID" := 'ITEM';
                    ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"3";
                    ItemTacking."Source Type" := 83;
                    ItemTacking."Source Batch Name" := 'Z-AUTO';
                    ItemTacking."Source Prod. Order Line" := 0;
                    ItemTacking."Source Ref. No." := 10000;
                    ItemTacking.Positive := false;
                    ItemTacking."Location Code" := ItemS.Location;
                    ItemTacking."Qty. to Handle (Base)" := ProRecL.Quantity * -1;
                    ItemTacking."Qty. to Invoice (Base)" := ProRecL.Quantity * -1;

                    ItemTacking.Validate("Quantity (Base)", ProRecL.Quantity * -1);
                    ItemTacking.Validate(Quantity, ProRecL.Quantity * -1);
                    ItemTacking."Lot No." := ProRecL."Lot No.";
                    ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
                    ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                    ItemTacking."Creation Date" := WORKDATE;
                    ItemTacking."Created By" := USERID;
                    ItemTacking."Shipment Date" := ProRecH."Req. Date";
                    ItemTacking.INSERT();
                end;

            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);
            if ProRecL."NG Qty" > 0 then
                PostedStock.ProductionRecordPostedReOpen_NG(ProRecH, ProRecL);

            if (ItemS."Cut Stock" = ItemS."Cut Stock"::BEFORE) and (ItemS."From Material Item" <> '') then begin
                //Cust Stock Before as -R (Cut M) , -I (Cut R)
                PostedStock.ProductionRecordPostedReOpen_Before(ProRecH, ProRecL, ItemS."From Material Item");
            end
            else
                if (ItemS."Cut Stock" = ItemS."Cut Stock"::ONPROCESS) and (ItemS."From Material Item" <> '') then begin
                    //Cut Stock on Location PROCESS
                    PostedStock.ProductionRecordPostedReOpen_Onprocess(ProRecH, ProRecL, ItemS."No.");

                end;

        end;
    end;

    procedure PostedMoveStock(ProRecH: Record "MoveStock Header"; ProRecL: Record "MoveStock Line")
    var
        ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
    begin
        ItemS.Reset();
        ItemS.SetRange("No.", ProRecL."Part No.");
        if ItemS.Find('-') then begin
            //Step Move Out
            //Negative
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-MOVE');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);
            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-MOVE';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Direct Transfer";
            ItemJnlLine."Document No." := ProRecH."Req. No.";
            ItemJnlLine."Document Date" := ProRecH."Req. Date";
            ItemJnlLine."Document Line No." := ProRecL."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := ProRecL."Part No.";

            ItemJnlLine."Posting Date" := ProRecH."Req. Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := ProRecL."Part No.";
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";

            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := ProRecL.Quantity;
            ItemJnlLine."Invoiced Quantity" := ProRecL.Quantity;
            ItemJnlLine."Quantity (Base)" := ProRecL.Quantity;
            ItemJnlLine."Invoiced Qty. (Base)" := ProRecL.Quantity;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;
            ItemJnlLine.VALIDATE("Location Code", ProRecL."OLD Location");
            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'MOVE';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine.Insert();
            //Negative

            if ItemS."Item Tracking Code" <> '' then
                if ProRecL."Lot No." <> '' then begin
                    ItemTacking.Reset();
                    ItemTacking.SetRange("Source ID", 'ITEM');
                    ItemTacking.SetRange("Source Batch Name", 'Z-MOVE');
                    ItemTacking.SetRange("Item No.", ProRecL."Part No.");
                    if ItemTacking.Find('-') then
                        ItemTacking.DeleteAll(true);

                    ItemTacking.RESET;
                    IF (ItemTacking.FINDLAST) THEN
                        ItemEntryNo := ItemTacking."Entry No." + 1;
                    ItemTacking.INIT;
                    ItemTacking."Entry No." := ItemEntryNo;
                    ItemTacking."Item No." := ItemS."No.";
                    ItemTacking."Source ID" := 'ITEM';
                    ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"3";
                    ItemTacking."Source Type" := 83;
                    ItemTacking."Source Batch Name" := 'Z-MOVE';
                    ItemTacking."Source Prod. Order Line" := 0;
                    ItemTacking."Source Ref. No." := 10000;
                    ItemTacking.Positive := false;
                    ItemTacking."Location Code" := ProRecL."OLD Location";
                    ItemTacking."Qty. to Handle (Base)" := ProRecL.Quantity * -1;
                    ItemTacking."Qty. to Invoice (Base)" := ProRecL.Quantity * -1;

                    ItemTacking.Validate("Quantity (Base)", ProRecL.Quantity * -1);
                    ItemTacking.Validate(Quantity, ProRecL.Quantity * -1);

                    ItemTacking."Lot No." := ProRecL."Lot No.";
                    ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
                    ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                    ItemTacking."Creation Date" := WORKDATE;
                    ItemTacking."Created By" := USERID;
                    ItemTacking."Shipment Date" := ProRecH."Req. Date";
                    ItemTacking.INSERT();
                end;

            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);
        end;
        //Positive//
        PostedMoveStockIN(ProRecH, ProRecL);
    end;

    procedure PostedMoveStockIN(ProRecH: Record "MoveStock Header"; ProRecL: Record "MoveStock Line")
    var
        ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
    begin
        ItemS.Reset();
        ItemS.SetRange("No.", ProRecL."Part No.");
        if ItemS.Find('-') then begin
            //Step Move Out
            //Negative
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-MOVE');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);

            //Positive
            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-MOVE';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Direct Transfer";
            ItemJnlLine."Document No." := ProRecH."Req. No.";
            ItemJnlLine."Document Date" := ProRecH."Req. Date";
            ItemJnlLine."Document Line No." := ProRecL."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := ProRecL."Part No.";

            ItemJnlLine."Posting Date" := ProRecH."Req. Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := ProRecL."Part No.";
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";

            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := ProRecL.Quantity;
            ItemJnlLine."Invoiced Quantity" := ProRecL.Quantity;
            ItemJnlLine."Quantity (Base)" := ProRecL.Quantity;
            ItemJnlLine."Invoiced Qty. (Base)" := ProRecL.Quantity;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;
            ItemJnlLine.VALIDATE("Location Code", ProRecL."New Locatin");
            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'MOVE';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine.Insert();
            //Positive

            if ItemS."Item Tracking Code" <> '' then
                if ProRecL."Lot No." <> '' then begin
                    ItemTacking.Reset();
                    ItemTacking.SetRange("Source ID", 'ITEM');
                    ItemTacking.SetRange("Source Batch Name", 'Z-MOVE');
                    ItemTacking.SetRange("Item No.", ProRecL."Part No.");
                    if ItemTacking.Find('-') then
                        ItemTacking.DeleteAll(true);

                    ItemTacking.RESET;
                    IF (ItemTacking.FINDLAST) THEN
                        ItemEntryNo := ItemTacking."Entry No." + 1;

                    //Positive
                    ItemEntryNo := ItemEntryNo + 1;
                    ItemTacking.INIT;
                    ItemTacking."Entry No." := ItemEntryNo;
                    ItemTacking."Item No." := ItemS."No.";
                    ItemTacking."Source ID" := 'ITEM';
                    ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"2";
                    ItemTacking."Source Type" := 83;
                    ItemTacking."Source Batch Name" := 'Z-MOVE';
                    ItemTacking."Source Prod. Order Line" := 0;
                    ItemTacking."Source Ref. No." := 10000;
                    ItemTacking.Positive := true;
                    ItemTacking."Location Code" := ProRecL."New Locatin";
                    ItemTacking."Qty. to Handle (Base)" := ProRecL.Quantity;
                    ItemTacking."Qty. to Invoice (Base)" := ProRecL.Quantity;

                    ItemTacking.Validate("Quantity (Base)", ProRecL.Quantity);
                    ItemTacking.Validate(Quantity, ProRecL.Quantity);
                    ItemTacking."Lot No." := ProRecL."Lot No.";

                    ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
                    ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                    ItemTacking."Creation Date" := WORKDATE;
                    ItemTacking."Created By" := USERID;
                    ItemTacking."Expected Receipt Date" := ProRecH."Req. Date";
                    ItemTacking.INSERT();

                end;

            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);
        end;
    end;

    procedure CheckBeforePrint(Docx: Code[20]): Boolean
    var
        InvtShiptH: Record "Invt. Document Header";
    begin
        InvtShiptH.Reset();
        InvtShiptH.SetRange("No.", Docx);
        if InvtShiptH.Find('-') then begin
            if InvtShiptH."External Document No." <> '' then
                InvtShiptH."External Document No." := '';
            if InvtShiptH."Ref.Doc" <> '' then
                InvtShiptH."Ref.Doc" := '';
            InvtShiptH.Modify(false);
        end;

        exit(True);
    end;


}