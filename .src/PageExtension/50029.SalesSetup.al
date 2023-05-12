pageextension 50029 "Sales Setup Page Ex" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Default Cancel Reason Code")
        {
            field("Yen/Baht"; "Yen/Baht")
            {
                ApplicationArea = all;
            }
        }
        addafter("Direct Debit Mandate Nos.")
        {
            field("Billing Nos."; "Billing Nos.")
            {
                ApplicationArea = all;
            }
            field("Receipt No."; "Receipt No.")
            {
                ApplicationArea = all;
            }
            field("Material DLNo."; "Material DLNo.")
            {
                ApplicationArea = all;
            }
            field("Transfer Order"; "Transfer Order")
            {
                ApplicationArea = all;
            }
            field("Prod. Record"; "Prod. Record")
            {
                ApplicationArea = all;
            }
            field("Move Stock"; "Move Stock")
            {
                ApplicationArea = all;
            }
            field("NG List No."; "NG List No.")
            {
                ApplicationArea = all;
            }
        }
    }
}