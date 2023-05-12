table 50010 "Import Kanban"
{
    fields
    {
        field(1; Message; Text[100]) { }
        field(2; "Kanban No."; Code[50]) { }
        field(72; "Master No."; Code[50]) { }
        field(73; "Classification"; Text[20]) { }
        field(74; "Address"; Text[50]) { }
        field(75; "Location"; Text[50]) { }
        field(76; "Process"; Text[50]) { }
        field(77; "Tool#"; Text[50]) { }
        field(78; "Zone No."; Text[30]) { }
        field(79; "Shelf No."; Text[50]) { }
        field(3; "Part No."; Code[50])
        {

        }
        field(4; "Description"; Text[150]) { }
        field(5; "Model"; Text[150]) { }
        field(10; "Maker"; Text[250]) { }

        field(11; "Note"; Text[250]) { }
        field(12; "Qty"; Integer) { }
        field(13; "Run"; Integer) { }
        field(15; "Lead Time"; Text[20]) { }
        field(17; "Vendor"; Text[150])
        {
        }
        field(18; "Quotation"; Text[50])
        {
        }
        field(52; "Revision"; Text[250]) { }
        field(50; "Create By"; Text[50]) { }
        field(51; "Create Date"; DateTime) { }
        field(60; "Unit Price"; Decimal) { }
        field(61; "PD"; Enum "Prod. Process")
        {
            // OptionMembers = PD1,PD2,PD3,PD4,PD5,SGA,OTH;
        }


    }
    keys
    {
        key(key1; "Kanban No.") { }
    }
    fieldgroups
    {
        fieldgroup(DorpDown; "Master No.", "Part No.", Description) { }
    }
    var
        utility: Codeunit Utility;
}