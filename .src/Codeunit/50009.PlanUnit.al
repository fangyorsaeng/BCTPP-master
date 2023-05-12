codeunit 50009 "Plan Unit"
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
    tabledata "Plan Header" = ridm,
    tabledata "Plan Report" = ridm,
    tabledata "Plan Line Sub" = ridm,
    tabledata "Item Application Entry" = ridm;
    trigger OnRun()
    begin

    end;

    procedure UpdatePlanLine(PlanName: Code[50])
    var
        SaleH: Record "Sales Header";
        SaleL: Record "Sales Line";
        StartDate: Date;
        EndDate: Date;
        PlanH: Record "Plan Header";
        PlanLine: Record "Plan Line Sub";
        SumQ: Decimal;
        SalesD: Integer;
        CKA: Integer;
    begin
        PlanH.Reset();
        PlanH.SetRange("Plan Name", PlanName);
        if PlanH.Find('-') then;
        StartDate := 0D;
        if PlanH."Plan Year".AsInteger() > 0 then begin
            StartDate := DMY2Date(1, PlanH."Plan Month".AsInteger(), PlanH."Plan Year".AsInteger());
            EndDate := CalcDate('<CM>', StartDate);
        end;
        updateclear(PlanName);
        PlanLine.Reset();
        PlanLine.SetRange("ref. Plan Name", PlanName);
        PlanLine.SetRange("Type Item", PlanLine."Type Item"::Delivery);
        PlanLine.SetRange("Report Type", PlanLine."Report Type"::Sales);
        if PlanLine.Find('-') then begin
            repeat
                SumQ := 0;
                CKA := 0;
                SaleL.Reset();
                SaleL.SetRange("Item Reference No.", PlanLine."Part No.");
                SaleL.SetRange("Document Type", SaleL."Document Type"::Order);
                SaleL.SetFilter("Planned Delivery Date", '%1..%2', StartDate, EndDate);
                if SaleL.Find('-') then begin
                    repeat
                        CKA += 1;
                        SalesD := Date2DMY(SaleL."Planned Delivery Date", 1);
                        updateDayS(PlanLine, PlanLine."Part No.", SaleL.Quantity, SalesD);
                        PlanLine.Sumtotal();
                        PlanLine.Modify();
                    until SaleL.Next = 0;
                end;
                //// Item Cross Ref.. ////
                if CKA <= 0 then begin
                    SaleL.Reset();
                    SaleL.SetRange("No.", PlanLine."Part No.");
                    SaleL.SetRange("Document Type", SaleL."Document Type"::Order);
                    SaleL.SetFilter("Planned Delivery Date", '%1..%2', StartDate, EndDate);
                    if SaleL.Find('-') then begin
                        repeat
                            CKA += 1;
                            SalesD := Date2DMY(SaleL."Planned Delivery Date", 1);
                            updateDayS(PlanLine, PlanLine."Part No.", SaleL.Quantity, SalesD);
                            PlanLine.Sumtotal();
                            PlanLine.Modify();
                        until SaleL.Next = 0;
                    end;
                end;


            until PlanLine.Next = 0;
        end;
    end;

    procedure updateclear(DocNo: Code[50])
    var
        PlanLine: Record "Plan Line Sub";
    begin
        PlanLine.Reset();
        PlanLine.SetRange("ref. Plan Name", DocNo);
        PlanLine.SetRange("Type Item", PlanLine."Type Item"::Delivery);
        PlanLine.SetRange("Report Type", PlanLine."Report Type"::Sales);
        if PlanLine.Find('-') then begin
            repeat
                PlanLine.Day1 := 0;
                PlanLine.Day2 := 0;
                PlanLine.Day3 := 0;
                PlanLine.Day4 := 0;
                PlanLine.Day5 := 0;
                PlanLine.Day6 := 0;
                PlanLine.Day7 := 0;
                PlanLine.Day8 := 0;
                PlanLine.Day9 := 0;
                PlanLine.Day10 := 0;

                PlanLine.Day11 := 0;
                PlanLine.Day12 := 0;
                PlanLine.Day13 := 0;
                PlanLine.Day14 := 0;
                PlanLine.Day15 := 0;
                PlanLine.Day16 := 0;
                PlanLine.Day17 := 0;
                PlanLine.Day18 := 0;
                PlanLine.Day19 := 0;
                PlanLine.Day20 := 0;

                PlanLine.Day21 := 0;
                PlanLine.Day22 := 0;
                PlanLine.Day23 := 0;
                PlanLine.Day24 := 0;
                PlanLine.Day25 := 0;
                PlanLine.Day26 := 0;
                PlanLine.Day27 := 0;
                PlanLine.Day28 := 0;
                PlanLine.Day29 := 0;
                PlanLine.Day30 := 0;
                PlanLine.Validate(day31, 0);
                PlanLine.Total := 0;
                PlanLine.Modify();

            until PlanLine.Next = 0;
        end;

    end;

    procedure updateDayS(var PlanLine: Record "Plan Line Sub"; PartNo: Code[30]; SumQ: Decimal; DayS: Integer)
    begin
        case DayS of
            1:
                PlanLine.Day1 += SumQ;
            2:
                PlanLine.Day2 += SumQ;
            3:
                PlanLine.Day3 += SumQ;
            4:
                PlanLine.Day4 += SumQ;
            5:
                PlanLine.Day5 += SumQ;
            6:
                PlanLine.Day6 += SumQ;
            7:
                PlanLine.Day7 += SumQ;
            8:
                PlanLine.Day8 += SumQ;
            9:
                PlanLine.Day9 += SumQ;
            10:
                PlanLine.Day10 += SumQ;
            11:
                PlanLine.Day11 += SumQ;
            12:
                PlanLine.Day12 += SumQ;
            13:
                PlanLine.Day13 += SumQ;
            14:
                PlanLine.Day14 += SumQ;
            15:
                PlanLine.Day15 += SumQ;
            16:
                PlanLine.Day16 += SumQ;
            17:
                PlanLine.Day17 += SumQ;
            18:
                PlanLine.Day18 += SumQ;
            19:
                PlanLine.Day19 += SumQ;
            20:
                PlanLine.Day20 += SumQ;
            21:
                PlanLine.Day21 += SumQ;
            22:
                PlanLine.Day22 += SumQ;
            23:
                PlanLine.Day23 += SumQ;
            24:
                PlanLine.Day24 += SumQ;
            25:
                PlanLine.Day25 += SumQ;
            26:
                PlanLine.Day26 += SumQ;
            27:
                PlanLine.Day27 += SumQ;
            28:
                PlanLine.Validate(Day28, PlanLine.Day28 + SumQ);
            29:
                PlanLine.Validate(Day29, PlanLine.Day29 + SumQ);
            30:
                PlanLine.Validate(Day30, PlanLine.Day30 + SumQ);
            31:
                PlanLine.Validate(Day31, PlanLine.Day31 + SumQ);

        end;
    end;

    procedure getDate(DocNo: Code[30]): Date
    var
        PlanH: Record "Plan Header";
        StartDate: Date;
        EndDate: Date;
    begin
        PlanH.Reset();
        PlanH.SetRange("Plan Name", DocNo);
        if PlanH.Find('-') then;
        StartDate := 0D;
        if PlanH."Plan Year".AsInteger() > 0 then begin
            StartDate := DMY2Date(1, PlanH."Plan Month".AsInteger(), PlanH."Plan Year".AsInteger());
            EndDate := CalcDate('<CM>', StartDate);
        end;
        exit(StartDate);
    end;

    procedure DeletebyUser(sUser: Code[100])
    var
        PlanEn: Record "Plan Report";
    begin
        PlanEn.Reset();
        PlanEn.SetRange(sUser, sUser);
        if PlanEn.Find('-') then
            PlanEn.DeleteAll();
    end;

    procedure CalSalesOrder(DDate: Date; PartNo: Code[30]): Decimal
    var
        RT: Decimal;
        SaleL: Record "Sales Line";
        SumQ: Decimal;
        CKA: Integer;
    begin
        RT := 0;
        SumQ := 0;
        CKA := 0;
        SaleL.Reset();
        SaleL.SetRange("Item Reference No.", PartNo);
        SaleL.SetRange("Document Type", SaleL."Document Type"::Order);
        SaleL.SetRange("Planned Delivery Date", DDate);
        if SaleL.Find('-') then begin
            repeat
                CKA += 1;
                RT += SaleL."Quantity Shipped";
            until SaleL.Next = 0;
        end;
        //// Item Cross Ref.. ////
        if CKA <= 0 then begin
            SaleL.Reset();
            SaleL.SetRange("No.", PartNo);
            SaleL.SetRange("Document Type", SaleL."Document Type"::Order);
            SaleL.SetRange("Planned Delivery Date", DDate);
            if SaleL.Find('-') then begin
                repeat
                    CKA += 1;
                    RT += SaleL."Quantity Shipped";
                until SaleL.Next = 0;
            end;
        end;

        exit(RT);
    end;

    procedure FindShipment(var PlanR: Record "Plan Report")
    var

        PlanH: Record "Plan Header";
        StartDate: Date;
        EndDate: Date;
        CKDate: Date;
        PartNo: Code[50];
    begin
        PlanH.Reset();
        PlanH.SetRange("Plan Name", PlanR."ref. Plan Name");
        if PlanH.Find('-') then;
        StartDate := 0D;
        if PlanH."Plan Year".AsInteger() > 0 then begin
            StartDate := DMY2Date(1, PlanH."Plan Month".AsInteger(), PlanH."Plan Year".AsInteger());
            EndDate := CalcDate('<CM>', StartDate);
        end;
        PartNo := PlanR."Part No.";
        PlanR.Total := 0;
        PlanR.Day1 := CalSalesOrder(StartDate, PartNo);
        PlanR.Day2 := CalSalesOrder(CalcDate('<+1D>', StartDate), PartNo);
        PlanR.Day3 := CalSalesOrder(CalcDate('<+2D>', StartDate), PartNo);
        PlanR.Day4 := CalSalesOrder(CalcDate('<+3D>', StartDate), PartNo);
        PlanR.Day5 := CalSalesOrder(CalcDate('<+4D>', StartDate), PartNo);
        PlanR.Day6 := CalSalesOrder(CalcDate('<+5D>', StartDate), PartNo);
        PlanR.Day7 := CalSalesOrder(CalcDate('<+6D>', StartDate), PartNo);
        PlanR.Day8 := CalSalesOrder(CalcDate('<+7D>', StartDate), PartNo);
        PlanR.Day9 := CalSalesOrder(CalcDate('<+8D>', StartDate), PartNo);
        PlanR.Day10 := CalSalesOrder(CalcDate('<+9D>', StartDate), PartNo);

        PlanR.Day11 := CalSalesOrder(CalcDate('<+10D>', StartDate), PartNo);
        PlanR.Day12 := CalSalesOrder(CalcDate('<+11D>', StartDate), PartNo);
        PlanR.Day13 := CalSalesOrder(CalcDate('<+12D>', StartDate), PartNo);
        PlanR.Day14 := CalSalesOrder(CalcDate('<+13D>', StartDate), PartNo);
        PlanR.Day15 := CalSalesOrder(CalcDate('<+14D>', StartDate), PartNo);
        PlanR.Day16 := CalSalesOrder(CalcDate('<+15D>', StartDate), PartNo);
        PlanR.Day17 := CalSalesOrder(CalcDate('<+16D>', StartDate), PartNo);
        PlanR.Day18 := CalSalesOrder(CalcDate('<+17D>', StartDate), PartNo);
        PlanR.Day19 := CalSalesOrder(CalcDate('<+18D>', StartDate), PartNo);
        PlanR.Day20 := CalSalesOrder(CalcDate('<+19D>', StartDate), PartNo);

        PlanR.Day21 := CalSalesOrder(CalcDate('<+20D>', StartDate), PartNo);
        PlanR.Day22 := CalSalesOrder(CalcDate('<+21D>', StartDate), PartNo);
        PlanR.Day23 := CalSalesOrder(CalcDate('<+22D>', StartDate), PartNo);
        PlanR.Day24 := CalSalesOrder(CalcDate('<+23D>', StartDate), PartNo);
        PlanR.Day25 := CalSalesOrder(CalcDate('<+24D>', StartDate), PartNo);
        PlanR.Day26 := CalSalesOrder(CalcDate('<+25D>', StartDate), PartNo);
        PlanR.Day27 := CalSalesOrder(CalcDate('<+26D>', StartDate), PartNo);
        PlanR.Validate(Day28, CalSalesOrder(CalcDate('<+27D>', StartDate), PartNo));

        PlanR.Day29 := 0;
        PlanR.Day30 := 0;
        PlanR.Validate(Day31, 0);


        if CalcDate('<+28D>', StartDate) <= EndDate then
            PlanR.Validate(Day29, CalSalesOrder(CalcDate('<+28D>', StartDate), PartNo));
        if CalcDate('<+29D>', StartDate) <= EndDate then
            PlanR.Validate(Day30, CalSalesOrder(CalcDate('<+29D>', StartDate), PartNo));
        if CalcDate('<+30D>', StartDate) <= EndDate then
            PlanR.Validate(Day31, CalSalesOrder(CalcDate('<+30D>', StartDate), PartNo));
        PlanR.Validate(Day32, 0);
        PlanR.Sumtotal();
        PlanR.Modify();
    end;

    procedure CreateLineReportSales(PlanH: Record "Plan Header")
    var
        PlanL: Record "Plan Line Sub";
        PlanT: Record "Plan Line Sub" temporary;
    begin
        //Delete on Table Report
        //DeletebyUser(UserId);
        //Update Delivery from Sales Order Line
        UpdatePlanLine(PlanH."Plan Name");
        //Insert Data into Report
        PlanL.Reset();
        PlanL.SetCurrentKey(Seq, "Part No.");
        PlanL.SetRange("Report Type", PlanL."Report Type"::Sales);
        PlanL.SetRange("ref. Plan Name", PlanH."Plan Name");
        if PlanL.Find('-') then begin
            repeat
                ////Insert 2 Step//
                //Step 1 //// Insert Delivery Plan from Sales Order//
                // PlanT.Reset();
                // PlanT.DeleteAll();
                // Clear(PlanT);
                // PlanT.Copy(PlanL);
                InsertStep1(PlanL, 1, 'S');
                InsertStep1(PlanL, 2, 'S');
            until PlanL.Next = 0;
        end;
    end;

    procedure CreateLineReportWashing(PlanH: Record "Plan Header")
    var
        PlanL: Record "Plan Line Sub";
        PlanL2: Record "Plan Line Sub";
        PlanT: Record "Plan Line Sub" temporary;
        Seq1: Integer;
    begin

        Seq1 := 0;
        PlanL.Reset();
        PlanL.SetCurrentKey(Seq, "Part No.");
        PlanL.SetRange("Report Type", PlanL."Report Type"::Supplier);
        PlanL.SetRange("Type Item", PlanL."Type Item"::Receive);
        PlanL.SetRange("ref. Plan Name", PlanH."Plan Name");
        if PlanL.Find('-') then begin
            repeat
                Seq1 := 0;
                PlanL2.Reset();
                PlanL2.SetCurrentKey(Seq, "Part No.");
                PlanL2.SetRange("Report Type", PlanL2."Report Type"::Supplier);
                PlanL2.SetRange("ref. Plan Name", PlanH."Plan Name");
                PlanL2.SetRange("Part No.", PlanL."Part No.");
                if PlanL2.Find('-') then begin
                    repeat
                        Seq1 += 1;
                        // PlanT.Reset();
                        // PlanT.DeleteAll();
                        // Clear(PlanT);
                        // PlanT.Init();
                        // PlanT.TransferFields(PlanL2);
                        // PlanT.Insert();

                        if Seq1 = 1 then begin
                            InsertStep1(PlanL2, 1, 'W');
                            InsertStep1(PlanL2, 2, 'W');
                            InsertStep1(PlanL2, 3, 'W');
                        end;
                        if PlanL2."Type Item" = PlanL2."Type Item"::Delivery then
                            InsertStep1(PlanL2, 4, 'W');
                        if PlanL2."Type Item" = PlanL2."Type Item"::Receive then
                            InsertStep1(PlanL2, 5, 'W');

                    until PlanL2.Next = 0;
                end;


            until PlanL.Next = 0;
        end;
    end;

    procedure InsertStep1(PlanL: Record "Plan Line Sub"; Step: Integer; ty: Code[10])
    var
        Seq: Integer;
        PlanReport: Record "Plan Report";
    begin
        PlanReport.Init();
        PlanReport."ref. Plan Name" := PlanL."ref. Plan Name";
        PlanReport.GroupA := PlanL."Part No.";
        if Step = 1 then
            PlanReport.GroupB := 'Delivery';
        if Step = 2 then
            PlanReport.GroupB := 'Receive';
        if Step = 3 then
            PlanReport.GroupB := 'NG';
        if Step = 4 then
            PlanReport.GroupB := 'Plan Delivery';
        if Step = 5 then
            PlanReport.GroupB := 'Plan Receive';
        if (Step = 2) and (ty = 'S') then
            PlanReport.GroupB := 'Actual';


        PlanReport.RowNo := 1;
        PlanReport."Ref. Ven" := ty;
        PlanReport.sUser := UserId;
        PlanReport.Seq := Step;
        PlanReport."Part No." := PlanL."Part No.";
        PlanReport."Part Name" := PlanL."Part Name";
        PlanReport.Model := PlanL.Model;
        PlanReport."Report Type" := PlanL."Report Type";
        PlanReport."Type Item" := PlanL."Type Item";
        PlanReport.Section := PlanL.Section;
        ///Insert Days//
        PlanReport.Day1 := PlanL.Day1;
        PlanReport.Day2 := PlanL.Day2;
        PlanReport.Day3 := PlanL.Day3;
        PlanReport.Day4 := PlanL.Day4;
        PlanReport.Day5 := PlanL.Day5;
        PlanReport.Day6 := PlanL.Day6;
        PlanReport.Day7 := PlanL.Day7;
        PlanReport.Day8 := PlanL.Day8;
        PlanReport.Day9 := PlanL.Day9;
        PlanReport.Day10 := PlanL.Day10;

        PlanReport.Day11 := PlanL.Day11;
        PlanReport.Day12 := PlanL.Day12;
        PlanReport.Day13 := PlanL.Day13;
        PlanReport.Day14 := PlanL.Day14;
        PlanReport.Day15 := PlanL.Day15;
        PlanReport.Day16 := PlanL.Day16;
        PlanReport.Day17 := PlanL.Day17;
        PlanReport.Day18 := PlanL.Day18;
        PlanReport.Day19 := PlanL.Day19;
        PlanReport.Day20 := PlanL.Day20;

        PlanReport.Day21 := PlanL.Day21;
        PlanReport.Day22 := PlanL.Day22;
        PlanReport.Day23 := PlanL.Day23;
        PlanReport.Day24 := PlanL.Day24;
        PlanReport.Day25 := PlanL.Day25;
        PlanReport.Day26 := PlanL.Day26;
        PlanReport.Day27 := PlanL.Day27;
        PlanReport.Validate(day28, PlanL.day28);
        PlanReport.Validate(day29, PlanL.day29);
        PlanReport.Validate(day30, PlanL.day30);
        PlanReport.Validate(day31, PlanL.day31);
        PlanReport.Total := PlanReport.Total;

        /////
        PlanReport.Insert();
        if (Step = 2) and (ty = 'S') then
            FindShipment(PlanReport);
        if (ty = 'W') then begin
            if (Step = 1) or (Step = 2) or (Step = 3) then
                FindWashing(PlanReport, Step);
        end;

    end;

    procedure FindWashing(var PlanR: Record "Plan Report"; ac: Integer)
    var
        PlanH: Record "Plan Header";
        StartDate: Date;
        EndDate: Date;
        CKDate: Date;
        PartNo: Code[50];
    begin
        PlanH.Reset();
        PlanH.SetRange("Plan Name", PlanR."ref. Plan Name");
        if PlanH.Find('-') then;
        StartDate := 0D;
        if PlanH."Plan Year".AsInteger() > 0 then begin
            StartDate := DMY2Date(1, PlanH."Plan Month".AsInteger(), PlanH."Plan Year".AsInteger());
            EndDate := CalcDate('<CM>', StartDate);
        end;

        PartNo := PlanR."Part No.";
        PlanR.Total := 0;
        PlanR.Day1 := CalWashing(StartDate, PartNo, ac);
        PlanR.Day2 := CalWashing(CalcDate('<+1D>', StartDate), PartNo, ac);
        PlanR.Day3 := CalWashing(CalcDate('<+2D>', StartDate), PartNo, ac);
        PlanR.Day4 := CalWashing(CalcDate('<+3D>', StartDate), PartNo, ac);
        PlanR.Day5 := CalWashing(CalcDate('<+4D>', StartDate), PartNo, ac);
        PlanR.Day6 := CalWashing(CalcDate('<+5D>', StartDate), PartNo, ac);
        PlanR.Day7 := CalWashing(CalcDate('<+6D>', StartDate), PartNo, ac);
        PlanR.Day8 := CalWashing(CalcDate('<+7D>', StartDate), PartNo, ac);
        PlanR.Day9 := CalWashing(CalcDate('<+8D>', StartDate), PartNo, ac);
        PlanR.Day10 := CalWashing(CalcDate('<+9D>', StartDate), PartNo, ac);

        PlanR.Day11 := CalWashing(CalcDate('<+10D>', StartDate), PartNo, ac);
        PlanR.Day12 := CalWashing(CalcDate('<+11D>', StartDate), PartNo, ac);
        PlanR.Day13 := CalWashing(CalcDate('<+12D>', StartDate), PartNo, ac);
        PlanR.Day14 := CalWashing(CalcDate('<+13D>', StartDate), PartNo, ac);
        PlanR.Day15 := CalWashing(CalcDate('<+14D>', StartDate), PartNo, ac);
        PlanR.Day16 := CalWashing(CalcDate('<+15D>', StartDate), PartNo, ac);
        PlanR.Day17 := CalWashing(CalcDate('<+16D>', StartDate), PartNo, ac);
        PlanR.Day18 := CalWashing(CalcDate('<+17D>', StartDate), PartNo, ac);
        PlanR.Day19 := CalWashing(CalcDate('<+18D>', StartDate), PartNo, ac);
        PlanR.Day20 := CalWashing(CalcDate('<+19D>', StartDate), PartNo, ac);

        PlanR.Day21 := CalWashing(CalcDate('<+20D>', StartDate), PartNo, ac);
        PlanR.Day22 := CalWashing(CalcDate('<+21D>', StartDate), PartNo, ac);
        PlanR.Day23 := CalWashing(CalcDate('<+22D>', StartDate), PartNo, ac);
        PlanR.Day24 := CalWashing(CalcDate('<+23D>', StartDate), PartNo, ac);
        PlanR.Day25 := CalWashing(CalcDate('<+24D>', StartDate), PartNo, ac);
        PlanR.Day26 := CalWashing(CalcDate('<+25D>', StartDate), PartNo, ac);
        PlanR.Day27 := CalWashing(CalcDate('<+26D>', StartDate), PartNo, ac);
        PlanR.Validate(Day28, CalWashing(CalcDate('<+27D>', StartDate), PartNo, ac));

        PlanR.Day29 := 0;
        PlanR.Day30 := 0;
        PlanR.Validate(Day31, 0);

        if CalcDate('<+28D>', StartDate) <= EndDate then
            PlanR.Validate(Day29, CalWashing(CalcDate('<+28D>', StartDate), PartNo, ac));
        if CalcDate('<+29D>', StartDate) <= EndDate then
            PlanR.Validate(Day30, CalWashing(CalcDate('<+29D>', StartDate), PartNo, ac));
        if CalcDate('<+30D>', StartDate) <= EndDate then
            PlanR.Validate(Day31, CalWashing(CalcDate('<+30D>', StartDate), PartNo, ac));

        PlanR.Validate(Day32, 0);
        PlanR.Sumtotal();
        PlanR.Modify();
    end;

    procedure CalWashing(DDate: Date; PartNo: Code[30]; ac: Integer): Decimal
    var
        RT: Decimal;
        TempH: Record "Temporary DL Req.";
        TempL: Record "Temporary DL Req. Line";
        TempRH: Record "Temp. Receipt Header";
        TempRL: Record "Temp. Receipt Line";
        SumQ: Decimal;
        CKA: Integer;
    begin
        RT := 0;
        SumQ := 0;
        CKA := 0;

        if ac = 1 then begin

            TempH.Reset();
            TempH.SetRange(DateShiped, DDate);
            TempH.SetRange("Fix TempDL", false);
            if TempH.Find('-') then begin
                repeat
                    TempL.Reset();
                    TempL.SetRange("Document No.", TempH.DLNo);
                    TempL.SetRange("Cut from Stock", true);
                    TempL.SetRange("Part No.", PartNo);
                    if TempL.Find('-') then begin
                        repeat
                            SumQ += TempL.Quantity;
                        until TempL.Next = 0;
                    end;
                until TempH.Next = 0;
            end;
            RT := SumQ;
        end;
        if ac = 2 then begin
            TempRH.Reset();
            TempRH.SetRange("Receipt Date", DDate);
            TempRH.SetRange(Status, TempRH.Status::Completed);
            if TempRH.Find('-') then begin
                repeat
                    TempRL.Reset();
                    TempRL.SetRange("Part No.", PartNo);
                    TempRL.SetRange("Document No.", TempRH."Receipt No.");
                    if TempRL.Find('-') then begin
                        repeat
                            SumQ += TempRL.Quantity;
                        until TempRL.Next = 0;
                    end;
                until TempRH.Next = 0;
            end;
            RT := SumQ;
        end;

        if ac = 3 then begin
            TempRH.Reset();
            TempRH.SetRange("Receipt Date", DDate);
            TempRH.SetRange(Status, TempRH.Status::Completed);
            if TempRH.Find('-') then begin
                repeat
                    TempRL.Reset();
                    TempRL.SetRange("Part No.", PartNo);
                    TempRL.SetRange("Document No.", TempRH."Receipt No.");
                    if TempRL.Find('-') then begin
                        repeat
                            SumQ += TempRL.NGQ;
                        until TempRL.Next = 0;
                    end;
                until TempRH.Next = 0;
            end;
            RT := SumQ;
        end;


        exit(RT);
    end;

    procedure CreateLineProduction(PlanH: Record "Plan Header"; SelectPart: Code[50])
    var
        PlanL: Record "Plan Line Sub";
        PlanL2: Record "Plan Line Sub";
        Seq1: Integer;
        ProD: Record "Production Record Header";
        ProDL: Record "Production Record Line";
        ProRP: Record "Plan Report";
        StartDate: Date;
        EndDate: Date;
        Rows1: Integer;
        Rows2: Integer;
    begin

        StartDate := 0D;
        if PlanH."Plan Year".AsInteger() > 0 then begin
            StartDate := DMY2Date(1, PlanH."Plan Month".AsInteger(), PlanH."Plan Year".AsInteger());
            EndDate := CalcDate('<CM>', StartDate);
        end;

        Seq1 := 0;
        Rows1 := 0;
        Rows2 := 0;
        PlanL.Reset();
        PlanL.SetCurrentKey(Seq, "Part No.");
        PlanL.SetRange("Report Type", PlanL."Report Type"::Factory);
        PlanL.SetRange("Type Item", PlanL."Type Item"::Production);
        PlanL.SetRange("ref. Plan Name", PlanH."Plan Name");
        PlanL.SetRange("Part No.", SelectPart);
        if PlanL.Find('-') then begin
            repeat
                Seq1 := 0;
                PlanL2.Reset();
                PlanL2.SetCurrentKey(Seq, "Part No.");
                PlanL2.SetRange("Report Type", PlanL2."Report Type"::Factory);
                PlanL2.SetRange("ref. Plan Name", PlanH."Plan Name");
                PlanL2.SetRange("Part No.", PlanL."Part No.");
                if PlanL2.Find('-') then begin
                    repeat
                        Seq1 += 1;
                        if Seq1 = 1 then begin
                            ProD.Reset();
                            ProD.SetRange("Req. Date", StartDate, EndDate);
                            ProD.SetRange(Status, ProD.Status::Completed);
                            if ProD.Find('-') then begin
                                repeat
                                    ProDL.Reset();
                                    ProDL.SetRange("Part No.", SelectPart);
                                    ProDL.SetRange("Document No.", ProD."Req. No.");
                                    if ProDL.Find('-') then begin
                                        repeat
                                            ProRP.Reset();
                                            ProRP.SetRange(sUser, UserId);
                                            ProRP.SetRange(GroupA, PlanL2."Part No.");
                                            ProRP.SetRange("Ref. Ven", 'MACHINE');
                                            ProRP.SetRange(Machine, ProDL."Machine No.");
                                            if NOT ProRP.Find('-') then begin
                                                //Add 2 Row
                                                Rows1 += 1;
                                                Rows2 += 1;
                                                InsertStep2(PlanL2, 1, 'MACHINE', ProDL."Machine No.", Rows1);
                                                InsertStep2(PlanL2, 2, 'MACHINE', ProDL."Machine No.", Rows2);
                                            end;
                                        until ProDL.Next = 0;
                                    end;
                                until ProD.Next = 0;
                            end;
                            InsertStep2(PlanL2, 3, 'CHECK', '', 1);
                            InsertStep2(PlanL2, 4, 'CHECK', '', 2);
                            InsertStep2(PlanL2, 5, 'CHECK', '', 3);
                            InsertStep2(PlanL2, 6, 'CHECK', '', 4);

                        end;
                    until PlanL2.Next = 0;
                end;
            until PlanL.Next = 0;
        end;

    end;

    procedure InsertStep2(PlanL: Record "Plan Line Sub"; Step: Integer; ty: Code[10]; MCNo: Code[30]; Row: Integer)
    var
        Seq: Integer;
        PlanReport: Record "Plan Report";
    begin
        PlanReport.Init();
        PlanReport."ref. Plan Name" := PlanL."ref. Plan Name";
        PlanReport.GroupA := PlanL."Part No.";
        PlanReport.GroupB := 'Actual';

        if (Step = 3) and (ty = 'CHECK') then
            PlanReport.GroupB := 'Daily Target';
        if (Step = 4) and (ty = 'CHECK') then
            PlanReport.GroupB := 'Target Total';
        if (Step = 5) and (ty = 'CHECK') then
            PlanReport.GroupB := 'Production Qty Total';
        if (Step = 6) and (ty = 'CHECK') then
            PlanReport.GroupB := 'Balance';

        if (Step = 2) and (ty = 'MACHINE') then
            PlanReport.GroupB := 'NG Qty';

        if (Step = 1) and (ty = 'MACHINE') then
            PlanReport.GroupB := 'Prod. Qty';

        PlanReport.RowNo := Row;
        PlanReport."Ref. Ven" := ty;
        PlanReport.Machine := MCNo;
        PlanReport.sUser := UserId;
        PlanReport.Seq := Step;
        PlanReport."Part No." := PlanL."Part No.";
        PlanReport."Part Name" := PlanL."Part Name";
        PlanReport.Model := PlanL.Model;
        PlanReport."Report Type" := PlanL."Report Type";
        PlanReport."Type Item" := PlanL."Type Item";
        PlanReport.Section := PlanL.Section;
        ///Insert Days//
        PlanReport.Day1 := 0;
        PlanReport.Day2 := 0;
        PlanReport.Day3 := 0;
        PlanReport.Day4 := 0;
        PlanReport.Day5 := 0;
        PlanReport.Day6 := 0;
        PlanReport.Day7 := 0;
        PlanReport.Day8 := 0;
        PlanReport.Day9 := 0;
        PlanReport.Day10 := 0;

        PlanReport.Day11 := 0;
        PlanReport.Day12 := 0;
        PlanReport.Day13 := 0;
        PlanReport.Day14 := 0;
        PlanReport.Day15 := 0;
        PlanReport.Day16 := 0;
        PlanReport.Day17 := 0;
        PlanReport.Day18 := 0;
        PlanReport.Day19 := 0;
        PlanReport.Day20 := 0;

        PlanReport.Day21 := 0;
        PlanReport.Day22 := 0;
        PlanReport.Day23 := 0;
        PlanReport.Day24 := 0;
        PlanReport.Day25 := 0;
        PlanReport.Day26 := 0;
        PlanReport.Day27 := 0;
        PlanReport.Validate(day28, 0);
        PlanReport.Validate(day29, 0);
        PlanReport.Validate(day30, 0);
        PlanReport.Validate(day31, 0);
        PlanReport.Total := 0;
        //////////////////////////////////////
        PlanReport.Insert();
        FindTraget(PlanReport);
        // if (Step = 4) and (ty = 'CHECK') then
        //     FindTraget(PlanReport);
        // if (Step = 1) and (ty = 'MACHINE') then begin
        //     //OK
        //     FindTraget(PlanReport);
        // end;
        // if (Step = 3) and (ty = 'MACHINE') then begin
        //     //NG
        //     FindTraget(PlanReport);
        // end;
        //////////////////////////////////////

    end;

    procedure FindTraget(var PlanR: Record "Plan Report")
    var
        PlanH: Record "Plan Header";
        StartDate: Date;
        EndDate: Date;
        CKDate: Date;
        PartNo: Code[50];
        TotalS: Decimal;
    begin
        PlanH.Reset();
        PlanH.SetRange("Plan Name", PlanR."ref. Plan Name");
        if PlanH.Find('-') then;
        StartDate := 0D;
        if PlanH."Plan Year".AsInteger() > 0 then begin
            StartDate := DMY2Date(1, PlanH."Plan Month".AsInteger(), PlanH."Plan Year".AsInteger());
            EndDate := CalcDate('<CM>', StartDate);
        end;
        PartNo := PlanR."Part No.";
        TotalS := 0;
        TotalS := getarget(StartDate, PartNo, TotalS, PlanR);
        PlanR.Total := 0;
        PlanR.Day1 := TotalS;
        PlanR.Day2 := getarget(CalcDate('<+1D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day3 := getarget(CalcDate('<+2D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day4 := getarget(CalcDate('<+3D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day5 := getarget(CalcDate('<+4D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day6 := getarget(CalcDate('<+5D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day7 := getarget(CalcDate('<+6D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day8 := getarget(CalcDate('<+7D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day9 := getarget(CalcDate('<+8D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day10 := getarget(CalcDate('<+9D>', StartDate), PartNo, TotalS, PlanR);

        PlanR.Day11 := getarget(CalcDate('<+10D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day12 := getarget(CalcDate('<+11D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day13 := getarget(CalcDate('<+12D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day14 := getarget(CalcDate('<+13D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day15 := getarget(CalcDate('<+14D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day16 := getarget(CalcDate('<+15D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day17 := getarget(CalcDate('<+16D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day18 := getarget(CalcDate('<+17D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day19 := getarget(CalcDate('<+18D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day20 := getarget(CalcDate('<+19D>', StartDate), PartNo, TotalS, PlanR);

        PlanR.Day21 := getarget(CalcDate('<+20D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day22 := getarget(CalcDate('<+21D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day23 := getarget(CalcDate('<+22D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day24 := getarget(CalcDate('<+23D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day25 := getarget(CalcDate('<+24D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day26 := getarget(CalcDate('<+25D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Day27 := getarget(CalcDate('<+26D>', StartDate), PartNo, TotalS, PlanR);
        PlanR.Validate(Day28, getarget(CalcDate('<+27D>', StartDate), PartNo, TotalS, PlanR));

        PlanR.Day29 := 0;
        PlanR.Day30 := 0;
        PlanR.Validate(Day31, 0);

        if CalcDate('<+28D>', StartDate) <= EndDate then
            PlanR.Validate(Day29, getarget(CalcDate('<+28D>', StartDate), PartNo, TotalS, PlanR));
        if CalcDate('<+29D>', StartDate) <= EndDate then
            PlanR.Validate(Day30, getarget(CalcDate('<+29D>', StartDate), PartNo, TotalS, PlanR));
        if CalcDate('<+30D>', StartDate) <= EndDate then
            PlanR.Validate(Day31, getarget(CalcDate('<+30D>', StartDate), PartNo, TotalS, PlanR));
        PlanR.Validate(Day32, 0);
        PlanR.Sumtotal();
        PlanR.Modify();
    end;

    procedure getarget(DDate: Date; PartNo: Code[30]; var TotalS: Decimal; PlanR: Record "Plan Report"): Decimal
    var
        RT: Decimal;
    begin
        RT := 0;
        if (PlanR."Ref. Ven" = 'CHECK') and (PlanR.Seq = 3) then begin
            TotalS := 0;
            RT := getargetTotal1(DDate, PartNo, TotalS, PlanR);
        end;
        if (PlanR."Ref. Ven" = 'CHECK') and (PlanR.Seq = 4) then begin
            RT := getargetTotal1(DDate, PartNo, TotalS, PlanR);
        end;

        if (PlanR."Ref. Ven" = 'MACHINE') and (PlanR.Seq = 1) then begin
            RT := getProdRec(DDate, PartNo, TotalS, PlanR);
        end;
        if (PlanR."Ref. Ven" = 'MACHINE') and (PlanR.Seq = 2) then begin
            RT := getProdRec(DDate, PartNo, TotalS, PlanR);
        end;

        if (PlanR."Ref. Ven" = 'CHECK') and (PlanR.Seq = 5) then begin
            RT := getSumProD(DDate, PartNo, TotalS, PlanR);
        end;
        if (PlanR."Ref. Ven" = 'CHECK') and (PlanR.Seq = 6) then begin
            TotalS := 0;
            RT := getSumProDBalance5(DDate, PartNo, TotalS, PlanR);
        end;

        exit(RT);
    end;

    procedure getargetTotal1(DDate: Date; PartNo: Code[30]; var TotalS: Decimal; PlanR: Record "Plan Report"): Decimal
    var
        RT: Decimal;
        PlanL: Record "Plan Line Sub";
        SumT: Decimal;
        DD: Integer;
    begin
        RT := 0;
        SumT := 0;
        //////// TotalS //////
        ////*

        DD := Date2DMY(DDate, 1);
        PlanL.Reset();
        PlanL.SetRange("ref. Plan Name", PlanR."ref. Plan Name");
        PlanL.SetRange("Part No.", PartNo);
        if PlanL.Find('-') then begin
            repeat
                case DD of
                    1:
                        SumT += PlanL.Day1;
                    2:
                        SumT += PlanL.Day2;
                    3:
                        SumT += PlanL.Day3;
                    4:
                        SumT += PlanL.Day4;
                    5:
                        SumT += PlanL.Day5;
                    6:
                        SumT += PlanL.Day6;
                    7:
                        SumT += PlanL.Day7;
                    8:
                        SumT += PlanL.Day8;
                    9:
                        SumT += PlanL.Day9;
                    10:
                        SumT += PlanL.Day10;

                    11:
                        SumT += PlanL.Day11;
                    12:
                        SumT += PlanL.Day12;
                    13:
                        SumT += PlanL.Day13;
                    14:
                        SumT += PlanL.Day14;
                    15:
                        SumT += PlanL.Day15;
                    16:
                        SumT += PlanL.Day16;
                    17:
                        SumT += PlanL.Day17;
                    18:
                        SumT += PlanL.Day18;
                    19:
                        SumT += PlanL.Day19;
                    20:
                        SumT += PlanL.Day20;

                    21:
                        SumT += PlanL.Day21;
                    22:
                        SumT += PlanL.Day22;
                    23:
                        SumT += PlanL.Day23;
                    24:
                        SumT += PlanL.Day24;
                    25:
                        SumT += PlanL.Day25;
                    26:
                        SumT += PlanL.Day26;
                    27:
                        SumT += PlanL.Day27;
                    28:
                        SumT += PlanL.Day28;
                    29:
                        SumT += PlanL.Day29;
                    30:
                        SumT += PlanL.Day30;
                    31:
                        SumT += PlanL.Day31;
                end;
            until PlanL.Next = 0;
        end;
        TotalS := TotalS + SumT;
        ////*
        exit(TotalS);
    end;


    procedure getProdRec(DDate: Date; PartNo: Code[30]; var TotalS: Decimal; PlanR: Record "Plan Report"): Decimal
    var
        RT: Decimal;
        ProL: Record "Production Record Line";
        ProH: Record "Production Record Header";
        SumT: Decimal;
        SumN: Decimal;
        DD: Integer;
    begin
        RT := 0;
        SumT := 0;
        SumN := 0;
        TotalS := 0;
        //////// TotalS //////
        ////*
        DD := Date2DMY(DDate, 1);
        ProH.Reset();
        ProH.SetRange("Req. Date", DDate);
        ProH.SetRange(Status, ProH.Status::Completed);
        if ProH.Find('-') then begin
            repeat
                ProL.Reset();
                ProL.SetRange("Document No.", ProH."Req. No.");
                ProL.SetRange("Machine No.", PlanR.Machine);
                ProL.SetRange("Part No.", PlanR."Part No.");
                if ProL.Find('-') then begin
                    SumT += ProL.Quantity;
                    SumN += ProL."NG Qty";
                end;
            until ProH.Next = 0;
        end;
        if PlanR.Seq = 1 then
            TotalS := SumT;
        if PlanR.Seq = 2 then
            TotalS := SumN;
        ////*
        exit(TotalS);
    end;

    procedure getSumProD(DDate: Date; PartNo: Code[30]; var TotalS: Decimal; PlanR: Record "Plan Report"): Decimal
    var
        RT: Decimal;
        PlanL: Record "Plan Report";
        SumT: Decimal;
        DD: Integer;
    begin
        RT := 0;
        SumT := 0;
        //////// TotalS //////
        ////*

        DD := Date2DMY(DDate, 1);
        PlanL.Reset();
        PlanL.SetRange("ref. Plan Name", PlanR."ref. Plan Name");
        PlanL.SetRange("Part No.", PartNo);
        PlanL.SetFilter(seq, '%1|%2', 1, 2);
        PlanL.SetFilter("Ref. Ven", 'MACHINE');
        if PlanL.Find('-') then begin
            repeat
                case DD of
                    1:
                        SumT += PlanL.Day1;
                    2:
                        SumT += PlanL.Day2;
                    3:
                        SumT += PlanL.Day3;
                    4:
                        SumT += PlanL.Day4;
                    5:
                        SumT += PlanL.Day5;
                    6:
                        SumT += PlanL.Day6;
                    7:
                        SumT += PlanL.Day7;
                    8:
                        SumT += PlanL.Day8;
                    9:
                        SumT += PlanL.Day9;
                    10:
                        SumT += PlanL.Day10;

                    11:
                        SumT += PlanL.Day11;
                    12:
                        SumT += PlanL.Day12;
                    13:
                        SumT += PlanL.Day13;
                    14:
                        SumT += PlanL.Day14;
                    15:
                        SumT += PlanL.Day15;
                    16:
                        SumT += PlanL.Day16;
                    17:
                        SumT += PlanL.Day17;
                    18:
                        SumT += PlanL.Day18;
                    19:
                        SumT += PlanL.Day19;
                    20:
                        SumT += PlanL.Day20;

                    21:
                        SumT += PlanL.Day21;
                    22:
                        SumT += PlanL.Day22;
                    23:
                        SumT += PlanL.Day23;
                    24:
                        SumT += PlanL.Day24;
                    25:
                        SumT += PlanL.Day25;
                    26:
                        SumT += PlanL.Day26;
                    27:
                        SumT += PlanL.Day27;
                    28:
                        SumT += PlanL.Day28;
                    29:
                        SumT += PlanL.Day29;
                    30:
                        SumT += PlanL.Day30;
                    31:
                        SumT += PlanL.Day31;
                end;
            until PlanL.Next = 0;
        end;
        TotalS := TotalS + SumT;
        ////*
        exit(TotalS);
    end;

    procedure getSumProDBalance5(DDate: Date; PartNo: Code[30]; var TotalS: Decimal; PlanR: Record "Plan Report"): Decimal
    var
        RT: Decimal;
        PlanL: Record "Plan Report";
        SumT: Decimal;
        DD: Integer;
    begin
        RT := 0;
        SumT := 0;
        //////// TotalS //////
        ////*
        DD := Date2DMY(DDate, 1);
        PlanL.Reset();
        PlanL.SetRange("ref. Plan Name", PlanR."ref. Plan Name");
        PlanL.SetRange("Part No.", PartNo);
        PlanL.SetFilter(seq, '%1', 5);
        PlanL.SetFilter("Ref. Ven", 'CHECK');
        if PlanL.Find('-') then begin
            repeat
                case DD of
                    1:
                        SumT += PlanL.Day1 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    2:
                        SumT += PlanL.Day2 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    3:
                        SumT += PlanL.Day3 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    4:
                        SumT += PlanL.Day4 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    5:
                        SumT += PlanL.Day5 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    6:
                        SumT += PlanL.Day6 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    7:
                        SumT += PlanL.Day7 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    8:
                        SumT += PlanL.Day8 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    9:
                        SumT += PlanL.Day9 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    10:
                        SumT += PlanL.Day10 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);

                    11:
                        SumT += PlanL.Day11 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    12:
                        SumT += PlanL.Day12 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    13:
                        SumT += PlanL.Day13 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    14:
                        SumT += PlanL.Day14 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    15:
                        SumT += PlanL.Day15 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    16:
                        SumT += PlanL.Day16 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    17:
                        SumT += PlanL.Day17 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    18:
                        SumT += PlanL.Day18 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    19:
                        SumT += PlanL.Day19 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    20:
                        SumT += PlanL.Day20 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);

                    21:
                        SumT += PlanL.Day21 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    22:
                        SumT += PlanL.Day22 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    23:
                        SumT += PlanL.Day23 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    24:
                        SumT += PlanL.Day24 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    25:
                        SumT += PlanL.Day25 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    26:
                        SumT += PlanL.Day26 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    27:
                        SumT += PlanL.Day27 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    28:
                        SumT += PlanL.Day28 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    29:
                        SumT += PlanL.Day29 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    30:
                        SumT += PlanL.Day30 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                    31:
                        SumT += PlanL.Day31 - getSumProDBalance4(DDate, PartNo, TotalS, PlanR);
                end;
            until PlanL.Next = 0;
        end;

        ////*
        exit(SumT);
    end;

    procedure getSumProDBalance4(DDate: Date; PartNo: Code[30]; var TotalS: Decimal; PlanR: Record "Plan Report"): Decimal
    var
        RT: Decimal;
        PlanL: Record "Plan Report";
        SumT: Decimal;
        DD: Integer;
    begin
        RT := 0;
        SumT := 0;
        //////// TotalS //////
        ////*
        DD := Date2DMY(DDate, 1);
        PlanL.Reset();
        PlanL.SetRange("ref. Plan Name", PlanR."ref. Plan Name");
        PlanL.SetRange("Part No.", PartNo);
        PlanL.SetFilter(seq, '%1', 4);
        PlanL.SetFilter("Ref. Ven", 'CHECK');
        if PlanL.Find('-') then begin
            repeat
                case DD of
                    1:
                        SumT += PlanL.Day1;
                    2:
                        SumT += PlanL.Day2;
                    3:
                        SumT += PlanL.Day3;
                    4:
                        SumT += PlanL.Day4;
                    5:
                        SumT += PlanL.Day5;
                    6:
                        SumT += PlanL.Day6;
                    7:
                        SumT += PlanL.Day7;
                    8:
                        SumT += PlanL.Day8;
                    9:
                        SumT += PlanL.Day9;
                    10:
                        SumT += PlanL.Day10;

                    11:
                        SumT += PlanL.Day11;
                    12:
                        SumT += PlanL.Day12;
                    13:
                        SumT += PlanL.Day13;
                    14:
                        SumT += PlanL.Day14;
                    15:
                        SumT += PlanL.Day15;
                    16:
                        SumT += PlanL.Day16;
                    17:
                        SumT += PlanL.Day17;
                    18:
                        SumT += PlanL.Day18;
                    19:
                        SumT += PlanL.Day19;
                    20:
                        SumT += PlanL.Day20;

                    21:
                        SumT += PlanL.Day21;
                    22:
                        SumT += PlanL.Day22;
                    23:
                        SumT += PlanL.Day23;
                    24:
                        SumT += PlanL.Day24;
                    25:
                        SumT += PlanL.Day25;
                    26:
                        SumT += PlanL.Day26;
                    27:
                        SumT += PlanL.Day27;
                    28:
                        SumT += PlanL.Day28;
                    29:
                        SumT += PlanL.Day29;
                    30:
                        SumT += PlanL.Day30;
                    31:
                        SumT += PlanL.Day31;
                end;
            until PlanL.Next = 0;
        end;

        ////*
        exit(SumT);
    end;

    procedure CreateReport(PlanName: Text[50]; PlanPart: Text[50]; var PlanH: Record "Plan Header" temporary; var PlanL: Record "Plan Line Sub" temporary)
    var
        vPlanH: Record "Plan Header";
        vPlanL: Record "Plan Line Sub";
        RSeq: Integer;
    begin
        //ForReport
        vPlanH.Reset();
        vPlanH.SetRange("Plan Name", PlanName);
        if vPlanH.Find('-') then begin

            PlanH.Init();
            PlanH.TransferFields(vPlanH);
            PlanH."Use Report" := 'ForReport';
            PlanH.Insert();

            vPlanL.Reset();
            vPlanL.SetRange("ref. Plan Name", PlanName);
            if vPlanL.Find('-') then begin
                repeat
                    RSeq := vPlanL.Seq;
                    PlanL.Init();
                    PlanL.TransferFields(vPlanL);
                    PlanL."Use Report" := 'ForReport';
                    PlanL.Seq := vPlanL.Seq;
                    PlanL.SeqC := RSeq;
                    PlanL.Insert();
                    //Insert 2//
                    if vPlanL."Report Type" <> vPlanL."Report Type"::Sales then begin
                        if (vPlanL."Type Item" = vPlanL."Type Item"::Receive) and (vPlanL."Report Type" = vPlanL."Report Type"::Factory) then begin
                            //Add Inventory from Stock//
                            PlanL.Init();
                            PlanL."Use Report" := 'ForReport';
                            PlanL."Type Item" := vPlanL."Type Item"::Inventory;
                            PlanL.Seq := vPlanL.Seq + 100;
                            PlanL.SeqC := vPlanL.Seq + 0.1;
                            PlanL."Plan Out Qty" := 99;
                            PlanL.Validate(day31, 0);
                            PlanL.Insert();
                            CreateInvtReport(vPlanH, vPlanL, PlanL, 1);
                        end;

                        if (vPlanL."Type Item" = vPlanL."Type Item"::Receive) and (vPlanL."Report Type" = vPlanL."Report Type"::Supplier) then begin
                            //Add Inventory from Stock//
                            PlanL.Init();
                            PlanL."Use Report" := 'ForReport';
                            PlanL."Type Item" := vPlanL."Type Item"::Inventory;
                            PlanL.Seq := vPlanL.Seq + 100;
                            PlanL.SeqC := vPlanL.Seq + 0.1;
                            PlanL."Plan Out Qty" := 99;
                            PlanL.Validate(day31, 0);
                            PlanL.Insert();
                            CreateInvtReport(vPlanH, vPlanL, PlanL, 2);
                        end;

                        if (vPlanL."Type Item" = vPlanL."Type Item"::Production) and (vPlanL."Report Type" = vPlanL."Report Type"::Factory) then begin
                            //Add Inventory from Stock//
                            PlanL.Init();
                            PlanL."Use Report" := 'ForReport';
                            PlanL."Type Item" := vPlanL."Type Item"::Inventory;
                            PlanL.Seq := vPlanL.Seq + 100;
                            PlanL.SeqC := vPlanL.Seq + 0.1;
                            PlanL."Plan out Qty" := 99;
                            PlanL.Validate(day31, 0);
                            PlanL.Insert();
                            CreateInvtReport(vPlanH, vPlanL, PlanL, 3);
                        end;
                    end;

                until vPlanL.Next = 0;
            end;
        end;
    end;

    procedure CreateInvtReport(vPlanH: Record "Plan Header"; vPlanL: Record "Plan Line Sub"; var PlanL: Record "Plan Line Sub" temporary; Ac: Integer)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        PDate: Date;
        EndDate: Date;
        SumQ: Decimal;
        SumR: Decimal;
        SumOut: Decimal;
        SumTotal: Decimal;
        ItemS: Record Item;
        PartNext: Code[20];
    begin
        SumQ := 0;
        PDate := DMY2Date(1, vPlanH."Plan Month".AsInteger(), vPlanH."Plan Year".AsInteger());
        EndDate := CalcDate('<CM>', PDate);

        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Item No.", PlanL."Part No.");
        ItemLedgerEntry.SetFilter("Location Code", '<>%1&<>%2', 'NG', 'PROCESS');
        ItemLedgerEntry.SetFilter("Posting Date", '..%1', CalcDate('<-1D>', PDate));
        if ItemLedgerEntry.Find('-') then begin
            repeat
                SumQ += ItemLedgerEntry.Quantity;
            until ItemLedgerEntry.Next = 0;
        end;
        PlanL."Plan IN Qty" := SumQ;

        if Ac = 1 then begin
            ItemS.Reset();
            ItemS.SetRange("No.", PlanL."Part No.");
            ItemS.SetFilter("To Material Item", '<>%1', '');
            if ItemS.Find('-') then begin
                PartNext := ItemS."To Material Item";
            end;
            if PartNext <> '' then
                UpdateAction1(PlanL, SumQ, PartNext, PDate, vPlanL, AC);
        end;
        if AC = 2 then begin
            ItemS.Reset();
            ItemS.SetRange("No.", PlanL."Part No.");
            ItemS.SetFilter("To Material Item", '<>%1', '');
            if ItemS.Find('-') then begin
                PartNext := ItemS."To Material Item";
            end;
            if PartNext <> '' then
                UpdateAction1(PlanL, SumQ, PartNext, PDate, vPlanL, AC);
        end;
        if AC = 3 then begin
            ItemS.Reset();
            ItemS.SetRange("No.", PlanL."Part No.");
            ItemS.SetFilter("To Material Item", '<>%1', '');
            if ItemS.Find('-') then begin
                PartNext := ItemS."To Material Item";
            end;
            if (PartNext <> '') and (ItemS."Inventory Posting Group" <> 'FG') then
                UpdateAction1(PlanL, SumQ, PartNext, PDate, vPlanL, AC)
            else
                UpdateAction1(PlanL, SumQ, PartNext, PDate, vPlanL, AC);

        end;

        //Update//
        PlanL.Modify();

    end;

    procedure UpdateAction1(var PlanR: Record "Plan Line Sub" temporary; BeginQty: decimal; PartNext: Code[20]; StartDate: Date; vPlanL: Record "Plan Line Sub"; ty: Integer)
    var
        SumQ: Decimal;
        SumR: Decimal;
        SumOut: Decimal;
        SumTotal: Decimal;
        ItemS: Record Item;
        PartNo: Code[20];
        TotalS: Decimal;
        EndDate: Date;
    begin
        EndDate := CalcDate('<CM>', StartDate);
        PartNo := PartNext;
        TotalS := BeginQty;
        getValueR(StartDate, PartNo, TotalS, vPlanL, 1, ty);

        PlanR.Total := 0;
        PlanR.Day1 := TotalS;
        PlanR.Day2 := getValueR(CalcDate('<+1D>', StartDate), PartNo, TotalS, vPlanL, 2, ty);
        PlanR.Day3 := getValueR(CalcDate('<+2D>', StartDate), PartNo, TotalS, vPlanL, 3, ty);
        PlanR.Day4 := getValueR(CalcDate('<+3D>', StartDate), PartNo, TotalS, vPlanL, 4, ty);
        PlanR.Day5 := getValueR(CalcDate('<+4D>', StartDate), PartNo, TotalS, vPlanL, 5, ty);
        PlanR.Day6 := getValueR(CalcDate('<+5D>', StartDate), PartNo, TotalS, vPlanL, 6, ty);
        PlanR.Day7 := getValueR(CalcDate('<+6D>', StartDate), PartNo, TotalS, vPlanL, 7, ty);
        PlanR.Day8 := getValueR(CalcDate('<+7D>', StartDate), PartNo, TotalS, vPlanL, 8, ty);
        PlanR.Day9 := getValueR(CalcDate('<+8D>', StartDate), PartNo, TotalS, vPlanL, 9, ty);
        PlanR.Day10 := getValueR(CalcDate('<+9D>', StartDate), PartNo, TotalS, vPlanL, 10, ty);

        PlanR.Day11 := getValueR(CalcDate('<+10D>', StartDate), PartNo, TotalS, vPlanL, 11, ty);
        PlanR.Day12 := getValueR(CalcDate('<+11D>', StartDate), PartNo, TotalS, vPlanL, 12, ty);
        PlanR.Day13 := getValueR(CalcDate('<+12D>', StartDate), PartNo, TotalS, vPlanL, 13, ty);
        PlanR.Day14 := getValueR(CalcDate('<+13D>', StartDate), PartNo, TotalS, vPlanL, 14, ty);
        PlanR.Day15 := getValueR(CalcDate('<+14D>', StartDate), PartNo, TotalS, vPlanL, 15, ty);
        PlanR.Day16 := getValueR(CalcDate('<+15D>', StartDate), PartNo, TotalS, vPlanL, 16, ty);
        PlanR.Day17 := getValueR(CalcDate('<+16D>', StartDate), PartNo, TotalS, vPlanL, 17, ty);
        PlanR.Day18 := getValueR(CalcDate('<+17D>', StartDate), PartNo, TotalS, vPlanL, 18, ty);
        PlanR.Day19 := getValueR(CalcDate('<+18D>', StartDate), PartNo, TotalS, vPlanL, 19, ty);
        PlanR.Day20 := getValueR(CalcDate('<+19D>', StartDate), PartNo, TotalS, vPlanL, 20, ty);

        PlanR.Day21 := getValueR(CalcDate('<+20D>', StartDate), PartNo, TotalS, vPlanL, 21, ty);
        PlanR.Day22 := getValueR(CalcDate('<+21D>', StartDate), PartNo, TotalS, vPlanL, 22, ty);
        PlanR.Day23 := getValueR(CalcDate('<+22D>', StartDate), PartNo, TotalS, vPlanL, 23, ty);
        PlanR.Day24 := getValueR(CalcDate('<+23D>', StartDate), PartNo, TotalS, vPlanL, 24, ty);
        PlanR.Day25 := getValueR(CalcDate('<+24D>', StartDate), PartNo, TotalS, vPlanL, 25, ty);
        PlanR.Day26 := getValueR(CalcDate('<+25D>', StartDate), PartNo, TotalS, vPlanL, 26, ty);
        PlanR.Day27 := getValueR(CalcDate('<+26D>', StartDate), PartNo, TotalS, vPlanL, 27, ty);
        PlanR.Validate(Day28, getValueR(CalcDate('<+27D>', StartDate), PartNo, TotalS, vPlanL, 28, ty));

        PlanR.Day29 := 0;
        PlanR.Day30 := 0;
        PlanR.Validate(Day31, 0);

        if CalcDate('<+28D>', StartDate) <= EndDate then
            PlanR.Validate(Day29, getValueR(CalcDate('<+28D>', StartDate), PartNo, TotalS, vPlanL, 29, ty));
        if CalcDate('<+29D>', StartDate) <= EndDate then
            PlanR.Validate(Day30, getValueR(CalcDate('<+29D>', StartDate), PartNo, TotalS, vPlanL, 30, ty));
        if CalcDate('<+30D>', StartDate) <= EndDate then
            PlanR.Validate(Day31, getValueR(CalcDate('<+30D>', StartDate), PartNo, TotalS, vPlanL, 31, ty));
        PlanR.Sumtotal();
        PlanR.Modify();
    end;

    procedure getValueR(Ddate: date; PartNo: Code[20]; var TotalS: Decimal; vPlanL: Record "Plan Line Sub"; DD: Integer; ty: Integer): Decimal
    var
        RT: Decimal;
        PlanL: Record "Plan Line Sub";
        SumT: Decimal;
        SumD: Decimal;
        AssBom: Record "BOM Component";
        QtyPer: Decimal;
    begin
        RT := 0;
        SumT := 0;
        PlanL.Reset();
        PlanL.SetRange("ref. Plan Name", vPlanL."ref. Plan Name");
        PlanL.SetRange("Part No.", PartNo);
        PlanL.SetFilter(Seq, '>%1', vPlanL.Seq);
        if ty = 1 then
            PlanL.SetFilter("Type Item", '%1|%2', PlanL."Type Item"::Production, PlanL."Type Item"::Receive);
        if ty = 2 then
            PlanL.SetFilter("Type Item", '%1|%2', PlanL."Type Item"::Production, PlanL."Type Item"::Receive);
        if ty = 3 then
            PlanL.SetFilter("Type Item", '%1|%2', PlanL."Type Item"::Production, PlanL."Type Item"::Delivery);
        if PlanL.Find('-') then begin
            SumT := getDay1T031(DD, PlanL);
        end;
        //AssBOM PCSUnit//
        QtyPer := 1;
        AssBom.Reset();
        AssBom.SetRange("Parent Item No.", PartNo);
        AssBom.SetRange("No.", vPlanL."Part No.");
        if AssBom.Find('-') then begin
            QtyPer := AssBom."Quantity per";
        end;

        SumD := getDay1T031(DD, vPlanL);
        TotalS := TotalS + SumD - (SumT * QtyPer);
        RT := TotalS;

        exit(RT);
    end;

    procedure getDay1T031(DD: Integer; PlanL: Record "Plan Line Sub"): Decimal;
    var
        SumT: Decimal;

    begin
        SumT := 0;
        case DD of
            1:
                SumT += PlanL.Day1;
            2:
                SumT += PlanL.Day2;
            3:
                SumT += PlanL.Day3;
            4:
                SumT += PlanL.Day4;
            5:
                SumT += PlanL.Day5;
            6:
                SumT += PlanL.Day6;
            7:
                SumT += PlanL.Day7;
            8:
                SumT += PlanL.Day8;
            9:
                SumT += PlanL.Day9;
            10:
                SumT += PlanL.Day10;

            11:
                SumT += PlanL.Day11;
            12:
                SumT += PlanL.Day12;
            13:
                SumT += PlanL.Day13;
            14:
                SumT += PlanL.Day14;
            15:
                SumT += PlanL.Day15;
            16:
                SumT += PlanL.Day16;
            17:
                SumT += PlanL.Day17;
            18:
                SumT += PlanL.Day18;
            19:
                SumT += PlanL.Day19;
            20:
                SumT += PlanL.Day20;

            21:
                SumT += PlanL.Day21;
            22:
                SumT += PlanL.Day22;
            23:
                SumT += PlanL.Day23;
            24:
                SumT += PlanL.Day24;
            25:
                SumT += PlanL.Day25;
            26:
                SumT += PlanL.Day26;
            27:
                SumT += PlanL.Day27;
            28:
                SumT += PlanL.Day28;
            29:
                SumT += PlanL.Day29;
            30:
                SumT += PlanL.Day30;
            31:
                SumT += PlanL.Day31;
        end;
        exit(SumT);
    end;


}