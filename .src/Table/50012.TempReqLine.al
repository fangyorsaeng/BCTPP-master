table 50012 "Temporary DL Req. Line"
{
    DrillDownPageId = "Temporary Delivery Line List";
    fields
    {
        field(1; "Document No."; Code[20]) { }
        field(2; "Line No."; Integer) { }
        field(3; "Lot No."; Code[20]) { }
        field(4; "Quantity"; Decimal)
        {

            trigger OnValidate()
            begin
                calTotal(Rec, xRec);
                "Remain Qty" := Quantity - "Receipt Qty";
            end;
        }
        field(5; "Receipt Qty"; Decimal)
        {
            trigger OnValidate()
            begin
                "Remain Qty" := Quantity - "Receipt Qty";
            end;
        }
        field(6; Box; Integer) { }
        field(7; "Remain Qty"; Decimal)
        {
            Editable = false;
        }
        field(20; "Status"; Option)
        {
            OptionMembers = Waiting,Patial,Completed;
        }
        field(21; "Part No."; Code[50])
        {
            TableRelation = Item."No." where("For Washing" = filter(1));

            trigger OnValidate()
            var
                Items: Record Item;
            begin
                if "Part No." <> '' then begin
                    Items.Reset();
                    Items.SetRange("No.", "Part No.");
                    if Items.Find('-') then begin
                        "Part Name" := Items."Description";
                        "Transfer From Item No." := Items."From Material Item";
                    end;
                end;
            end;
        }
        field(22; "Part Name"; Text[250]) { }
        field(25; Totalx; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Temporary DL Req.".Total where(DLNo = field("Document No.")));
        }
        field(30; "Transfer From Item No."; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(31; "Cut from Stock"; Boolean)
        {
            Editable = false;
        }
        field(32; "Docu. Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Temporary DL Req."."Document Date" where(DLNo = field("Document No.")));
        }
    }
    keys
    {

        key(key1; "Document No.", "Line No.") { }

    }


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

        TestStatus();
    end;

    trigger OnDelete()
    begin
        TestStatus();
    end;

    var
        skipSatus: Boolean;
        ReqH: Record "Temporary DL Req.";

    procedure setSkip(sk: Boolean)
    begin
        skipSatus := sk;
    end;

    procedure TestStatus()
    begin
        if not skipSatus then begin
            TestField(Status, Status::Waiting);
            ReqH.Reset();
            ReqH.SetRange(DLNo, Rec."Document No.");
            ReqH.SetFilter(Status, '<>%1', ReqH.Status::Waiting);
            if ReqH.Find('-') then
                Error(ReqH.DLNo + ' Status Invalid!.');
        end;
    end;

    procedure calTotal(var Temp: Record "Temporary DL Req. Line"; var xTemp: Record "Temporary DL Req. Line")
    var
        TempH: Record "Temporary DL Req.";
        TempL: Record "Temporary DL Req. Line";
        Total1: Decimal;
    begin
        TempL.Reset();
        TempL.SetRange("Document No.", Temp."Document No.");
        if TempL.Find('-') then begin
            repeat
                Total1 += TempL.Quantity;
            until TempL.Next = 0;
        end;
        Total1 += Temp.Quantity - xTemp.Quantity;
        //Message(Format(Temp.Quantity) + '=' + format(xTemp.Quantity));

        TempH.Reset();
        TempH.SetRange(DLNo, Temp."Document No.");
        if TempH.Find('-') then begin
            TempH.Total := Total1;
            TempH.Modify();
        end;
    end;
}