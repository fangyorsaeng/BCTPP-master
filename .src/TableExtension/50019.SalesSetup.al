tableextension 50019 "Sales Setup ex" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Yen/Baht"; Decimal)
        {

        }
        field(50001; "Billing Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50002; "Receipt No."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50003; "Material DLNo."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50004; "Transfer Order"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50005; "Prod. Record"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50006; "Move Stock"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50007; "NG List No."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
    }
}