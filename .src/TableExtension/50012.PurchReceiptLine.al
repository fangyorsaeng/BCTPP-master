tableextension 50012 "Purch. Receipt Line Ex" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50050; "PO Status"; Option)
        {
            OptionMembers = Open,Cancel,Discon;
        }
        field(50000; "Create Date"; DateTime)
        {

        }
        field(50001; "Create By"; Text[50])
        {

        }
        field(50002; "Ref. Whse No."; Text[20])
        {

        }
        field(50005; "Grade"; Text[50])
        {

        }
        field(50006; "Size"; Text[30])
        {

        }
        field(50007; "Heat"; Text[50])
        {

        }
        field(50008; "Inspection"; Text[30])
        {

        }
        field(50010; "Invoice No"; Text[50])
        {

        }
        field(50011; "Invoice Date"; Date)
        {

        }
    }
}