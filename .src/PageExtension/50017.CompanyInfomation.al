pageextension 50017 "Company Infomation Ex" extends "Company Information"
{
    layout
    {
        addafter("Ship-to Contact")
        {
            field("Ship-to-Phone"; "Ship-to-Phone")
            {
                ApplicationArea = all;
            }
            field("Ship-to-Fax"; "Ship-to-Fax")
            {
                ApplicationArea = all;
            }
            field("Ship-to-Branch"; "Ship-to-Branch")
            {
                ApplicationArea = all;
            }
        }
    }
}