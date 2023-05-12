tableextension 50032 "Invt. Receipt Line Ex" extends "Invt. Receipt Line"
{
    fields
    {
        field(50091; "Remark Line"; Code[10]) { }
        field(50050; "MDLH No."; Code[20]) { }
        field(50051; "MDLH Line No."; Integer) { }
        field(50061; "Lot No."; Code[50])
        {

            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."Lot No." where("Document No." = field("Document No."),
            "Item No." = field("Item No."), "Document Line No." = field("Line No."), "Document Type" = filter("Inventory Receipt")));
        }
    }

}