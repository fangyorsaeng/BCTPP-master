table 50021 "Material Delivery Header"
{
    fields
    {
        field(1; EntryNo; Integer) { AutoIncrement = true; }
        field(2; "Req. No."; Code[20])
        {
            trigger OnValidate()
            begin
                "Create Date" := CurrentDateTime;
                "Create By" := utility.UserFullName(UserId);
            end;
        }
        field(3; "Req. Date"; Date) { }
        field(4; "Req. By"; Code[20]) { TableRelation = "Salesperson/Purchaser".Code; }
        field(5; "Ref. Document"; Text[200]) { }
        field(6; "Remark"; Text[200]) { }
        field(7; "Process"; Enum "Prod. Process")
        {
            //  OptionMembers = " ",PD1,PD2,PD3,PD4,PD5,SGA,OTH,MFG;
            Caption = 'Section';
        }
        field(10; "Status"; Option)
        {
            OptionMembers = Open,Process,Completed,Cancel;
        }
        field(50; "Create Date"; DateTime) { }
        field(51; "Create By"; Text[50]) { }
        field(52; "Shipment No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Invt. Shipment Header"."No." where("External Document No." = field("Req. No.")));
        }
        field(50100; "Scaner"; Code[100])
        {

        }
        field(50101; "Scan Item"; Option)
        {
            OptionMembers = Kanban,Item;
        }
        field(50102; "From Washing"; Boolean)
        {

        }
        field(50110; "Approve Date"; DateTime)
        {

        }
        field(50111; "Approve By"; Code[50])
        {

        }
    }
    keys
    {
        key(key1; "Req. No.") { }
    }
    trigger OnDelete()
    var
        MDLLine: Record "Material Delivery Line";
    begin
        TestField(Status, Status::Open);
        MDLLine.Reset();
        MDLLine.SetRange("Document No.", Rec."Req. No.");
        if MDLLine.Find('-') then begin
            MDLLine.DeleteAll();
        end;
    end;

    trigger OnModify()
    begin
        // TestField(Status, Status::Open);
    end;

    var
        utility: Codeunit Utility;

}