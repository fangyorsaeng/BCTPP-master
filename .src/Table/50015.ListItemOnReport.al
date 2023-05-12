table 50015 "List Item On Report"
{

    fields
    {
        field(1; "Part No."; Code[30])
        {
            // TableRelation = Item."No.";
            trigger OnValidate()
            var
                ItemS: Record Item;
            begin
                if "Part No." <> '' then begin
                    ItemS.Reset();
                    ItemS.SetRange("No.", "Part No.");
                    if ItemS.Find('-') then begin
                        "Part Name" := ItemS.Description;
                    end;
                end;
            end;
        }
        field(2; "Part Name"; Text[200])
        {
            // Editable = false;
        }
        field(3; "Report Type"; Option)
        {
            OptionMembers = " ",Sales,Factory,Supplier;
        }
        field(4; "Group PD"; Enum "Prod. Process")
        {
            Caption = 'Section';
        }
        field(5; "Type Item"; Option)
        {

            OptionMembers = " ",Receive,Delivery,Production;
        }

        field(10; "Active"; Boolean)
        {

        }
        field(11; "Seq"; Integer)
        {

        }
        field(14; "Group Name"; Code[20]) { }
        field(15; "Editable"; Boolean)
        {
            Caption = 'Disable-Edit';

        }
        field(100; EntryNo; Integer) { AutoIncrement = true; }
    }
    keys
    {
        key(key1; "Group Name", Seq, "Group PD", "Report Type", "Type Item", "Part No.", EntryNo) { }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Part No.", "Part Name", "Group Name")
        {

        }
    }
}