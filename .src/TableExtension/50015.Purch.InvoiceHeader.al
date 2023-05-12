tableextension 50015 "Purch. Inv Header Ext" extends "Purch. Inv. Header"
{
    fields
    {
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                "Create Date" := CurrentDateTime;
                "Create By" := utility.UserFullName(UserId);
            end;
        }
        field(50000; "Create Date"; DateTime)
        {

        }
        field(50001; "Create By"; Text[50])
        {

        }
        field(50002; "Send Email to Vendor"; Boolean)
        {

        }
        field(50003; "FOB Point"; Text[50])
        {

        }

        field(50010; "Invoice No"; Text[50])
        {

        }
        field(50011; "Invoice Date"; Date)
        {

        }
        field(50050; "BOI Code"; Code[20])
        {
            TableRelation = "BOI List";
        }
        field(50051; "Cancel Date"; Date)
        {

        }
        field(50052; "Cancel Reason"; Text[100])
        {

        }
    }
    var
        utility: Codeunit Utility;
}