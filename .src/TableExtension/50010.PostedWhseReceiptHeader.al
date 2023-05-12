tableextension 50010 "Posted Whse. Recpt. Ex" extends "Posted Whse. Receipt Header"
{
    fields
    {
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
    trigger OnAfterInsert()
    begin
        "Create By" := utility.UserFullName(UserId);
        "Create Date" := CurrentDateTime;
        "Assignment Date" := Today;
        "Assignment Time" := Time;
    end;

    var
        utility: Codeunit Utility;
}