tableextension 50029 "Invt. Document Line Ex" extends "Invt. Document Line"
{
    fields
    {
        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                if "Inventory Posting Group" = 'FG' then
                    "Reason Code" := 'DELIVERY'
                else
                    "Reason Code" := 'FACTORY';

                "Shortcut Dimension 1 Code" := '';
                "Shortcut Dimension 2 Code" := '';

            end;
        }
        field(50091; "Remark Line"; Code[10]) { }
        field(50050; "MDLH No."; Code[20]) { }
        field(50051; "MDLH Line No."; Integer) { }
    }
}