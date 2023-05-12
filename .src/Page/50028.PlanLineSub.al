page 50028 "Plan Line Sub"
{
    SourceTable = "Plan Line Sub";
    DelayedInsert = true;
    LinksAllowed = false;
    AutoSplitKey = true;
    MultipleNewLines = true;
    PageType = ListPart;
    DeleteAllowed = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                FreezeColumn = "Part No.";
                //   field("ref. Plan Name"; "ref. Plan Name") { ApplicationArea = all; Editable = false; }
                field(Seq; Seq) { ApplicationArea = all; Caption = 'No.'; Editable = false; }
                field("Part No."; "Part No.") { ApplicationArea = all; Editable = false; }
                field("Part Name"; "Part Name") { ApplicationArea = all; Editable = false; }
                field("Type Item"; "Type Item") { ApplicationArea = all; Editable = false; StyleExpr = stylx; }

                field(Day1; Day1) { ApplicationArea = all; CaptionClass = '3,' + Caption[1]; Editable = EditAble; StyleExpr = stylT1; }
                field(Day2; Day2) { ApplicationArea = all; CaptionClass = '3,' + Caption[2]; Editable = EditAble; StyleExpr = stylT2; }
                field(Day3; Day3) { ApplicationArea = all; CaptionClass = '3,' + Caption[3]; Editable = EditAble; StyleExpr = stylT3; }
                field(Day4; Day4) { ApplicationArea = all; CaptionClass = '3,' + Caption[4]; Editable = EditAble; StyleExpr = stylT4; }
                field(Day5; Day5) { ApplicationArea = all; CaptionClass = '3,' + Caption[5]; Editable = EditAble; StyleExpr = stylT5; }
                field(Day6; Day6) { ApplicationArea = all; CaptionClass = '3,' + Caption[6]; Editable = EditAble; StyleExpr = stylT6; }
                field(Day7; Day7) { ApplicationArea = all; CaptionClass = '3,' + Caption[7]; Editable = EditAble; StyleExpr = stylT7; }
                field(Day8; Day8) { ApplicationArea = all; CaptionClass = '3,' + Caption[8]; Editable = EditAble; StyleExpr = stylT8; }
                field(Day9; Day9) { ApplicationArea = all; CaptionClass = '3,' + Caption[9]; Editable = EditAble; StyleExpr = stylT9; }
                field(Day10; Day10) { ApplicationArea = all; CaptionClass = '3,' + Caption[10]; Editable = EditAble; StyleExpr = stylT10; }

                field(Day11; Day11) { ApplicationArea = all; CaptionClass = '3,' + Caption[11]; Editable = EditAble; StyleExpr = stylT11; }
                field(Day12; Day12) { ApplicationArea = all; CaptionClass = '3,' + Caption[12]; Editable = EditAble; StyleExpr = stylT12; }
                field(Day13; Day13) { ApplicationArea = all; CaptionClass = '3,' + Caption[13]; Editable = EditAble; StyleExpr = stylT13; }
                field(Day14; Day14) { ApplicationArea = all; CaptionClass = '3,' + Caption[14]; Editable = EditAble; StyleExpr = stylT14; }
                field(Day15; Day15) { ApplicationArea = all; CaptionClass = '3,' + Caption[15]; Editable = EditAble; StyleExpr = stylT15; }
                field(Day16; Day16) { ApplicationArea = all; CaptionClass = '3,' + Caption[16]; Editable = EditAble; StyleExpr = stylT16; }
                field(Day17; Day17) { ApplicationArea = all; CaptionClass = '3,' + Caption[17]; Editable = EditAble; StyleExpr = stylT17; }
                field(Day18; Day18) { ApplicationArea = all; CaptionClass = '3,' + Caption[18]; Editable = EditAble; StyleExpr = stylT18; }
                field(Day19; Day19) { ApplicationArea = all; CaptionClass = '3,' + Caption[19]; Editable = EditAble; StyleExpr = stylT19; }
                field(Day20; Day20) { ApplicationArea = all; CaptionClass = '3,' + Caption[20]; Editable = EditAble; StyleExpr = stylT20; }

                field(Day21; Day21) { ApplicationArea = all; CaptionClass = '3,' + Caption[21]; Editable = EditAble; StyleExpr = stylT21; }
                field(Day22; Day22) { ApplicationArea = all; CaptionClass = '3,' + Caption[22]; Editable = EditAble; StyleExpr = stylT22; }
                field(Day23; Day23) { ApplicationArea = all; CaptionClass = '3,' + Caption[23]; Editable = EditAble; StyleExpr = stylT23; }
                field(Day24; Day24) { ApplicationArea = all; CaptionClass = '3,' + Caption[24]; Editable = EditAble; StyleExpr = stylT24; }
                field(Day25; Day25) { ApplicationArea = all; CaptionClass = '3,' + Caption[25]; Editable = EditAble; StyleExpr = stylT25; }
                field(Day26; Day26) { ApplicationArea = all; CaptionClass = '3,' + Caption[26]; Editable = EditAble; StyleExpr = stylT26; }
                field(Day27; Day27) { ApplicationArea = all; CaptionClass = '3,' + Caption[27]; Editable = EditAble; StyleExpr = stylT27; }
                field(Day28; Day28) { ApplicationArea = all; CaptionClass = '3,' + Caption[28]; Editable = EditAble; StyleExpr = stylT28; }

                field(Day29; Day29) { ApplicationArea = all; CaptionClass = '3,' + Caption[29]; Visible = Field29Visible; Editable = EditAble; StyleExpr = stylT29; }
                field(Day30; Day30) { ApplicationArea = all; CaptionClass = '3,' + Caption[30]; Visible = Field30Visible; Editable = EditAble; StyleExpr = stylT30; }
                field(Day31; Day31) { ApplicationArea = all; CaptionClass = '3,' + Caption[31]; Visible = Field31Visible; Editable = EditAble; StyleExpr = stylT31; }

                field(Total; Total) { ApplicationArea = all; Editable = false; StyleExpr = 'Favorable'; }
                field(EditAble; EditAble) { ApplicationArea = all; }
                field("Report Type"; "Report Type") { ApplicationArea = all; }

            }

        }
    }
    actions
    {
        area(Processing)
        {
            group(Report)
            {
                Image = Report;
                action(MaterialStockCard)
                {
                    ApplicationArea = all;
                    Caption = 'Material Stock Card';
                    Image = Print;
                    Visible = true;
                    trigger OnAction()
                    var
                        ItemS: Record Item;
                        MaterialStock: Report "Material Stock Card";
                    begin
                        Clear(MaterialStock);
                        ItemS.Reset();
                        ItemS.SetRange("No.", Rec."Part No.");
                        if ItemS.Find('-') then
                            MaterialStock.SetTableView(ItemS);
                        MaterialStock.RunModal();
                    end;
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        dNo := Rec."ref. Plan Name";
        icc += 1;
        if icc = 1 then begin
            // Message(dNo);
            GetCaption();
        end;
        stylx := 'Attention';
        if "Type Item" = "Type Item"::Receive then
            stylx := 'Favorable';
        if "Type Item" = "Type Item"::Production then
            stylx := 'StrongAccent';

        EditAble := Rec.EditAble;
        stylT1 := CheckColor(day1);
        stylT2 := CheckColor(day2);
        stylT3 := CheckColor(day3);
        stylT4 := CheckColor(day4);
        stylT5 := CheckColor(day5);
        stylT6 := CheckColor(day6);
        stylT7 := CheckColor(day7);
        stylT8 := CheckColor(day8);
        stylT9 := CheckColor(day9);
        stylT10 := CheckColor(day10);

        stylT11 := CheckColor(day11);
        stylT12 := CheckColor(day12);
        stylT13 := CheckColor(day13);
        stylT14 := CheckColor(day14);
        stylT15 := CheckColor(day15);
        stylT16 := CheckColor(day16);
        stylT17 := CheckColor(day17);
        stylT18 := CheckColor(day18);
        stylT19 := CheckColor(day19);
        stylT20 := CheckColor(day20);

        stylT21 := CheckColor(day21);
        stylT22 := CheckColor(day22);
        stylT23 := CheckColor(day23);
        stylT24 := CheckColor(day24);
        stylT25 := CheckColor(day25);
        stylT26 := CheckColor(day26);
        stylT27 := CheckColor(day27);
        stylT28 := CheckColor(day28);
        stylT29 := CheckColor(day29);
        stylT30 := CheckColor(day30);
        stylT31 := CheckColor(day31);



    end;

    trigger OnOpenPage()
    begin

    end;

    trigger OnInit()
    begin
        Field31Visible := true;
        Field30Visible := true;
        Field29Visible := true;
        EditAble := true;

    end;

    var
        icc: Integer;
        dNo: Text[50];
        utility: Codeunit Utility;
        Caption: array[31] of Text[30];
        CapVisible: array[31] of Boolean;
        PlanH: Record "Plan Header";
        Field29Visible: Boolean;
        [InDataSet]
        Field30Visible: Boolean;
        [InDataSet]
        Field31Visible: Boolean;
        [InDataSet]
        Field32Visible: Boolean;
        stylx: Text[30];
        stylT1: Text[30];
        stylT2: Text[30];
        stylT3: Text[30];
        stylT4: Text[30];
        stylT5: Text[30];
        stylT6: Text[30];
        stylT7: Text[30];
        stylT8: Text[30];
        stylT9: Text[30];
        stylT10: Text[30];

        stylT11: Text[30];
        stylT12: Text[30];
        stylT13: Text[30];
        stylT14: Text[30];
        stylT15: Text[30];
        stylT16: Text[30];
        stylT17: Text[30];
        stylT18: Text[30];
        stylT19: Text[30];
        stylT20: Text[30];

        stylT21: Text[30];
        stylT22: Text[30];
        stylT23: Text[30];
        stylT24: Text[30];
        stylT25: Text[30];
        stylT26: Text[30];
        stylT27: Text[30];
        stylT28: Text[30];
        stylT29: Text[30];
        stylT30: Text[30];
        stylT31: Text[30];




    // [InDataSet]
    // EditAble: Boolean;

    procedure setDNo(DNox: Text[50])
    begin
        dNo := dNox;
    end;

    procedure GetCaption()
    var
        Year1: Integer;
        MMM: Integer;
        M2: Integer;
        STDate: Date;
        ENDate: Date;
        CKDate: Date;
        Ix: Integer;
        CK: Integer;
    begin
        PlanH.Reset();
        PlanH.SetRange("Plan Name", dNo);
        if PlanH.Find('-') then begin
            Year1 := PlanH."Plan Year".AsInteger();
            MMM := PlanH."Plan Month".AsInteger();
            STDate := DMY2Date(1, MMM, Year1);
            ENDate := CalcDate('<CM>', STDate);
            for ix := 1 to 31 do begin
                Caption[ix] := 'None';
            end;
            CKDate := STDate;
            CK := 1;
            while (CKDate <= ENDate) do begin
                Caption[CK] := Format(CKDate);
                CKDate := CalcDate('<+1D>', CKDate);
                CK += 1;
            end;

            if (Caption[29] = 'None') then
                Field29Visible := false;
            if (Caption[30] = 'None') then
                Field30Visible := false;
            if (Caption[31] = 'None') then
                Field31Visible := false;
        end;
    end;

    procedure CheckColor(Qty: Decimal): Text[30]
    begin
        if Qty > 0 then
            exit('Strong');
        exit('');
    end;
}