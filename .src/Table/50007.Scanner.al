table 50007 "Scanner"
{
    fields
    {
        field(1; EntryNo; Integer) { }
        field(3; "Part No."; Code[50]) { }
        field(4; "Part Name"; Text[250]) { }
        field(5; "Quantity"; Decimal) { }
        field(6; "SDate"; Date) { }
        field(7; "Price"; Decimal) { }
        field(8; "CustPO"; Code[30]) { }
        field(17; "SType"; Code[20]) { }
        field(18; "SUserID"; Text[50]) { }
        field(19; "Total"; Decimal) { }
        field(20; "Item Cat."; Text[50]) { }
        field(21; "CRow"; Integer) { }
        field(22; "RefNo"; Code[50]) { }
        field(23; "Unit"; Code[20]) { }
    }
    keys
    {
        key(key1; EntryNo, SUserID, "Part No.", SType) { }
    }
}