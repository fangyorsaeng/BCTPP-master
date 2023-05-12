tableextension 50025 "Whs. Shipment Header" extends "Warehouse Shipment Header"
{
    fields
    {
        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                "Create By" := utility.UserFullName(UserId);
                "Create Date" := CurrentDateTime;
                "Assignment Date" := Today;
                "Assignment Time" := Time;
                "Sorting Method" := "Sorting Method"::Item;

            end;
        }
        modify("Posting Date")
        {
            trigger OnAfterValidate()
            begin
                "Shipment Date" := "Posting Date";
            end;
        }
        modify("Assigned User ID")
        {
            TableRelation = User."User Name";
        }
        field(50000; "Create Date"; DateTime)
        {

        }
        field(50001; "Create By"; Text[50])
        {

        }
        field(50002; "Ship By"; Text[50])
        {
            TableRelation = "Salesperson/Purchaser".Code;
        }

        field(50010; "Ref. Invoice No"; Text[50])
        {

        }

    }
    var
        utility: Codeunit Utility;
}