Table 50019 "Sales Billing Line"
{
    fields
    {
        field(1; "Document Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Sales Billing,Sales Receipt,Purchase Billing';
            OptionMembers = "Sales Billing","Sales Receipt","Purchase Billing";
        }
        field(2; "Document No."; Code[20])
        {
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            Editable = false;
        }
        field(4; "Bill-to Customer No."; Code[20])
        {
        }
        field(5; "Cust. Ledger Entry No."; Integer)
        {
            Editable = false;
            // TableRelation = "Cust. Ledger Entry"."Entry No." where("Entry No." = field("Cust. Ledger Entry No."));
        }
        field(6; "Cust. Document Type"; enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
            Description = 'Customer Document Type';
            Editable = false;
        }
        field(7; "Cust. Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(8; "Cust. Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(9; "Cust. Original Amount (LCY)"; Decimal)
        {
            Caption = 'Original Amount (LCY)';
            Editable = false;
            trigger OnValidate()
            begin
                calAmount(Rec);
            end;
        }
        field(10; "Cust. Remaining Amt. (LCY)"; Decimal)
        {
            Caption = 'Remaining Amt. (LCY)';
            Editable = false;
        }
        field(11; "Cust. VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            Editable = false;
            trigger OnValidate()
            begin
                calAmount(Rec);
            end;
        }
        field(12; "Cust. Due Date"; Date)
        {
            Caption = 'Due Date';
            Editable = true;

            trigger OnValidate()
            var
                CustLedgerEntry: Record "Cust. Ledger Entry";
            begin
                //  CustLedgerEntry.Get("Cust. Ledger Entry No.");
                // CustLedgerEntry."Due Date" := "Cust. Due Date";
                // CustLedgerEntry.Modify;
            end;
        }
        field(13; "Cust. Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(14; "Cust. Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(20; "Amount (LCY)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            var
                BillingLedger: Record "Billing Ledger Entries";
                CustLedgerEntry: Record "Cust. Ledger Entry";
            begin
                SalesBillingHeader.Get("Document Type", "Document No.");
                SalesBillingHeader.TestField(Status, SalesBillingHeader.Status::Open);

                // CustLedgerEntry.Reset;
                // CustLedgerEntry.SetFilter("Entry No.", '%1', "Cust. Ledger Entry No.");
                // CustLedgerEntry.SetFilter("Document No. Filter", '<>%1', "Document No.");
                // if CustLedgerEntry.Find('-') then begin
                //     CustLedgerEntry.CalcFields("Billing Remaining Amt.");
                //     if (CustLedgerEntry."Billing Remaining Amt." - "Amount (LCY)") < 0 then
                //         TestField("Amount (LCY)", CustLedgerEntry."Billing Remaining Amt.");
                //     if "Amount (LCY)" * CustLedgerEntry."Billing Remaining Amt." < 0 then
                //         FieldError("Amount (LCY)", StrSubstNo(Text000, CustLedgerEntry.FieldCaption("Billing Remaining Amt.")));
                // end;

                BillingLedger.Reset;
                BillingLedger.SetFilter("Transaction Type", '%1', "Document Type");
                BillingLedger.SetFilter("Transcation Document No.", '%1', "Document No.");
                BillingLedger.SetFilter("Transaction Line No.", '%1', "Line No.");
                if BillingLedger.Find('-') then begin
                    BillingLedger."Amount (LCY)" := -"Amount (LCY)";
                    BillingLedger.Modify;
                end;
            end;
        }
        field(21; "Cust. External Due Date"; Date)
        {
            Caption = 'External Due Date';
            Editable = false;
        }
        field(48; "WHT"; Decimal)
        {
            trigger OnValidate()
            begin
                calAmount(Rec);
            end;
        }
        field(49; "WHT3"; Decimal)
        {
            trigger OnValidate()
            begin
                calAmount(Rec);
            end;
        }
        field(50; "WHT5"; Decimal)
        {
            trigger OnValidate()
            begin
                calAmount(Rec);
            end;
        }
        field(58; "Collected"; Text[50]) { }
        field(59; "Sale Invoice No."; Code[30])
        {

        }
        field(60; "Receipt No."; Code[30])
        {

        }
        field(61; "Receipt Line No."; Integer)
        {

        }

    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Bill-to Customer No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        SalesBillingHeader.Get("Document Type", "Document No.");
        SalesBillingHeader.TestField(Status, SalesBillingHeader.Status::Open);
        BillingLedgerEntry.Reset;
        BillingLedgerEntry.SetFilter("Transaction Type", '%1', "Document Type");
        BillingLedgerEntry.SetFilter("Transcation Document No.", '%1', "Document No.");
        BillingLedgerEntry.SetFilter("Transaction Line No.", '%1', "Line No.");
        if BillingLedgerEntry.Find('-') then
            BillingLedgerEntry.DeleteAll;
    end;

    var
        BillingLedgerEntry: Record "Billing Ledger Entries";
        SalesBillingHeader: Record "Sales Billing Header";
        Text000: label 'must have the same sign as %1';
        Text0055: label 'VAT %1%';

    procedure calAmount(var SalB: Record "Sales Billing Line")
    var
        Dbit: Code[2];
    begin
        Dbit := CopyStr(SalB."Document No.", 1, 2);
        if (SalB."Cust. Document Type" = SalB."Cust. Document Type"::Invoice) or (Dbit = 'DN') then begin
            SalB."Amount (LCY)" := (SalB."Cust. Original Amount (LCY)" + SalB."Cust. VAT Amount") - (SalB.WHT + SalB.WHT3 + SalB.WHT5);
            SalB."Cust. Remaining Amt. (LCY)" := SalB."Cust. Original Amount (LCY)" + SalB."Cust. VAT Amount" - (SalB.WHT + SalB.WHT3 + SalB.WHT5);
        end
        else
            if SalB."Cust. Document Type" = SalB."Cust. Document Type"::"Credit Memo" then begin
                SalB."Amount (LCY)" := (abs(SalB."Cust. Original Amount (LCY)") + abs(SalB."Cust. VAT Amount")) * -1;
                SalB."Cust. Remaining Amt. (LCY)" := (abs(SalB."Cust. Original Amount (LCY)") + abs(SalB."Cust. VAT Amount")) * -1;

            end;

    end;

    procedure CalcVATAmountLines(var SalesBillingHeader: Record "Sales Billing Header"; var SalesBillingLine: Record "Sales Billing Line"; var TotalAmount: Decimal; var TotalVATAmount: Decimal; var TotalAmountIncVAT: Decimal; var VATText: Text[30])
    var
        Currency: Record Currency;
        AmountExclVAT: Decimal;
        VATAmount: Decimal;
    begin
        Currency.InitRoundingPrecision;
        Clear(TotalAmount);
        Clear(TotalVATAmount);
        Clear(TotalAmountIncVAT);
        SalesBillingLine.Reset;
        SalesBillingLine.SetFilter("Document Type", '%1', SalesBillingHeader."Document Type");
        SalesBillingLine.SetFilter("Document No.", '%1', SalesBillingHeader."No.");
        if SalesBillingLine.Find('-') then
            repeat
                AmountExclVAT := SalesBillingLine."Cust. Original Amount (LCY)" - SalesBillingLine."Cust. VAT Amount";
                VATAmount := SalesBillingLine."Cust. VAT Amount";
                TotalAmount += SalesBillingLine."Amount (LCY)" - VATAmount;
                TotalVATAmount += VATAmount;
            until Next = 0;
        if TotalVATAmount = 0 then
            VATText := StrSubstNo(Text0055, 0)
        else
            VATText := StrSubstNo(Text0055, 7);

        TotalAmountIncVAT := TotalAmount + TotalVATAmount;

    end;

    procedure CalcRemainingAmountLines(var tblSalesBillingHeader: Record "Sales Billing Header"; var tblSalesBillingLine: Record "Sales Billing Line"; var xTotalRemainingAmount: Decimal)
    var
        tblCurrency: Record Currency;
    begin
        tblCurrency.InitRoundingPrecision;
        Clear(xTotalRemainingAmount);
        tblSalesBillingLine.Reset;
        tblSalesBillingLine.SetFilter("Document Type", '%1', tblSalesBillingHeader."Document Type");
        tblSalesBillingLine.SetFilter("Document No.", '%1', tblSalesBillingHeader."No.");
        if tblSalesBillingLine.Find('-') then
            repeat
                xTotalRemainingAmount += tblSalesBillingLine."Cust. Remaining Amt. (LCY)";
            until tblSalesBillingLine.Next = 0;
    end;
}

