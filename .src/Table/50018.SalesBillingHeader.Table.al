Table 50018 "Sales Billing Header"
{
    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'Sales Billing,Sales Receipt,Purchase Billing';
            OptionMembers = "Sales Billing","Sales Receipt","Purchase Billing";
        }
        field(2; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SalesSetup.Get;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                end;
            end;
        }
        field(3; "Posting Date"; Date)
        {
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(4; "Document Date"; Date)
        {
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                Validate("Payment Terms Code");
            end;
        }
        field(10; "Bill-to Customer No."; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if ("Bill-to Customer No." <> xRec."Bill-to Customer No.") and (xRec."Bill-to Customer No." <> '') then begin
                    if not Confirm(Text001, false, FieldCaption("Bill-to Customer No.")) then
                        Error('');

                    SalesBillingLine.Reset;
                    SalesBillingLine.SetFilter("Document Type", '%1', "Document Type");
                    SalesBillingLine.SetFilter("Document No.", '%1', "No.");
                    if SalesBillingLine.Find('-') then
                        repeat
                            SalesBillingLine.TestField("Bill-to Customer No.", "Bill-to Customer No.");
                        until SalesBillingLine.Next = 0;
                end;

                InitRecord;

                if not Cust.Get("Bill-to Customer No.") then
                    Cust.Init;

                "Bill-to Name" := Cust.Name;
                "Bill-to Name 2" := Cust."Name 2";
                "Bill-to Address" := Cust.Address;
                "Bill-to Address 2" := Cust."Address 2";
                "Bill-to Address 3" := Cust."Address 3";
                "Bill-to City" := Cust.City;
                "Bill-to Post Code" := Cust."Post Code";
                "Bill-to County" := Cust.County;
                "Bill-to Country Code" := Cust."Country/Region Code";
                "Bill-to Contact" := Cust.Contact;
                "Phone No." := Cust."Phone No.";
                "Posting Description" := '';


                Validate("Payment Terms Code", Cust."Payment Terms Code");
                Validate("Payment Method Code", Cust."Payment Method Code");
            end;
        }
        field(11; "Bill-to Name"; Text[50])
        {
            Caption = 'Bill-to Name';
        }
        field(12; "Bill-to Name 2"; Text[50])
        {
            Caption = 'Bill-to Name 2';
        }
        field(13; "Bill-to Address"; Text[100])
        {
            Caption = 'Bill-to Address';
        }
        field(14; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';
        }
        field(20; "Bill-to Address 3"; Text[50])
        {
            Caption = 'Bill-to Address 2';
        }
        field(15; "Bill-to City"; Text[30])
        {
            Caption = 'Bill-to City';
        }
        field(16; "Bill-to Contact"; Text[50])
        {
            Caption = 'Bill-to Contact';
        }
        field(17; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(18; "Bill-to County"; Text[30])
        {
            Caption = 'Bill-to County';
        }
        field(19; "Bill-to Country Code"; Code[20])
        {
            Caption = 'Bill-to Country Code';
            TableRelation = "Country/Region";
        }
        field(21; "Posting Description"; Text[250])
        {
            Caption = 'Posting Description';
        }
        field(22; "Phone No."; Text[20]) { }
        field(23; "Payment Terms Code"; Code[20])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if ("Payment Terms Code" <> '') and ("Document Date" <> 0D) then begin
                    PaymentTerms.Get("Payment Terms Code");
                    "Due Date" := CalcDate(PaymentTerms."Due Date Calculation", "Document Date");
                end else
                    Validate("Due Date", "Document Date");
            end;
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(100; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(104; "Payment Method Code"; Code[20])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);

                PaymentMethod.Init;
                if "Payment Method Code" <> '' then
                    PaymentMethod.Get("Payment Method Code");
            end;
        }
        field(107; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(120; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
        field(121; Comment; Boolean)
        {
            CalcFormula = exist("Sales Comment Line" where("No." = field("No.")));
            FieldClass = FlowField;
        }
        field(150; "Create Date"; DateTime)
        {

        }
        field(151; "Create By"; Text[50])
        {

        }
        field(152; "Issue By"; Code[30])
        {
            TableRelation = "Salesperson/Purchaser".Code;
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
        key(Key2; "Bill-to Customer No.", "Document Type", "No.")
        {
        }
        key(Key3; "No.", "Posting Date")
        {
        }
        key(Key4; "Due Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        BillLine: Record "Sales Billing Line";
        BillLedgEntry: Record "Billing Ledger Entries";
    begin
        TestField(Status, Status::Open);

        BillLine.Reset;
        BillLine.SetFilter("Document Type", '%1', "Document Type");
        BillLine.SetFilter("Document No.", '%1', "No.");
        if BillLine.Find('-') then
            BillLine.DeleteAll;

        BillLedgEntry.Reset;
        BillLedgEntry.SetFilter("Transaction Type", '%1', "Document Type");
        BillLedgEntry.SetFilter("Transaction Entry Type", '%1', BillLedgEntry."transaction entry type"::Application);
        BillLedgEntry.SetFilter("Transcation Document No.", '%1', "No.");
        if BillLedgEntry.Find('-') then
            BillLedgEntry.DeleteAll;
    end;

    trigger OnInsert()
    begin
        SalesSetup.Get;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        end;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        Text001: label 'Do you want to change %1?';
        Text003: label 'You cannot rename a %1.';
        Cust: Record Customer;
        SalesBillingLine: Record "Sales Billing Line";
        SalesBillingHeader: Record "Sales Billing Header";
        utility: Codeunit Utility;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        case "Document Type" of
            "document type"::"Sales Billing":
                exit(SalesSetup."Billing Nos.");
            "document type"::"Sales Receipt":
                exit(SalesSetup."Receipt No.");
        end;

    end;

    procedure InitRecord()
    begin
        "Posting Date" := WorkDate;
        "Document Date" := WorkDate;
        "Create Date" := CurrentDateTime;
        "Create By" := utility.UserFullName(UserId);
        // "Posting Description" := Format("Document Type") + ' ' + "No.";
    end;

    procedure AssistEdit(OldSalesBillingHeader: Record "Sales Billing Header"): Boolean
    var
        SalesHeader2: Record "Sales Header";
    begin
        SalesBillingHeader.Copy(Rec);
        SalesSetup.Get;
        TestNoSeries;
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldSalesBillingHeader."No. Series", SalesBillingHeader."No. Series") then begin
            NoSeriesMgt.SetSeries(SalesBillingHeader."No.");
            Rec := SalesBillingHeader;
            exit(true);
        end;

    end;

    local procedure TestNoSeries(): Boolean
    begin
        case "Document Type" of
            "document type"::"Sales Billing":
                SalesSetup.TestField("Billing Nos.");
            "Document Type"::"Sales Receipt":
                SalesSetup.TestField("Receipt No.");
        end;

    end;
}

