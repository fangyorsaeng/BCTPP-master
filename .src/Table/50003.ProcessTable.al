table 50003 "Process List"
{
    fields
    {
        field(1; "Process Name"; Text[100]) { }
        field(2; "Process Type"; Enum "Prod. Process")
        {
            //  OptionMembers = PD1,PD2,PD3,PD4,PD5,SGA,OTH,MFG;
        }
        field(4; "Active"; Boolean) { }
    }
    keys
    {
        key(key1; "Process Name") { }
    }
}