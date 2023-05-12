table 50008 "Kanban List"
{
    fields
    {
        field(1; EntryNo; BigInteger) { AutoIncrement = true; }
        field(2; "Master No."; Code[50]) { }
        field(72; "Seq"; Integer) { }
        field(73; "Classification"; Text[20]) { TableRelation = CLASSFICATION."No."; }
        field(74; "Address"; Text[50]) { }
        field(75; "Location"; Text[50]) { TableRelation = Location.Code; }
        field(76; "Process"; Text[50]) { TableRelation = "Process List"."Process Name"; }
        field(77; "Tool#"; Text[50]) { }
        field(78; "Zone No."; Text[30]) { }
        field(79; "Shelf No."; Text[50]) { }
        field(3; "Part No."; Code[50])
        {
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                ItemS: Record Item;
                vendorS: Record Vendor;
            begin

                ItemS.Reset();
                if Rec."Part No." <> '' then begin
                    ItemS.Get(Rec."Part No.");
                    Rec."Part Name" := ItemS.Description;
                    Rec.Model := ItemS."Description 2";
                    // Rec.Vendor := ItemS."Vendor Name";
                    // Rec.Maker := ItemS.Maker;
                    // Rec.Quotation := ItemS."Ref. Quotation";
                    Rec."Create By" := utility.UserFullName(UserId);
                    Rec."Create Date" := CurrentDateTime;
                    Rec."Lead Time" := Format(ItemS."Lead Time Calculation");
                    Rec.Location := ItemS.Location;
                    Rec.Revision := '';
                    Rec.Classification := ItemS.Classification;
                    Rec."Zone No." := ItemS."Zone No.";
                    Rec."Shelf No." := ItemS."Shelf No.";

                    Rec.Qty := 1;
                    Rec.Run := 1;
                end;
                CalcFields(Vendor);
                CalcFields(Maker);
                CalcFields(Quotation);

            end;
        }
        field(4; "Part Name"; Text[150]) { }
        field(5; "Model"; Text[150]) { }
        field(10; "Maker"; Text[250]) { FieldClass = FlowField; CalcFormula = lookup(Item.Maker where("No." = field("Part No."))); }
        field(11; "Note"; Text[250]) { }
        field(12; "Qty"; Integer) { }
        field(13; "Run"; Integer) { }
        field(15; "Lead Time"; Text[30]) { }
        field(16; "Vendor No."; Code[20])
        {
            // FieldClass = FlowField;
            // CalcFormula = lookup(Item."Vendor No." where("No." = field("Part No.")));
        }
        field(17; "Vendor"; Text[150])
        {

            FieldClass = FlowField;
            CalcFormula = lookup(Item."Vendor Name" where("No." = field("Part No.")));
        }
        field(18; "Quotation"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Ref. Quotation" where("No." = field("Part No.")));
        }
        field(19; "Status"; Option) { OptionMembers = Active,Cancel; }
        field(50; "Create By"; Text[50]) { }
        field(51; "Create Date"; DateTime) { }
        field(52; "Revision"; Text[250]) { }


    }
    keys
    {
        key(key1; "Master No.") { }
    }
    fieldgroups
    {
        fieldgroup(DorpDown; "Master No.", "Part No.", "Part Name") { }
    }
    var
        utility: Codeunit Utility;
}