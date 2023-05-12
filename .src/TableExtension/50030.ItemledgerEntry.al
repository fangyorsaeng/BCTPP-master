tableextension 50030 "Item Ledger Entry Ex" extends "Item Ledger Entry"
{
    fields
    {
        field(50300; "Create Date"; DateTime) { }
        field(503001; "Create By"; Code[50]) { }
        field(503002; "Use Sales Order"; Boolean) { }
        field(503003; "Undo"; Boolean) { }
        field(503004; "Undo Document No."; Code[20]) { }
        field(503005; Customer; Code[30]) { }
        field(503006; "Ref. Other No"; Code[50]) { }

        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                "Create Date" := CurrentDateTime;
                "Create By" := utility.UserFullName(UserId);
            end;
        }
    }
    trigger OnInsert()
    begin
        "Create Date" := CurrentDateTime;
        "Create By" := utility.UserFullName(UserId);
    end;

    var
        utility: Codeunit Utility;
}