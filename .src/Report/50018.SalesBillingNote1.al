report 50018 "Billing Note 1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/50018.BillingNote1.rdl';
    PreviewMode = Normal;
    dataset
    {
        dataitem("Sales Billing Header"; "Sales Billing Header")
        {
            RequestFilterFields = "No.";
            DataItemTableView = where("Document Type" = filter('Sales Billing'));
            column(No_; "No.") { }
            column(Bill_to_Contact; "Bill-to Contact") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Bill_to_Address_2; "Bill-to Address 2") { }
            column(Bill_to_Address_3; "Bill-to Address 3") { }
            column(Phone_No_; "Phone No.") { }
            column(Document_Date; "Document Date") { }
            column(Due_Date; "Due Date") { }
            column(paymentTD; PaymentT.Description) { }
            column(VATRegisterNo; CustomerS."VAT Registration No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Remark; "Posting Description") { }
            column(TotalAmount; TotalAmount) { }
            column(TotalAmountText; TotalAmountText) { }
            column(IssueByText; IssueByText) { }
            column(SearchName; CustomerS."Search Name") { }
            dataitem("Sales Billing Line"; "Sales Billing Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemLinkReference = "Sales Billing Header";
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                column(Line_No_; "Line No.") { }
                column(Invoice_No_; "Sale Invoice No.") { }
                column(Posting_Date; "Cust. Posting Date") { }
                column(cDue_Date; "Cust. Due Date") { }
                column(Original_Amount; "Cust. Original Amount (LCY)") { }
                column(VAT_Amount; "Cust. VAT Amount") { }
                column(Amount; "Amount (LCY)") { }
                column(RemainAmount; "Amount (LCY)") { }
                column(rows; rows) { }
                column(Collected; Collected) { }
                trigger OnAfterGetRecord()
                begin
                    if "Sale Invoice No." <> '' then
                        rows += 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                BillingL: Record "Sales Billing Line";
            begin

                PaymentT.Reset();
                if "Payment Terms Code" <> '' then begin
                    PaymentT.SetRange(Code, "Payment Terms Code");
                    if PaymentT.Find('-') then;
                end;
                CustomerS.Reset();
                if "Bill-to Customer No." <> '' then begin
                    CustomerS.SetRange("No.", "Bill-to Customer No.");
                    if CustomerS.Find('-') then;
                end;
                BillingL.Reset();
                BillingL.SetRange("Document No.", "No.");
                BillingL.SetRange("Document Type", BillingL."Document Type"::"Sales Billing");
                if BillingL.Find('-') then begin
                    repeat
                        TotalAmount += BillingL."Amount (LCY)";
                    until BillingL.Next = 0;
                end;

                if TotalAmount > 0 then begin
                    //TotalAmount := 149026.18;
                    utility.SetArrayNumber();
                    TotalAmountText := utility.NumberInWords(TotalAmount, '', '').ToUpper();
                end;
                salesperson.Reset();
                if "Issue By" <> '' then begin
                    salesperson.Reset();
                    salesperson.SetRange(Code, "Issue By");
                    if salesperson.Find('-') then begin
                        IssueByText := salesperson."Full Name";
                        if IssueByText = '' then
                            IssueByText := salesperson.Name;
                    end;

                end;

            end;
        }
    }
    var
        utility: Codeunit Utility;
        PaymentT: Record "Payment Terms";
        CustomerS: Record Customer;
        TotalAmount: Decimal;
        TotalAmountText: Text[300];
        TotalAmountText2: array[2] of Text[80];
        rows: Integer;
        salesperson: Record "Salesperson/Purchaser";
        IssueByText: Text[200];
        Reportcheck: report Check;
}