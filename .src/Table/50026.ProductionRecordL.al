table 50026 "Production Record Line"
{
    fields
    {
        field(1; EntryNo; Integer) { AutoIncrement = true; }
        field(2; "Document No."; Code[20]) { }
        field(3; "Line No."; Integer) { }
        field(4; "Part No."; Code[20])
        {
            //   TableRelation = Item."No." where("Inventory Posting Group" = filter('FG|WIP'));
            TableRelation = item."No." where("Group PD" = field("Ref. Process"), "Inventory Posting Group" = filter('FG|WIP'));
            trigger OnValidate()
            var
                TempL: Record "Production Record Line";
                CRow: Integer;
                ItemS: Record Item;
            begin
                if "Part No." <> '' then begin
                    CRow := 0;
                    if "Line No." = 0 then begin
                        TempL.Reset();
                        TempL.SetFilter("Line No.", '<>%1', 0);
                        TempL.SetRange("Document No.", Rec."Document No.");
                        if TempL.FindLast() then begin
                            CRow := TempL."Line No.";
                        end;
                        CRow := CRow + 1;
                        Rec."Line No." := CRow;

                    end;
                    ItemS.Reset();
                    ItemS.SetRange("No.", "Part No.");
                    if ItemS.Find('-') then begin
                        "Part Name" := ItemS.Description;
                        "Machine No." := ItemS."Default Machine";
                    end;
                end;
            end;
        }
        field(6; "Part Name"; Text[200]) { }
        field(7; "Quantity"; Decimal) { }
        field(8; "Lot No."; Code[50])
        {

        }
        field(9; "Remark"; Text[150]) { }
        field(10; "Process"; Code[20]) { TableRelation = "Process List"."Process Name"; }
        field(11; "Machine No."; Code[20]) { TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3)); Caption = 'M/C No. or User'; }
        field(12; "Box"; Integer) { }
        field(13; "NC Date"; Date) { }
        field(14; "MC Date"; Date) { }
        field(15; "RRD Date"; Date) { }
        field(16; "Shift"; Option) { OptionMembers = " ","1S","2S"; }
        field(17; "Reamer Machine"; Code[20]) { TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3)); }
        field(20; "Ref. Assembly No"; Code[20]) { }
        field(30; "Ref. Process"; Enum "Prod. Process")
        {
            //  OptionMembers = " ",PD1,PD2,PD3,PD4,PD5,SGA,OTH,MFG;
            Caption = 'Ref. Section';
        }
        field(31; "Plan Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Production Record Header"."Req. Date" where("Req. No." = field("Document No.")));
        }
        field(32; "NG Qty"; Decimal)
        {

        }
        field(33; "Ref. Doc. NG"; Code[30])
        {

        }



    }
    keys
    {
        key(key1; "Document No.", "Line No.") { }

    }

    var
        DType: Enum "Prod. Process";

    procedure setProcess(xDtype: Enum "Prod. Process")
    begin
        DType := xDtype;
    end;

}