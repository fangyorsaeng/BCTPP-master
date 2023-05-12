pageextension 50041 "SalespersonAndPruch Card" extends "Salesperson/Purchaser Card"
{
    layout
    {
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
            field(Dept; Dept)
            {
                ApplicationArea = all;
            }

        }
        modify("E-Mail")
        {
            Visible = true;
        }
        modify("Phone No.")
        {
            Visible = true;
        }
    }
}