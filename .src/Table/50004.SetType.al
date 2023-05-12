table 50004 "Set All Type"
{
    LookupPageId = "Set Type List";
    fields
    {
        field(1; EntryNo; Integer) { AutoIncrement = true; }
        field(2; Code; Code[20]) { }
        field(3; Description; Text[200]) { }
        field(4; GType; Option) { OptionMembers = PD,Stutus,TMDL; }
        field(5; Active; Boolean) { }
    }
    keys
    {
        key(key1; Code, GType) { }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Description)
        {

        }
    }
}