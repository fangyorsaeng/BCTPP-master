tableextension 50009 "Whse. Receipt Header Ex" extends "Warehouse Receipt Header"
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
        field(50000; "Create Date"; DateTime)
        {

        }
        field(50001; "Create By"; Text[50])
        {

        }
        field(50002; "Receipt By"; Text[50])
        {
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(50010; "Invoice No"; Text[50])
        {

        }
        field(50011; "Invoice Date"; Date)
        {

        }

    }
    var
        utility: Codeunit Utility;
}