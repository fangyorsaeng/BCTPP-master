pageextension 50018 "SalesPersonCode" extends "Salespersons/Purchasers"
{
    layout
    {
        addafter("Phone No.")
        {
            field(Image; Image)
            { ApplicationArea = all; }
        }
        addafter(Name)
        {
            field("Full Name"; "Full Name")
            {
                ApplicationArea = all;
            }
            field("Full Name Thai"; "Full Name Thai")
            {
                ApplicationArea = all;
            }
            field("E-Mail"; "E-Mail") { ApplicationArea = all; }

        }
    }
}