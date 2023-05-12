tableextension 50017 "Purchase & Setup Ex" extends "Purchases & Payables Setup"
{
    fields
    {
        field(500001; "Temp Nos."; Code[20]) { TableRelation = "No. Series".Code; }
        field(50002; "Temp. DL No."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50003; "Temp RCNo."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
    }
}