tableextension 50002 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                ItemS: Record Item;
                VendorS: Record Vendor;
            begin
                if (Rec."No." <> '') and (Rec.Type = Rec.Type::Item) then begin
                    ItemS.Reset();
                    ItemS.Get("No.");
                    if ItemS.Location <> '' then
                        Rec.Validate("Location Code", ItemS.Location);
                    Rec.Maker := ItemS.Maker;
                    Rec.LeadTime := ItemS."Lead Time";
                    Rec."Supplier Name" := ItemS."Vendor Name";
                    Rec."Ref Quote No." := ItemS."Ref. Quotation";
                    Rec.Classification := ItemS.Classification;

                end;
            end;
        }
        field(50050; "PO Status"; Option)
        {
            OptionMembers = Open,Cancel,Discon;
        }

        field(50000; "Create Date"; DateTime)
        {

        }
        field(50001; "Create By"; Text[50])
        {

        }
        field(50002; "Ref. Whse No."; Text[20])
        {

        }
        field(50005; "Grade"; Text[50])
        {

        }
        field(50006; "Size"; Text[30])
        {

        }
        field(50007; "Heat"; Text[50])
        {

        }
        field(50008; "Inspection"; Text[30])
        {

        }
        field(50010; "Invoice No"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Line"."Invoice No" where("Order No." = field("Document No."), "Order Line No." = field("Line No.")));
        }
        field(50011; "Invoice Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Line"."Invoice Date" where("Order No." = field("Document No."), "Order Line No." = field("Line No.")));
        }
        field(50012; "Document Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."Document Date" where("No." = field("Document No.")));

        }
        field(50013; "Select"; Boolean)
        {
            trigger OnValidate()
            begin
                "Select UserID" := UserId;
            end;
        }
        field(50014; "Select UserID"; Code[50]) { }
        field(50015; "Ref Quote No."; Code[30]) { }
        field(50016; "Maker"; Code[30]) { }
        field(50017; "LeadTime"; Text[50]) { }
        field(50018; "Classification"; Text[30]) { }
        field(50019; "Kanban No."; Text[20]) { }
        field(50053; "Supplier Name"; Text[200])
        {

        }
        field(50054; "Quote No."; Text[100])
        {

        }
        field(50055; "Quote Line"; Integer)
        {

        }
        field(50056; "PO No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Line"."Document No." WHERE("Quote No." = FIELD("Document No."), "Document Type" = filter(Order), "Quote Line" = field("Line No.")));
        }
        field(50057; "PO Date"; DateTime)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Header"."Create Date" WHERE("No." = FIELD("PO No.")));

        }
        field(50058; "PO By"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Header"."Create By" WHERE("No." = FIELD("PO No.")));
        }
        field(50059; "H Status"; Enum "Purchase Document Status")
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".Status where("No." = field("Document No.")));
        }
        field(50060; RMQty; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Line"."Outstanding Qty. (Base)" WHERE("Quote No." = FIELD("Document No."), "Document Type" = filter(Order), "Quote Line" = field("Line No.")));
        }
    }
}