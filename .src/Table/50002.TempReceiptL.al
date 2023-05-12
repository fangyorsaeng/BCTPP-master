table 50002 "Temp. Receipt Line"
{
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
            end;
        }
        field(5; "NGQ"; Decimal)
        {

            trigger OnValidate()
            begin
                calTotal(Rec, xRec);
            end;
        }
        field(6; "Line Total"; Decimal)
        {

            trigger OnValidate()
            begin
                // calTotal(Rec, xRec);
            end;
        }
        field(8; "Remain Qty"; Decimal) { }
        field(9; Box; Integer) { }
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
                    end;
                end;
            end;


        }
        field(22; "Part Name"; Text[250]) { }
        field(25; Totalx; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Temp. Receipt Header".Total where("Receipt No." = field("Document No.")));
        }
        // field(30; "Qty on Supplier"; Decimal)
        // {
        //     // DecimalPlaces = 0 : 0;
        //     // Editable = false;
        //     // FieldClass = FlowField;
        //     // CalcFormula = sum("Temporary DL Req. Line"."Remain Qty" where("Remain Qty" = filter(> 0),
        //     //                                                               "Part No." = field("Part No.")));
        // }
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

        // TestStatus();
        TestField(Status, Status::Waiting);
    end;

    trigger OnDelete()
    begin
        TestField(Status, Status::Waiting);
    end;


    var
        skipSatus: Boolean;
        ReqH: Record "Temp. Receipt Header";

    procedure setSkip(sk: Boolean)
    begin
        skipSatus := sk;
    end;

    procedure TestStatus()
    begin
        if not skipSatus then begin
            TestField(Status, Status::Waiting);
            ReqH.Reset();
            ReqH.SetRange("Receipt No.", Rec."Document No.");
            ReqH.SetFilter(Status, '%1', ReqH.Status::Open);
            if ReqH.Find('-') then
                Error(ReqH."Receipt No." + ' Status Invalid!.');
        end;
    end;

    procedure calTotal(var Temp: Record "Temp. Receipt Line"; var xTemp: Record "Temp. Receipt Line")
    var
        TempH: Record "Temp. Receipt Header";
        TempL: Record "Temp. Receipt Line";
        Total1: Decimal;
    begin
        TempL.Reset();
        TempL.SetRange("Document No.", Temp."Document No.");
        if TempL.Find('-') then begin
            repeat
                Total1 += TempL.Quantity + TempL.NGQ;
                TempL.Validate("Line Total", TempL.Quantity + TempL.NGQ);
                TempL.Modify();
            until TempL.Next = 0;
        end;
        Total1 += (Temp.Quantity + Temp.NGQ) - (xTemp.Quantity + xTemp.NGQ);
        //Message(Format(Temp.Quantity) + '=' + format(xTemp.Quantity));

        TempH.Reset();
        TempH.SetRange("Receipt No.", Temp."Document No.");
        if TempH.Find('-') then begin
            TempH.Total := Total1;
            TempH.Modify();
        end;
    end;
}