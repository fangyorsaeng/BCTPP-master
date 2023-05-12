table 50022 "Material Delivery Line"
{
    fields
    {
        field(1; EntryNo; Integer) { AutoIncrement = true; }
        field(2; "Document No."; Code[20]) { }
        field(3; "Line No."; Integer) { }
        field(4; "Part No."; Code[20])
        {
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                TempL: Record "Material Delivery Line";
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
        field(7; "Quantity"; Decimal) { }
        field(8; "Lot No."; Code[50])
        {
            //  FieldClass = FlowField;
            //  CalcFormula = lookup("Invt. Shipment Line"."Lot No." where("Item No." = field("Part No."), "MDLH No." = field("Document No."), "Line No." = field("Line No.")));

        }
        field(9; "Remark"; Text[150]) { }
        field(10; "Process"; Code[20]) { TableRelation = "Process List"."Process Name"; }
        field(11; "Machine"; Code[20]) { TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3)); }
        field(20; "Shipment No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Invt. Shipment Line"."Document No." where("Item No." = field("Part No."), "MDLH No." = field("Document No."), "MDLH Line No." = field("Line No.")));
        }
        field(21; "Shipment Line"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Invt. Shipment Line"."Line No." where("Item No." = field("Part No."), "MDLH No." = field("Document No."), "MDLH Line No." = field("Line No.")));
        }
        field(22; "Shipment Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Invt. Shipment Line".Quantity where("Item No." = field("Part No."), "MDLH No." = field("Document No."), "MDLH Line No." = field("Line No.")));
        }
        field(30; "Ref. Process"; Enum "Prod. Process")
        {
            //  OptionMembers = " ",PD1,PD2,PD3,PD4,PD5,SGA,OTH,MFG;
            Caption = 'Ref. Section';
        }

    }
    keys
    {
        key(key1; "Document No.", "Line No.") { }
    }

}