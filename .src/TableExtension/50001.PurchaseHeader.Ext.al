tableextension 50001 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                "Create Date" := CurrentDateTime;
                "Create By" := utility.UserFullName(UserId);
                "FOB Point" := 'DESTINATION';
                "Shipment Method Code" := 'BEST WAY';
                // if "Document Type"="Document Type"::Quote then

            end;
        }
        modify("Document Date")
        {
            trigger OnAfterValidate()
            begin
                "Posting Date" := "Document Date";
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
        field(50053; "Rev"; Text[10]) { }
        field(50099; "Scaner"; Code[100]) { }

    }
    var
        utility: Codeunit Utility;
}