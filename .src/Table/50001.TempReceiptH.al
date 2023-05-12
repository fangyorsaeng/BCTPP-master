table 50001 "Temp. Receipt Header"
{
    fields
    {
        field(1; EntryNo; Integer) { AutoIncrement = true; }
        field(2; "Receipt No."; Code[20])
        {
            //No. Series  TEMPREC
            trigger OnValidate()
            begin
                "Create Date" := CurrentDateTime;
                "Create By" := utility.UserFullName(UserId);
                Status := Status::Open;
            end;
        }
        field(3; "Receipt Date"; Date) { }
        field(4; "Receipt By"; Text[50])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(5; "Note"; Text[200]) { }

        field(10; "Ref. No."; Code[30]) { }
        field(11; "Ref. Date"; Date) { }
        field(12; "Ref. By"; Text[50]) { }
        field(13; "Group"; Code[20])
        {
            TableRelation = "Set All Type".Code where(GType = filter(PD), Active = filter(true));
            // OptionMembers = OTH,PD1,PD3,PD2_W1,PD2_W2;
        }
        field(49; "Status"; Option) { OptionMembers = Open,Process,Completed,Cancel; }
        field(50; "Create Date"; DateTime) { }
        field(51; "Create By"; Text[50]) { }
        field(60; "Total"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Temp. Receipt Line".Quantity where("Document No." = field("Receipt No.")));
        }
        field(61; "TotalNG"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Temp. Receipt Line".NGQ where("Document No." = field("Receipt No.")));
        }
        field(70; "Skip Check"; Boolean)
        {
            Caption = 'Skip Check DL';
        }
    }
    keys
    {
        key(key1; "Receipt No.") { }
    }
    trigger OnModify()
    begin
        //if Status = 'Completed' then
        //    Error('Status Invalid!');
        TestField(Status, Status::Open);
    end;

    trigger OnDelete()
    begin
        TestField(Status, Status::Open);

    end;


    var
        utility: Codeunit Utility;

}