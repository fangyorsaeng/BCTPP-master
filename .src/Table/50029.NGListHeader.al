table 50029 "NG List"
{
    fields
    {
        field(1; EntryNo; Integer) { AutoIncrement = true; }
        field(2; "Document No."; Code[20]) { Caption = 'Doc No.'; }
        field(3; "Line No."; Integer) { }
        field(4; "Part No."; Code[20])
        {
            // TableRelation = item."No.";
            TableRelation = item."No." where("Group PD" = field("Ref. Process"));
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
                    end;
                end;
            end;
        }
        field(6; "Part Name"; Text[200]) { }
        field(7; "Quantity"; Decimal) { Caption = 'NG Qty'; }
        field(8; "Lot No."; Code[50])
        {

        }
        field(9; "Remark"; Text[150]) { }
        field(10; "Process"; Code[20]) { TableRelation = "Process List"."Process Name"; }
        field(11; "Machine No."; Code[20]) { TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3)); }
        field(12; "Box"; Integer) { }
        field(13; "NC Date"; Date) { }
        field(14; "MC Date"; Date) { }
        field(15; "RRD Date"; Date) { }
        field(16; "Shift"; Option) { OptionMembers = " ","1S","2S"; }
        field(17; "Reamer Machine"; Code[20]) { TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3)); }
        field(18; "Dept."; Code[20]) { TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1)); }
        field(19; "Req. By"; Code[20]) { TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2)); }
        field(20; "Ref. Doc No"; Code[20]) { }
        field(30; "Ref. Process"; Enum "Prod. Process")
        {
            //  OptionMembers = " ",PD1,PD2,PD3,PD4,PD5,SGA,OTH,MFG;
            Caption = 'Ref. Section';
        }
        field(31; "NG Date"; Date)
        {
            //FieldClass = FlowField;
            //  CalcFormula = lookup("Production Record Header"."Req. Date" where("Req. No." = field("Document No.")));
        }

        field(37; "OLD Location"; Code[20])
        {
            TableRelation = Location.Code;
        }
        field(38; "New Locatin"; Code[20])
        {
            TableRelation = Location.Code;
        }





    }
    keys
    {
        key(key1; EntryNo) { }

    }

    var
        DType: Enum "Prod. Process";

    procedure setProcess(xDtype: Enum "Prod. Process")
    begin
        DType := xDtype;
    end;

}