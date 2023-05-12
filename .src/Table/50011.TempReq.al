table 50011 "Temporary DL Req."
{

    fields
    {
        field(1; EntryNo; BigInteger) { AutoIncrement = true; }
        field(2; "Part No."; Code[50])
        {
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                ItemS: Record Item;
            begin
                "Create Date" := CurrentDateTime;
                "Create By" := utility.UserFullName(UserId);
                Status := Status::Waiting;
                //Group := Group::OTH;
                if "Part No." <> '' then begin
                    ItemS.Get("Part No.");
                    "Part Name" := ItemS.Description;
                    Supplier := ItemS."Vendor Name";
                end;
            end;
        }
        field(3; "Part Name"; Text[250]) { }
        field(4; "Process"; Text[100])
        {
            TableRelation = "Process List"."Process Name";
            trigger OnValidate()
            var
                ItemS: Record Item;
            begin
                "Create Date" := CurrentDateTime;
                "Create By" := utility.UserFullName(UserId);
                Status := Status::Waiting;
                //  Group := Group::OTH;
                // if "Part No." <> '' then begin
                //     ItemS.Get("Part No.");
                //     "Part Name" := ItemS.Description;
                //     Supplier := ItemS."Vendor Name";
                // end;
            end;
        }
        field(5; "Note"; Text[250]) { }
        field(6; "Supplier"; Text[200]) { }
        //  field(8; "S Code"; Code[20]) { TableRelation = Vendor."No."; }
        field(7; "Document Date"; Date) { }
        //field(8; "Lot No."; Code[30]) { }
        field(9; "DateShiped"; Date) { }
        field(10; "Total"; Decimal) { AutoFormatType = 0; }
        field(15; "Box 1"; Integer) { }
        field(16; "Box 2"; Integer) { }
        field(17; "Cover 1"; Integer) { }
        field(18; "Cover 2"; Integer) { }
        field(19; "Plastic Pallet"; Integer) { }
        field(20; "Wood Pallet"; Integer) { }
        field(21; "Status"; Option)
        {
            OptionMembers = Waiting,Process,Cancel,Patial,Completed;
        }
        field(22; "Req By."; Text[50])
        {
            Caption = 'Req By.';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }


        field(30; "Group"; Code[20])
        {
            // OptionMembers = OTH,PD1,PD3,PD2_W1,PD2_W2;
            TableRelation = "Set All Type".Code where(GType = filter(PD), Active = filter(true));
            trigger OnValidate()
            var
                DateS: Code[20];
            begin

            end;
        }
        field(50; "Create Date"; DateTime)
        {

        }
        field(51; "Create By"; Text[50])
        {

        }
        field(55; "DLNo"; Code[20])
        {

        }

        field(101; "Supplier Code"; Code[20])
        {
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                Vens: Record Vendor;
            begin
                Vens.Reset();
                Vens.SetRange("No.", "Supplier Code");
                if Vens.Find('-') then begin
                    Supplier := Vens.Name;
                    "Supplier Name" := Vens.Name;
                    "Contact Name" := Vens.Contact;
                    "Supplier Address 1" := Vens.Address;
                    "Supplier Address 2" := Vens."Address 2";
                    "Phone No." := Vens."Phone No.";
                    "Fax No." := Vens."Fax No.";
                    Email := Vens."E-Mail";
                    "Create By" := utility.UserFullName(UserId);
                    "Create Date" := CurrentDateTime;
                end;
            end;
        }
        field(102; "Supplier Name"; Text[250]) { }
        field(103; "Supplier Address 1"; Text[250]) { }
        field(104; "Supplier Address 2"; Text[250]) { }
        field(105; "Phone No."; Text[100]) { }
        field(106; "Fax No."; Text[100]) { }
        field(107; "Email"; Text[100]) { }
        field(108; "Contact Name"; Text[100]) { }
        field(109; "TDNo"; Code[20]) { }
        field(110; "Ref. PONo."; Code[20]) { }
        field(111; "Temp. Date"; Date) { }
        field(112; "Temp. By"; Text[50]) { }
        field(113; "Cut Stock"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Temporary DL Req. Line"."Cut from Stock" where("Document No." = field(DLNo), "Cut from Stock" = filter(<> false)));
        }
        field(114; "Fix TempDL"; Boolean)
        {

        }


    }
    keys
    {
        key(key1; DLNo) { }
    }
    fieldgroups
    {
        fieldgroup(Dorpdown; "Part No.", "Part Name", Process, Group) { }
    }
    trigger OnDelete()
    begin
        TestField(Status, Status::Waiting);
    end;

    trigger OnModify()
    begin
        // TestField(Status, Status::Waiting);
    end;

    var
        utility: Codeunit Utility;

    procedure calTotalH(DocNo: Code[20])
    var
        TempH: Record "Temporary DL Req.";
        TempL: Record "Temporary DL Req. Line";
        Total1: Decimal;
    begin
        TempL.Reset();
        TempL.SetRange("Document No.", DocNo);
        if TempL.Find('-') then begin
            repeat
                Total1 += TempL.Quantity;
            until TempL.Next = 0;
        end;

        TempH.Reset();
        TempH.SetRange(DLNo, TempL."Document No.");
        if TempH.Find('-') then begin
            TempH.Total := Total1;
            TempH.Modify();
        end;
    end;
}