table 50025 "Production Record Header"
{
    fields
    {
        field(1; EntryNo; Integer) { AutoIncrement = true; }
        field(2; "Req. No."; Code[20])
        {
            Caption = 'Record No.';
            trigger OnValidate()
            begin
                "Create Date" := CurrentDateTime;
                "Create By" := utility.UserFullName(UserId);
            end;
        }
        field(3; "Req. Date"; Date)
        {
            Caption = 'Record Date';
            trigger OnValidate()
            begin
                "Create Date" := CurrentDateTime;
                "Create By" := utility.UserFullName(UserId);
            end;
        }
        field(4; "Req. By"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser".Code;
            Caption = 'Record by';
        }
        field(5; "Ref. Document"; Text[200]) { }
        field(6; "Remark"; Text[200]) { }
        field(7; "Process"; Enum "Prod. Process")
        {
            Caption = 'Section';
            //  OptionMembers = " ",PD1,PD2,PD3,PD4,PD5,SGA,OTH,MFG;
        }
        field(8; "Process Name"; Code[50])
        {
            TableRelation = "Process List"."Process Name";
        }
        field(10; "Status"; Option)
        {
            OptionMembers = Open,Process,Completed,Cancel;
        }
        field(50; "Create Date"; DateTime) { }
        field(51; "Create By"; Text[50]) { }
        field(50100; "Scaner"; Code[100])
        {

        }
        field(50101; "Scan Item"; Option)
        {
            OptionMembers = Kanban,Item;
        }
    }
    keys
    {
        key(key1; "Req. No.") { }
    }
    trigger OnDelete()
    var
        MDLLine: Record "Production Record Line";
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