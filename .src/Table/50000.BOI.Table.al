table 50000 "BOI List"
{
    LookupPageId = "BOI List";
    fields
    {
        field(1; "Code"; Code[20])
        {

        }
        field(2; "Description"; Text[250])
        {

        }
        field(3; "Type"; Text[20])
        {

        }
        field(4; "Active"; Boolean)
        {

        }
    }
    keys
    {
        key(key1; Code)
        {

        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Description) { }
    }

}