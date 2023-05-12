table 50016 "Sales Line Annual Usage"
{

    fields
    {
        field(1; "Document No."; Code[20]) { }
        field(2; "Line No."; Integer) { }
        field(10; "Annual Text"; Text[20]) { }
        field(11; "Annual Usage"; Decimal) { }
        field(12; "PricePerPcs"; Decimal) { }
        field(13; "Raw Material Timing"; Text[50]) { }
    }
    keys
    {
        key(key1; "Document No.", "Line No.") { }
    }
}