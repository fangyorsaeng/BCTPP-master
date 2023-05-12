table 50006 "Temp Report"
{
    fields
    {
        field(1; RowNo; Integer) { }
        field(2; Year; Code[10]) { }
        field(3; "Part No."; Code[50]) { }
        field(4; "Part Name"; Text[250]) { }
        field(5; "JAN"; Decimal) { }
        field(6; "FEB"; Decimal) { }
        field(7; "MAR"; Decimal) { }
        field(8; "APR"; Decimal) { }
        field(9; "MAY"; Decimal) { }
        field(10; "JUN"; Decimal) { }
        field(11; "JUL"; Decimal) { }
        field(12; "AUG"; Decimal) { }
        field(13; "SEP"; Decimal) { }
        field(14; "OCT"; Decimal) { }
        field(15; "NOV"; Decimal) { }
        field(16; "DEC"; Decimal) { }
        field(17; "SType"; Code[20]) { }
        field(18; "SUserID"; Text[50]) { }
        field(19; "Total"; Decimal) { }
        field(20; "Item Cat."; Text[50]) { }
        field(21; "CRow"; Integer) { }
        field(30; "Description"; Text[250]) { }
        field(31; "Description 2"; Text[250]) { }
        field(32; "Inventory Posting Group"; Code[25]) { }

    }
    keys
    {
        key(key1; RowNo, Year, "Part No.", SType, SUserID) { }
    }
}