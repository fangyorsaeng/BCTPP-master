report 50034 "Plan Production Actual"
{
    Caption = 'Plan Production Actual';
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/50034.PlanProduction.rdl';
    PreviewMode = Normal;
    dataset
    {
        dataitem("Plan Header"; "Plan Header")
        {
            RequestFilterFields = "Plan Name";
            column(Plan_Name; "Plan Name") { }
            column(DDate; DDate) { }
            dataitem("Plan Report"; "Plan Report")
            {
                DataItemLink = "ref. Plan Name" = FIELD("Plan Name");
                DataItemTableView = sorting(sUser, GroupA, GroupB, Seq, "ref. Plan Name", "Part No.");
                column(Machine; "Machine") { }
                column(RowS; RowS) { }
                column(TextGroup; TextGroup) { }
                column(GroupA; GroupA) { }
                column(GroupB; GroupB) { }
                column(ref__Plan_Name; "ref. Plan Name") { }
                column(Part_No_; "Part No.") { }
                column(Part_Name; "Part Name") { }
                column(Type_Item; "Type Item") { }
                column(ColorText; ColorText) { }
                column(Ref__Ven; "Ref. Ven") { }
                column(ColorDayS6; ColorDayS6) { }
                column(ColorDaySText; ColorDaySText) { }
                column(RowNo; RowNo) { }
                column(Seq; Seq) { }
                column(Day1; Day1) { }
                column(Day2; Day2) { }
                column(Day3; Day3) { }
                column(Day4; Day4) { }
                column(Day5; Day5) { }
                column(Day6; Day6) { }
                column(Day7; Day7) { }
                column(Day8; Day8) { }
                column(Day9; Day9) { }
                column(Day10; Day10) { }

                column(Day11; Day11) { }
                column(Day12; Day12) { }
                column(Day13; Day13) { }
                column(Day14; Day14) { }
                column(Day15; Day15) { }
                column(Day16; Day16) { }
                column(Day17; Day17) { }
                column(Day18; Day18) { }
                column(Day19; Day19) { }
                column(Day20; Day20) { }

                column(Day21; Day21) { }
                column(Day22; Day22) { }
                column(Day23; Day23) { }
                column(Day24; Day24) { }
                column(Day25; Day25) { }
                column(Day26; Day26) { }
                column(Day27; Day27) { }
                column(Day28; Day28) { }
                column(Day29; Day29) { }
                column(Day30; Day30) { }
                column(Day31; Day31) { }
                column(Total; Total) { }
                column(DiffPer; DiffPer) { }
                column(TextPer; TextPer) { }
                column(Summarytotal; Summarytotal) { }
                trigger OnAfterGetRecord()
                var
                    TotalA: Decimal;
                    TotalB: Decimal;
                    TotalC: Decimal;
                begin
                    TextGroup := '';
                    TextPer := '';
                    TotalA := 0;
                    TotalB := 0;
                    TotalC := 0;
                    if Seq = 1 then
                        RowS += 1;
                    if Seq = 1 then begin

                        PlanRP.Reset();
                        PlanRP.SetRange("ref. Plan Name", "Plan Report"."ref. Plan Name");
                        PlanRP.SetRange(GroupA, "Plan Report".GroupA);
                        if PlanRP.Find('-') then begin
                            repeat
                                if PlanRP.Seq = 1 then
                                    TotalA := PlanRP.Total;
                                if PlanRP.Seq = 2 then
                                    TotalB := PlanRP.Total;
                            until PlanRP.Next = 0;
                        end;
                        if (TotalA > 0) and (TotalB > 0) then begin
                            TotalC := Round((TotalB * 100 / TotalA), 0.01, '=');
                            TextPer := Format(TotalC) + '%';
                        end;

                        ItemS.Reset();
                        ItemS.SetRange("No.", "Part No.");
                        if ItemS.Find('-') then begin
                            TextGroup := ItemS."Default Process";
                        end;
                    end;
                    ColorText := 'No Color';
                    ColorDaySText := 'No Color';
                    ColorDayS6 := 'Black';
                    //PaleTurquoise
                    if Seq = 3 then
                        ColorText := 'PaleTurquoise';
                    if Seq = 4 then
                        ColorText := 'LightGreen';
                    if Seq = 5 then
                        ColorText := 'PeachPuff';
                    if Seq = 6 then
                        ColorText := 'LemonChiffon';
                    if (Seq = 6) and ("Ref. Ven" = 'CHECK') then
                        ColorDayS6 := 'Red';
                    if (Seq = 1) and ("Ref. Ven" = 'MACHINE') then
                        ColorDaySText := 'LightCyan';

                end;

                trigger OnPreDataItem()
                begin
                    SetFilter(sUser, UserId);
                    RowS := 0;
                    Summarytotal := 0;
                    PlanRP.Reset();
                    PlanRP.SetRange(sUser, UserId);
                    PlanRP.SetFilter(Seq, '%1|%2', 2, 3);
                    if PlanRP.Find('-') then begin
                        repeat
                            Summarytotal += PlanRP.Total;
                        until PlanRP.Next = 0;
                    end;
                    DDate := PlanUnit.getDate("Plan Header"."Plan Name");
                end;
            }
            trigger OnAfterGetRecord()
            begin
                //Call //
                PlanUnit.CreateLineProduction("Plan Header", SelectPart);
                //Call Washing//
            end;

            trigger OnPreDataItem()
            begin
                PlanUnit.DeletebyUser(UserId);
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
                    field(SelectPart; SelectPart)
                    {
                        Caption = 'Select Part No.';
                        TableRelation = "List Item On Report"."Part No." where("Type Item" = filter(Production));
                        ApplicationArea = all;
                    }
                    field(VSCheck; VSCheck)
                    {
                        Caption = 'Visual Check';
                        ApplicationArea = all;
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin

    end;

    procedure setDoc(DocNox: Code[50])
    begin
        DocNo := DocNox;
    end;

    var
        RowS: Integer;
        DDate: Date;
        DocNo: Code[50];
        VSCheck: Boolean;
        PlanUnit: Codeunit "Plan Unit";
        Summarytotal: Decimal;
        PlanRP: Record "Plan Report";
        PlanH: Record "Plan Header";
        PlanL: Record "Plan Line Sub";
        TextPer: Text[20];
        ItemS: Record Item;
        ItemS2: Record Item;
        TextGroup: Text[50];
        ColorText: Text[50];
        ColorDayS6: Text[50];
        ColorDaySText: Text[50];
        SelectPart: Code[50];

}