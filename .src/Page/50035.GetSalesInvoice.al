page 50035 "Get Sales Invoice"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Get Sales Invoice';
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Request Approval,Print/Send,Order,Release,Posting,Navigate';
    QueryCategory = 'Get Sales Invoice';
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = filter(<> Quote), "Document Type" = filter(<> Order), Status = filter(Released));
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("No."; "No.")
                {
                    Caption = 'Invoice No.';
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    Caption = 'Invoice Date';
                    ApplicationArea = all;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    ApplicationArea = all;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = all;
                    Caption = 'Customer PO';
                }
                field(Amount; Amount)
                {
                    ApplicationArea = all;
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                    ApplicationArea = all;
                }
                field("Work Description"; "Work Description")
                {
                    ApplicationArea = all;
                    Caption = 'Remark';
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(Select2)
            {
                Caption = 'Get to Line';
                Visible = true;
                ApplicationArea = all;
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SalesIv: Record "Sales Header";
                begin
                    if Docx <> '' then begin
                        CurrPage.SetSelectionFilter(SalesIv);
                        if SalesIv.Find('-') then begin
                            repeat
                                if Typex = 'Receipt' then
                                    GetSaleInvoiceToBillingReceipt(SalesIv)
                                else
                                    GetSaleInvoiceToBilling(SalesIv);
                            until SalesIv.Next = 0;
                        end;

                    end;
                    CurrPage.Close();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CalcFields(Amount);
        CalcFields("Amount Including VAT");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        SalesIv: Record "Sales Header";
    begin
        if CloseAction = Action::OK then begin

        end;
    end;

    var
        Docx: Code[30];
        Dx1: Code[10];
        Typex: Text[20];

    procedure setDocNo(DocNo: Code[20]; Type1: Text[20])
    begin
        Docx := DocNo;
        Typex := Type1;
    end;

    procedure setSkip(Dx: Code[20])
    begin
        Dx1 := Dx;
    end;

    procedure GetSaleInvoiceToBilling(SaleH: Record "Sales Header")
    var
        BillingH: Record "Sales Billing Header";
        BillingL: Record "Sales Billing Line";
        Row1: Integer;
        Dbit: Code[2];
    begin
        SaleH.CalcFields("Billing No.");
        if (SaleH."Billing No." <> '') and (Dx1 = '') then begin
            if Typex <> 'Receipt' then
                exit;
        end;

        BillingH.Reset();
        BillingH.SetRange("No.", Docx);
        if BillingH.Find('-') then begin

            BillingL.Reset();
            BillingL.SetRange("Document No.", Docx);
            if BillingL.FindLast() then begin
                Row1 := BillingL."Line No.";
            end;

            ////////
            Dbit := CopyStr(SaleH."No.", 1, 2);
            SaleH.CalcFields(Amount);
            SaleH.CalcFields("Amount Including VAT");
            BillingL.Reset();
            BillingL.Init();
            BillingL."Document Type" := BillingL."Document Type"::"Sales Billing";
            BillingL."Document No." := Docx;
            BillingL."Line No." := Row1 + 1;
            BillingL."Sale Invoice No." := SaleH."No.";
            BillingL."Bill-to Customer No." := SaleH."Sell-to Customer No.";
            BillingL."Cust. Document No." := SaleH."External Document No.";
            BillingL."Cust. Posting Date" := SaleH."Document Date";
            BillingL."Cust. Due Date" := SaleH."Due Date";
            if (SaleH."Document Type" = SaleH."Document Type"::Invoice) or (Dbit = 'DN') then begin
                BillingL."Cust. Document Type" := BillingL."Cust. Document Type"::Invoice;
                BillingL."Cust. Original Amount (LCY)" := SaleH.Amount;
                BillingL."Cust. VAT Amount" := abs(SaleH."Amount Including VAT" - SaleH.Amount);
                BillingL."Cust. Remaining Amt. (LCY)" := SaleH."Amount Including VAT";
                BillingL."Amount (LCY)" := SaleH."Amount Including VAT";
            end
            else
                if (SaleH."Document Type" = SaleH."Document Type"::"Credit Memo") then begin

                    BillingL."Cust. Document Type" := BillingL."Cust. Document Type"::"Credit Memo";
                    BillingL."Cust. Original Amount (LCY)" := abs(SaleH.Amount) * -1;
                    BillingL."Cust. VAT Amount" := (abs(SaleH."Amount Including VAT") - abs(SaleH.Amount)) * -1;
                    BillingL."Cust. Remaining Amt. (LCY)" := abs(SaleH."Amount Including VAT") * -1;
                    BillingL."Amount (LCY)" := abs(SaleH."Amount Including VAT") * -1;
                end;

            BillingL.Insert();
            //////

        end;
    end;

    procedure GetSaleInvoiceToBillingReceipt(SaleH: Record "Sales Header")
    var
        BillingH: Record "Sales Billing Header";
        BillingL: Record "Sales Billing Line";
        Row1: Integer;
    begin
        BillingH.Reset();
        BillingH.SetRange("No.", Docx);
        if BillingH.Find('-') then begin

            BillingL.Reset();
            BillingL.SetRange("Document No.", Docx);
            if BillingL.FindLast() then begin
                Row1 := BillingL."Line No.";
            end;

            ////////
            SaleH.CalcFields(Amount);
            SaleH.CalcFields("Amount Including VAT");
            BillingL.Reset();
            BillingL.Init();
            BillingL."Document Type" := BillingL."Document Type"::"Sales Receipt";
            BillingL."Document No." := Docx;
            BillingL."Line No." := Row1 + 1;
            BillingL."Sale Invoice No." := SaleH."No.";
            BillingL."Bill-to Customer No." := SaleH."Sell-to Customer No.";
            BillingL."Cust. Document No." := SaleH."External Document No.";
            BillingL."Cust. Posting Date" := SaleH."Document Date";
            BillingL."Cust. Due Date" := SaleH."Due Date";
            BillingL."Cust. Document Type" := BillingL."Cust. Document Type"::Invoice;
            BillingL."Cust. Original Amount (LCY)" := SaleH.Amount;
            BillingL."Cust. VAT Amount" := SaleH.Amount - SaleH."Amount Including VAT";
            BillingL."Cust. Remaining Amt. (LCY)" := SaleH."Amount Including VAT";
            BillingL.WHT := 0;
            BillingL.Collected := '';
            BillingL."Amount (LCY)" := SaleH."Amount Including VAT";
            BillingL.Insert();
            //////

        end;
    end;
}