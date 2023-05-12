table 50009 "CLASSFICATION"
{
    fields
    {
        field(6; "No."; Code[10]) { }
        field(7; "Code"; Code[20]) { }
        field(8; "Name"; Text[50]) { }
        field(9; "Description"; Text[100]) { }
    }
    keys
    {
        key(key1; "No.") { }
    }
    fieldgroups
    {
        fieldgroup(Dropdown; "No.", Code, Name, Description) { }
    }

}