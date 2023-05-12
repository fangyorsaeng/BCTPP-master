tableextension 50004 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        modify("No.")
        {
            Caption = 'Part No.';
            CaptionClass = 'Part No.';

        }
        field(50000; "Sales Status"; Option)
        {
            OptionMembers = Open,Cancel,Discon;
        }
        field(50100; "Annual Usage Text"; Text[20])
        {
            Caption = 'Usage';

        }
        field(50101; "Annual Usage Amount"; Decimal)
        {

        }
        field(50060; "Customer Item No."; Text[250])
        {

        }
        field(50061; "Customer Item Name"; Text[250])
        {

        }
        field(50062; "Short Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Search Name" where("No." = field("Sell-to Customer No.")));
        }
        field(50063; "Item Ledger Entry No"; Integer)
        {

        }
        field(50308; "Order No."; Code[30])
        {
            Editable = false;
        }
        field(50309; "Order Line No."; Integer)
        {
            Editable = false;
        }
        field(50310; "Invoice No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Document No." where("Document Type" = filter(Invoice), "Order No." = field("Document No."), "Order Line No." = field("Line No.")));
        }



    }
}
