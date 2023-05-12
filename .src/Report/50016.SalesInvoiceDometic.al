report 50016 "Sales Invoice Dometic"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/50016.SalesInvoiceDometic.rdl';
    PreviewMode = Normal;
    dataset
    {
        dataitem(SalesH; "Sales Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = where("Document Type" = filter(Invoice));
            column(No_; "No.") { }
            column(Document_Date; "Document Date") { }
            column(Due_Date; "Due Date") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Sell_to_Contact; "Sell-to Contact") { }
            column(Sell_to_Address; "Sell-to Address") { }
            column(Sell_to_Address_2; "Sell-to Address 2") { }
            column(Address_3; "Address 3") { }
            column(RE__Quotation_for; "RE: Quotation for") { }
            column(Remark_HD; "Remark HD") { }
            column(Drawing_and_Material; "Drawing and Material") { }
            column(YenBath; SalesSetup."Yen/Baht") { }
            column(SearchName; CustomerS."Search Name") { }
            column(Currency_Code; "Currency Code") { }
            column(ShowShipTo; ShowShipTo) { }
            column(ShipName; SalesH."Ship-to Name") { }
            column(ShipAddress; SalesH."Ship-to Address") { }
            column(ShipAddress2; SalesH."Ship-to Address 2") { }
            column(Template; Format(Template)) { }
            column(Phone_No_; "Phone No.") { }
            column(Fax_No_; "Fax No.") { }
            column(FROM_Address; "FROM Address") { }
            column(TO_Address; "TO Address") { }
            column(Ship_to_Code; "Ship-to Code") { }
            column(Work_Description; SalesH.GetWorkDescription()) { }
            column(Comercial; Comercial) { }
            column(FREIGHT; FREIGHT) { }
            column(INSURANCE; INSURANCE) { }
            column(FOB; FOB) { }
            column(PaymentText; PaymentText) { }
            column(Shipper; Shipper) { }
            column(CustPO; "External Document No.") { }
            column(paymentT; PaymentTerm.Description) { }
            column(BankName; BankAccount.Name) { }
            column(BankBanchNo; BankAccount."Bank Branch No.") { }
            column(BankAccountNo; BankAccount."Bank Account No.") { }
            column(BankSwiftCode; BankAccount."SWIFT Code") { }
            column(BankIBN; BankAccount.IBAN) { }
            column(BankEFTBankCode; BankAccount."EFT Bank Code") { }
            column(Com1; Com1) { }
            column(Com2; Com2) { }
            column(TaxID; CustomerS."VAT Registration No.") { }
            column(AmountText; AmountText) { }
            column(AmountTotal; AmountTotal) { }
            column(VATInt; VATInt) { }
            column(GranTotal; GranTotal) { }
            column(VATText; VATText) { }
            column(BOI_Code; "BOI Code") { }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemLinkReference = SalesH;
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                column(ItemNo; ItemNox) { }
                column(PartName; Description) { }
                column(Model; "Description 2") { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Unit_Price; "Unit Price") { }
                column(NetWeight; NetWeight) { }
                column(Amount1; Amount1) { }
                column(Amount2; Amount2) { }
                column(LineAmount; "Line Amount") { }
                column(rowNo; rowNo) { }
                trigger OnAfterGetRecord()
                begin
                    if "No." <> '' then
                        rowNo += 1;
                    NetweightSum += "Net Weight";
                    if NetweightSum > 0 then begin
                        NetWeight := '(Net) weight : ' + Format(NetweightSum) + ' kg.';
                    end;
                    if SalesH.Comercial = SalesH.Comercial::Comercial then
                        Amount1 += "Sales Line"."Line Amount"
                    else
                        Amount2 += "Sales Line"."Line Amount";
                    ItemNox := "Customer Item No.";
                    if "Customer Item No." = '' then
                        ItemNox := "No.";
                end;
            }
            trigger OnAfterGetRecord()
            var
                SaleL: Record "Sales Line";
            begin
                com1 := '';
                Com2 := '';
                if SalesH.Comercial = SalesH.Comercial::Comercial then
                    Com1 := 'X'
                else
                    Com2 := 'X';

                SalesSetup.Get();
                // if "Ship-to Code" //
                if "Salesperson Code" <> '' then begin
                    Shipper := '';
                    Salespersonp.Reset();
                    Salespersonp.SetRange(Code, "Salesperson Code");
                    if Salespersonp.Find('-') then begin
                        Shipper := Salespersonp."Full Name";
                        if Shipper = '' then
                            Shipper := Salespersonp.Name;
                    end;
                end;
                if "Payment Terms Code" <> '' then begin
                    PaymentTerm.Reset();
                    PaymentTerm.SetRange(Code, "Payment Terms Code");
                    if PaymentTerm.Find('-') then;
                end;
                if "Company Bank" <> '' then begin
                    BankAccount.Reset();
                    BankAccount.SetRange("No.", "Company Bank");
                    if BankAccount.Find('-') then;
                end;
                Crrncy1 := "Currency Code";
                if Crrncy1 = '' then
                    Crrncy1 := 'THB';
                if "Payment Terms Code" <> '' then begin
                    PaymentT.Reset();
                    PaymentT.SetRange(Code, SalesH."Payment Terms Code");
                    if PaymentT.Find('-') then begin
                        PaymentText := PaymentT.Description;
                    end;
                end;
                CustomerS.Reset();
                if "Ship-to Code" <> '' then
                    CustomerS.SetRange("No.", "Ship-to Code")
                else
                    CustomerS.SetRange("No.", "Sell-to Customer No.");
                if CustomerS.Find('-') then;


                VATInt := 0;
                SaleL.Reset();
                SaleL.SetRange("Document No.", SalesH."No.");
                SaleL.SetRange("Document Type", SaleL."Document Type"::Invoice);
                if SaleL.Find('-') then begin
                    repeat
                        if "No." <> '' then
                            VATInt := SaleL."VAT %";
                        AmountTotal += SaleL."Line Amount";
                        GranTotal += SaleL."Amount Including VAT";

                    until SaleL.Next = 0;
                end;
                AmountText := utility.FormatNoThaiText(GranTotal);

                if VATInt > 0 then
                    VATText := Format(VATInt) + ' %';


            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    field(ShowShipTo; ShowShipTo)
                    {
                        Caption = 'Show Detail';
                        ApplicationArea = all;
                    }
                    field(Template; Template)
                    {
                        Caption = 'Template';
                        ApplicationArea = all;
                        Visible = false;
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        ShowShipTo := true;
    end;

    trigger OnPreReport()
    begin

    end;

    var
        SalesLineUsage: Record "Sales Line Annual Usage";
        utility: Codeunit Utility;
        SalesSetup: Record "Sales & Receivables Setup";
        CustomerS: Record Customer;
        AnnualText: array[4] of Text[100];
        Annualamount: array[4] of Decimal;
        PcsUnit: array[4] of Decimal;
        rowTimming: array[4] of Text[100];
        ShowShipTo: Boolean;
        Template: Option Template1,Template2;
        Crrncy1: Code[20];
        PaymentT: Record "Payment Terms";
        PaymentText: Text[100];
        Shipper: Text[50];
        Salespersonp: Record "Salesperson/Purchaser";
        NetWeight: Text[50];
        NetweightSum: Decimal;
        BankAccount: Record "Bank Account";
        PaymentTerm: Record "Payment Terms";
        Amount1: Decimal;
        Amount2: Decimal;
        Com1: Code[1];
        Com2: Code[1];
        AmountText: Text[200];
        ItemNox: Text[50];
        VATInt: Decimal;
        VATText: Code[20];
        AmountTotal: Decimal;
        GranTotal: Decimal;
        rowNo: Integer;
}