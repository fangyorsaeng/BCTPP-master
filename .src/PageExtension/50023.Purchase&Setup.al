pageextension 50023 "Purchase & Setup Ex" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Posted Prepmt. Cr. Memo Nos.")
        {
            field("Temp Nos."; "Temp Nos.")
            {
                ApplicationArea = all;
            }
            field("Temp. DL No."; "Temp. DL No.")
            {
                ApplicationArea = all;

            }
            field("Temp RCNo."; "Temp RCNo.")
            {
                ApplicationArea = all;
            }
        }
    }
}