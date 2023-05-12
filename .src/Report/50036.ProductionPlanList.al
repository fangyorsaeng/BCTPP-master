report 50036 "Production Plan"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/50036.ProductionPlanList.rdl';
    Caption = 'Production Plan from PC';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Plan Header"; "Plan Header")
        {
            UseTemporary = true;
            RequestFilterFields = "Plan Name";
            DataItemTableView = where("Use Report" = filter('ForReport'));
            column(Plan_Name; "Plan Name") { }
            column(Plan_Description; "Plan Description") { }
            column(Plan_Month; "Plan Month") { }
            column(Plan_Year; "Plan Year") { }
            column(DDate; MonthDate) { }

            dataitem("Plan Line Sub"; "Plan Line Sub")
            {
                UseTemporary = true;
                DataItemLink = "ref. Plan Name" = field("Plan Name");
                column(ColorDayS6; ColorDayS6) { }
                column(ColorDaySText; ColorDaySText) { }
                column(ColorText; ColorText) { }
                column(ColorDayS3; ColorDayS3) { }
                column(ref__Plan_Name; "ref. Plan Name") { }
                column(Part_No_; "Part No.") { }
                column(Part_Name; "Part Name") { }
                column(Type_Item; "Type Item") { }
                column(Report_Type; "Report Type") { }
                column(Plan_Date; "Plan Date") { }
                column(Plan_Qty; "Plan IN Qty") { }
                column(Plan_Out_Qty; "Plan Out Qty") { }
                column(Inventory; Inventory) { }
                column(process; ItemS."Default Process") { }
                column(Plan_IN_Qty; "Plan IN Qty") { }
                column(Seq; Seq) { }
                column(SeqC; SeqC) { }
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
                trigger OnAfterGetRecord()
                begin
                    ItemS.Reset();
                    ItemS.SetRange("No.", "Part No.");
                    if ItemS.Find('-') then;
                    Inventory := 0;
                    ColorDaySText := 'No Color';
                    ColorDayS6 := 'Black';
                    ColorDayS3 := 'No Color';
                    ColorText := 'No Color';
                    if "Type Item" = "Type Item"::Production then begin
                        ColorText := 'Lavender';
                        ColorDayS6 := 'Black';
                    end;

                    if "Type Item" = "Type Item"::Receive then begin
                        ColorText := 'LightGreen';
                        ColorDayS6 := 'Black';
                    end
                    else
                        if "Type Item" = "Type Item"::Inventory then begin
                            ColorText := 'Pink';
                            //  ColorDaySText := 'Pink';
                            ColorDayS3 := 'Pink';
                            ColorDayS6 := 'Blue';
                        end;

                end;

                trigger OnPreDataItem()
                begin
                    //PlanUnit.CreateReport(PlanName, PlanPart, "Plan Header", "Plan Line Sub");
                end;

            }
            trigger OnAfterGetRecord()
            begin
                MonthDate := DMY2Date(1, "Plan Month".AsInteger(), "Plan Year".AsInteger());
                TestText := "Plan Header"."Plan Name";
            end;

        }

    }
    trigger OnPreReport()
    begin
        PlanUnit.CreateReport(PlanName, PlanPart, "Plan Header", "Plan Line Sub");
        TestText := '';
    end;


    var
        MonthDate: Date;
        PlanUnit: Codeunit "Plan Unit";
        Inventory: Decimal;
        PlanName: Text[50];
        PlanPart: Text[50];
        TextGroup: Text[50];
        ColorText: Text[50];
        ColorDayS6: Text[50];
        ColorDayS3: Text[50];
        ColorDaySText: Text[50];
        ItemS: Record Item;
        PlanHH: Record "Plan Header" temporary;
        PlanLL: Record "Plan Line Sub" temporary;
        TestText: Text[50];

    procedure setDoc(PName: Text[50]; PPart: Text[50])
    begin
        PlanName := PName;
        PlanPart := PPart;
    end;
}