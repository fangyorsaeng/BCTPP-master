report 50026 "SALES DELIVERY SCHEDULE"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/SalesDeliveryPlan.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'DELIVERY SCHEDULE';
    dataset
    {
        dataitem(Integer; Integer)
        {
            column(Number; Number) { }
            column(SetYear; format(SetYear)) { }
            column(SetMonth; format(SetMonth)) { }

            dataitem(Item; Item)
            {
                RequestFilterFields = "Default Customer", "No.", "Item Category Code";
                DataItemTableView = where("Default Customer" = filter(<> ''));
                column(No_; "No.") { }
                column(Description; Description) { }
                column(Model; "Description 2") { }
                column(Lot_Size; "Lot Size") { }
                column(Common_Item_No_; "Common Item No.") { }
                column(Customer; CustomerS.Name) { }
                column(Base_Unit_of_Measure; "Base Unit of Measure") { }
                column(Back_No_; "Back No.") { }

                column(DayT1; DayT[1]) { }
                column(DayT2; DayT[2]) { }
                column(DayT3; DayT[3]) { }
                column(DayT4; DayT[4]) { }
                column(DayT5; DayT[5]) { }
                column(DayT6; DayT[6]) { }
                column(DayT7; DayT[7]) { }
                column(DayT8; DayT[8]) { }
                column(DayT9; DayT[9]) { }
                column(DayT10; DayT[10]) { }
                column(DayT11; DayT[11]) { }
                column(DayT12; DayT[12]) { }
                column(DayT13; DayT[13]) { }
                column(DayT14; DayT[14]) { }
                column(DayT15; DayT[15]) { }
                column(DayT16; DayT[16]) { }
                column(DayT17; DayT[17]) { }
                column(DayT18; DayT[18]) { }
                column(DayT19; DayT[19]) { }
                column(DayT20; DayT[20]) { }
                column(DayT21; DayT[21]) { }
                column(DayT22; DayT[22]) { }
                column(DayT23; DayT[23]) { }
                column(DayT24; DayT[24]) { }
                column(DayT25; DayT[25]) { }
                column(DayT26; DayT[26]) { }
                column(DayT27; DayT[27]) { }
                column(DayT28; DayT[28]) { }
                column(DayT29; DayT[29]) { }
                column(DayT30; DayT[30]) { }
                column(DayT31; DayT[31]) { }
                dataitem(Integer2; Integer)
                {
                    column(P2_Number1; Number) { }
                    column(ACType; ACType) { }
                    column(Row1; Row1) { }
                    column(QtyA1; QtyA[1]) { }
                    column(QtyA2; QtyA[2]) { }
                    column(QtyA3; QtyA[3]) { }
                    column(QtyA4; QtyA[4]) { }
                    column(QtyA5; QtyA[5]) { }
                    column(QtyA6; QtyA[6]) { }
                    column(QtyA7; QtyA[7]) { }
                    column(QtyA8; QtyA[8]) { }
                    column(QtyA9; QtyA[9]) { }
                    column(QtyA10; QtyA[10]) { }
                    column(QtyA11; QtyA[11]) { }
                    column(QtyA12; QtyA[12]) { }
                    column(QtyA13; QtyA[13]) { }
                    column(QtyA14; QtyA[14]) { }
                    column(QtyA15; QtyA[15]) { }
                    column(QtyA16; QtyA[16]) { }
                    column(QtyA17; QtyA[17]) { }
                    column(QtyA18; QtyA[18]) { }
                    column(QtyA19; QtyA[19]) { }
                    column(QtyA20; QtyA[20]) { }
                    column(QtyA21; QtyA[21]) { }
                    column(QtyA22; QtyA[22]) { }
                    column(QtyA23; QtyA[23]) { }
                    column(QtyA24; QtyA[24]) { }
                    column(QtyA25; QtyA[25]) { }
                    column(QtyA26; QtyA[26]) { }
                    column(QtyA27; QtyA[27]) { }
                    column(QtyA28; QtyA[28]) { }
                    column(QtyA29; QtyA[29]) { }
                    column(QtyA30; QtyA[30]) { }
                    column(QtyA31; QtyA[31]) { }
                    column(MontA1; MontA[1]) { }
                    column(MontA2; MontA[2]) { }
                    column(MontA3; MontA[3]) { }
                    column(MontA4; MontA[4]) { }
                    column(MontA5; MontA[5]) { }
                    column(MontT1; MontT[1]) { }
                    column(MontT2; MontT[2]) { }
                    column(MontT3; MontT[3]) { }
                    column(MontT4; MontT[4]) { }
                    column(MontT5; MontT[5]) { }
                    column(TotalPlanA; TotalPlanA) { }
                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, 2);
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then begin
                            ACType := 'PLAN';
                            Row1 := Row2;
                        end
                        else begin
                            ACType := 'Actual';
                            Row1 := 0;
                        end;

                        /////////find////////////

                        getDeliveryPlan(Item."No.", ACType);
                        getDeliveryPlanForecast(Item."No.", ACType);
                        TotalPlanA := 0;
                        TotalPlanA := QtyA[1] + QtyA[2] + QtyA[3] + QtyA[4] + QtyA[5] + QtyA[6] + QtyA[7] + QtyA[8] + QtyA[9] + QtyA[10];
                        TotalPlanA += QtyA[11] + QtyA[12] + QtyA[13] + QtyA[14] + QtyA[15] + QtyA[16] + QtyA[17] + QtyA[18] + QtyA[19] + QtyA[20];
                        TotalPlanA += QtyA[21] + QtyA[22] + QtyA[23] + QtyA[24] + QtyA[25] + QtyA[26] + QtyA[27] + QtyA[28] + QtyA[29] + QtyA[30] + QtyA[31];
                    end;


                }


                trigger OnAfterGetRecord()
                begin
                    Row2 += 1;
                    //Row1 += 1;


                    if Item.GetFilter("Default Customer") = '' then begin
                        Error('Please.. Select Default Customer.');
                    end;
                    CustomerS.Reset();
                    CustomerS.SetRange("No.", Item."Default Customer");
                    if CustomerS.Find('-') then;
                end;

            }
            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, 1);

            end;

            trigger OnAfterGetRecord()
            begin
                MontA[1] := 0;
                MontA[2] := 0;
                MontA[3] := 0;
                MontA[4] := 0;
                MontA[5] := 0;

                MontT[1] := getMontA(1);
                MontT[2] := getMontA(2);
                MontT[3] := getMontA(3);
                MontT[4] := getMontA(4);
                MontT[5] := getMontA(5);
                getWeekDays();


            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(option)
                {
                    field(SetYear; SetYear)
                    {
                        ApplicationArea = all;
                    }
                    field(SetMonth; SetMonth)
                    {
                        ApplicationArea = all;
                    }
                }

            }
        }
    }
    trigger OnInitReport()
    begin
        SetMonth := Enum::"Select Month".FromInteger(Date2DMY(WorkDate(), 2));
        SetYear := Enum::"Select Year".FromInteger(Date2DMY(WorkDate(), 3));
    end;

    trigger OnPreReport()
    begin
        CurrDate := DMY2Date(1, SetMonth.AsInteger(), SetYear.AsInteger());
        Company.get();
    end;

    var
        utility: Codeunit Utility;
        QtyA: array[31] of Decimal;
        DayT: array[31] of Text[10];
        MontA: array[5] of Decimal;
        MontT: array[5] of Text[20];
        TotalPlanA: Decimal;
        PlandeliveryDate: Date;
        SetYear: Enum "Select Year";
        SetMonth: Enum "Select Month";
        CurrDate: Date;
        Row1: Integer;
        Row2: Integer;
        Company: Record "Company Information";
        CustomerS: Record Customer;
        ACType: Text[20];

    procedure checkWorking(TargetDate: Date)
    var
        NonWorking: Boolean;
        CalendarMgt: Codeunit "Calendar Management";
        CustomizedCalendarChange: Record "Customized Calendar Change";
    begin

    end;

    procedure getWeekDays()
    var
        I: Integer;
        cDate: Date;
    begin
        cDate := DMY2Date(1, SetMonth.AsInteger(), SetYear.AsInteger());
        for I := 1 to 31 do begin
            DayT[I] := utility.getDayWeek(cDate);
            cDate := CalcDate('<+1D>', cDate);
        end;
    end;

    procedure getMontA(MM: Integer): Text[20]
    var
        MT: Text[20];
        CalD2: Date;
    begin
        CalD2 := CalcDate('<CM+' + format(MM) + 'M' + '>', CurrDate);
        MT := utility.ConvertMMtoText(Date2DMY(CalD2, 2)) + ' ' + format(Date2DMY(CalD2, 3));
        exit(MT);
    end;

    procedure getDeliveryPlan(ItemNo: Code[20]; AMType: Text[20])
    var
        I: Integer;
        cDate: Date;
        SalesLine: Record "Sales Line";
        QtyC: Decimal;
        LastDate: Date;
        ItemLedLedger: Record "Item Ledger Entry";
    begin
        cDate := DMY2Date(1, SetMonth.AsInteger(), SetYear.AsInteger());
        LastDate := CalcDate('CM', cDate);
        for I := 1 to 31 do begin
            ///////////////////////////////////Insert//////////////
            ///////////////////////////////////////////////////////
            QtyC := 0;
            if cDate <= LastDate then begin
                if AMType = 'PLAN' then begin
                    SalesLine.Reset();
                    SalesLine.SetRange("No.", ItemNo);
                    SalesLine.SetRange("Planned Delivery Date", cDate);
                    SalesLine.SetRange("Sales Status", SalesLine."Sales Status"::Open);
                    if SalesLine.Find('-') then begin
                        repeat
                            QtyC += SalesLine.Quantity;
                        until SalesLine.Next = 0;
                    end;
                end
                else begin

                    ItemLedLedger.Reset();
                    ItemLedLedger.SetRange("Item No.", ItemNo);
                    ItemLedLedger.SetRange("Posting Date", cDate);
                    ItemLedLedger.SetRange(Undo, false);
                    ItemLedLedger.SetFilter("Document Type", '%1', ItemLedLedger."Document Type"::"Inventory Shipment");
                    //   ItemLedLedger.SetRange("Order Type", ItemLedLedger."Order Type"::" ");
                    ItemLedLedger.SetFilter("Order No.", '<>%1', '');
                    if ItemLedLedger.Find('-') then begin
                        repeat
                            QtyC += ItemLedLedger.Quantity;
                        until ItemLedLedger.Next = 0;
                    end;
                end;

                QtyA[I] := ABS(QtyC);
            end;
            //////////////////////////////////////////////////////
            cDate := CalcDate('<+1D>', cDate);
        end;
    end;

    procedure getDeliveryPlanForecast(ItemNo: Code[20]; AMType: Text[20])
    var
        I: Integer;
        J: Integer;
        cDate: Date;
        cDate2: Date;
        LastDate: Date;
        ProdFore: Record "Production Forecast Entry";
        QtyC: Decimal;
    begin
        cDate := DMY2Date(1, SetMonth.AsInteger(), SetYear.AsInteger());
        cDate2 := cDate;
        for I := 1 to 5 do begin
            cDate2 := CalcDate('<+1M>', cDate2);
            LastDate := CalcDate('CM', cDate2);
            MontA[I] := 0;
            ///////////////////////////////////Insert//////////////
            cDate := DMY2Date(1, Date2DMY(cDate2, 2), Date2DMY(cDate2, 3));
            for J := 1 to 31 do begin
                ///////////////////////////////////////////////////////
                QtyC := 0;
                if cDate <= LastDate then begin
                    if AMType = 'PLAN' then begin
                        ProdFore.Reset();
                        ProdFore.SetRange("Item No.", ItemNo);
                        ProdFore.SetRange("Forecast Date", cDate);
                        if ProdFore.Find('-') then begin
                            repeat
                                QtyC += ProdFore."Forecast Quantity";
                            until ProdFore.Next = 0;
                        end;
                    end else begin
                        QtyC := 0;
                    end;
                    MontA[I] += QtyC;
                end;
                cDate := CalcDate('<+1D>', cDate);
            end;//J

            //////////////////////////////////////////////////////

        end;
    end;



}

