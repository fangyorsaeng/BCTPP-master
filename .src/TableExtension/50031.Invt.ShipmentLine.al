tableextension 50031 "Invt. Shipment Line Ex" extends "Invt. Shipment Line"
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
            "Item No." = field("Item No."), "Document Line No." = field("Line No."), "Document Type" = filter("Inventory Shipment")));
        }
        field(50062; "Customer"; Code[20]) { }
    }
    trigger OnAfterDelete()
    begin
        //Message(Format(xRec."Document No."));
    end;

}