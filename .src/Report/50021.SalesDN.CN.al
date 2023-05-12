report 50021 "Sales Invoice DN CN"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/SalesInvoiceCNDN.rdlc';
    PreviewMode = Normal;
    dataset
    {
        dataitem(Integer; Integer)
        {
            column(Number; Number) { }
            column(CopyText; CopyText) { }
            column(DocText; DocText) { }
            dataitem(SalesH; "Sales Header")
            {
                RequestFilterFields = "No.";
                DataItemTableView = where("Document Type" = filter("Credit Memo"));
                column(No_; "No.") { }
                column(Document_Date; "Document Date") { }
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
                column(VATRegister; CustomerS."VAT Registration No.") { }
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
                column(rowX; rowX) { }
                column(AmountHD; Amount) { }
                column(AmountVAT; "Amount Including VAT" - Amount) { }
                column(Amount_Including_VAT; "Amount Including VAT") { }

                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    DataItemLinkReference = SalesH;
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                    column(ItemNo; ItemNox) { }
                    column(PartName; DescriptionX) { }
                    column(Model; "Description 2") { }
                    column(Quantity; Quantity) { }
                    column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                    column(Unit_Price; "Unit Price") { }
                    column(RowNo; RowNo) { }
                    column(UnitP; UnitP) { }
                    column(Amount; Amount) { }
                    column(LineAmount; LineAmount) { }

                    column(RowS; RowS) { }
                    trigger OnAfterGetRecord()
                    begin
                        DescriptionX := '';

                        NetweightSum += "Net Weight";
                        if NetweightSum > 0 then begin
                            NetWeight := '(Net) weight : ' + Format(NetweightSum) + ' kg.';
                        end;

                        DescriptionX := "Sales Line"."No." + ' / ' + "Sales Line".Description;
                        if "Sales Line".Type = "Sales Line".Type::"G/L Account" then
                            DescriptionX := "Sales Line".Description;
                        if "Sales Line".Type = "Sales Line".Type::" " then
                            DescriptionX := "Sales Line".Description;



                        if "Sales Line"."Customer Item Name" <> '' then
                            DescriptionX := "Sales Line"."Customer Item Name";

                        if "No." <> '' then
                            RowNo := 1
                        else
                            RowNo := 0;
                        RowS += RowNo;

                        UnitP := "Unit Price";
                        LineAmount := "Amount Including VAT";
                        if Template = Template::Credit then begin
                            UnitP := 0;
                            LineAmount := "Amount Including VAT";
                        end;


                    end;
                }
                trigger OnAfterGetRecord()
                var
                    SaleL: Record "Sales Line";
                begin
                    CalcFields(Amount);
                    CalcFields("Amount Including VAT");
                    rowX := 0;
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

                    SaleL.Reset();
                    SaleL.SetRange("Document No.", SalesH."No.");
                    SaleL.SetRange("Document Type", SaleL."Document Type"::"Credit Memo");
                    if SaleL.Find('-') then begin
                        repeat
                            rowX += 1;
                        until SaleL.Next = 0;
                    end;
                    // Message(Format(rowX));


                end;
            }
            ///Number Copy
            /// 
            trigger OnPreDataItem()
            begin
                if CopyQ = 0 then
                    CopyQ := 2;
                SetRange(Number, 1, CopyQ);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    CopyText := 'ORIGINAL'
                else
                    CopyText := 'COPY';

                if Template = Template::Credit then
                    DocText := 'CREDIT NOTE'
                else
                    DocText := 'DEBIT NOTE';
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
                        Visible = false;
                    }
                    field(Template; Template)
                    {
                        Caption = 'Template';
                        ApplicationArea = all;
                        Visible = true;
                    }
                    field(CopyQ; CopyQ)
                    {
                        Caption = 'Number Copy';
                        ApplicationArea = all;
                        Visible = true;
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        ShowShipTo := true;
        CopyQ := 2;
        DocText := 'CREDIT NOTE';
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
        Template: Option Credit,Debit;
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
        ItemNox: Text[50];
        CopyQ: Integer;
        CopyText: Text[20];
        DocText: Text[20];
        RowNo: Integer;
        RowS: Integer;
        DescriptionX: Text[200];
        LineAmount: Decimal;
        UnitP: Decimal;
        rowX: Integer;
}