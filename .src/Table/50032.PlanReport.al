table 50032 "Plan Report"
{
    fields
    {
        field(1; "sUser"; Code[100]) { }
        field(2; "ref. Plan Name"; Code[50]) { Editable = true; }
        field(3; "Seq"; Integer) { Editable = true; }
        field(4; "Part No."; Code[30]) { Editable = true; }
        field(5; "Part Name"; Text[200]) { Editable = true; }
        field(6; "Model"; Text[50]) { }
        field(7; "Section"; Enum "Prod. Process") { }
        field(8; "Type Item"; Option)
        {
            OptionMembers = " ",Receive,Delivery,Production;
        }
        field(30; "Day1"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(31; "Day2"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(32; "Day3"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(33; "Day4"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(34; "Day5"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(35; "Day6"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(36; "Day7"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(37; "Day8"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(38; "Day9"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(39; "Day10"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }

        field(40; "Day11"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(41; "Day12"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(42; "Day13"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(43; "Day14"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(44; "Day15"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(45; "Day16"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(46; "Day17"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(47; "Day18"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(48; "Day19"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(49; "Day20"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }

        field(50; "Day21"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(51; "Day22"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(52; "Day23"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(53; "Day24"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(54; "Day25"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(55; "Day26"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(56; "Day27"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(57; "Day28"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(58; "Day29"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(59; "Day30"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }

        field(60; "Day31"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(61; "Day32"; Decimal) { trigger OnValidate() begin Sumtotal(); end; }
        field(65; "Total"; Decimal) { }
        field(66; "EditAble"; Boolean) { }
        field(67; "Report Type"; Option)
        {
            OptionMembers = " ",Sales,Factory,Supplier;
        }
        field(68; "DiffPer"; Decimal) { }
        field(700; "GroupA"; Code[30]) { }
        field(701; "GroupB"; Code[30]) { }
        field(702; "Ref. Ven"; Code[30]) { }
        field(703; "Unit"; Text[50]) { }
        field(704; "Machine"; Text[30]) { }
        field(705; "RowNo"; Integer) { }
    }
    keys
    {
        key(key1; sUser, GroupA, GroupB, Seq, "ref. Plan Name", "Part No.", "Ref. Ven", Machine) { }
        // key(key2; "ref. Plan Name", Seq) { }
    }
    procedure Sumtotal()
    var
        SumQ: Decimal;
    begin
        SumQ := Day1 + day2 + day3 + day4 + day5 + day6 + day7 + day8 + day9 + day10;
        SumQ += Day11 + day12 + day13 + day14 + day15 + day16 + day17 + day18 + day19 + day20;
        SumQ += Day21 + day22 + day23 + day24 + day25 + day26 + day27 + day28 + day29 + day30 + Day31;
        Total := SumQ;
    end;


}