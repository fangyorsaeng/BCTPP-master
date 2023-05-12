Table 50020 "Billing Ledger Entries"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Description = '';
        }
        field(2; "Transaction Type"; Option)
        {
            Description = '';
            OptionCaption = 'Sales Billing,Sales Receipt,Purchase Billing';
            OptionMembers = "Sales Billing","Sales Receipt","Purchase Billing";
        }
        field(3; "Transaction Entry No."; Integer)
        {
            Description = '';
            TableRelation = if ("Transaction Type" = filter("Sales Billing" | "Sales Receipt")) "Cust. Ledger Entry"."Entry No."
            else
            if ("Transaction Type" = filter("Purchase Billing")) "Vendor Ledger Entry"."Entry No.";
        }
        field(4; "Transaction Entry Type"; Option)
        {
            Description = '';
            OptionCaption = 'Initial,Application';
            OptionMembers = Initial,Application;
        }
        field(6; "Transcation Document No."; Code[20])
        {
            Description = '';
        }
        field(7; "Transaction Line No."; Integer)
        {
            Description = '';
        }
        field(10; "Amount (LCY)"; Decimal)
        {
            Description = '';

            trigger OnValidate()
            var
                BillingLedger: Record "Billing Ledger Entries";
            begin
            end;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Transaction Type", "Transaction Entry No.")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key3; "Transaction Entry No.", "Transaction Type", "Transcation Document No.", "Transaction Line No.")
        {
            SumIndexFields = "Amount (LCY)";
        }
    }

    fieldgroups
    {
    }
}

