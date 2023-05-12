tableextension 50005 "Vendor Ext" extends Vendor
{
    fields
    {
        field(50000; "Supplier Code"; Code[30])
        {

        }
        field(50001; "Address 3"; Text[200])
        {

        }
        field(50002; "Name TH"; Text[200])
        {

        }
    }
    //keys(key40;"No.","Name"){}
    fieldgroups
    {
        addlast(DropDown; "Search Name") { }
    }
}