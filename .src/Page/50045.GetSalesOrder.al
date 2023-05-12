page 50045 "Get Sales Order"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Get Sales Order';
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    ShowFilter = true;

    //PromotedActionCategories = 'New,Process,Report,Request Approval,Print/Send,Order,Release,Posting,Navigate';
    QueryCategory = 'Get Sales Order';
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = filter(<> Quote), "Document Type" = filter(Order), Status = filter(Released), Invoice = filter(false));
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("No."; "No.")
                {
                    Caption = 'Order No.';
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    Caption = 'Order Date';
                    ApplicationArea = all;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = all;
                    Caption = 'Customer PO';
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    ApplicationArea = all;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = all;
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
                field("Create By"; "Create By") { ApplicationArea = all; }
                field("Create Date"; "Create Date") { ApplicationArea = all; }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(Card)
            {
                Caption = 'Get To Line';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalesIv: Record "Sales Header";
                begin
                    if Docx <> '' then begin
                        CurrPage.SetSelectionFilter(SalesIv);
                        if SalesIv.Find('-') then begin
                            repeat
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
        SalesH: Record "Sales Header";
        salesL: Record "Sales Line";
        Row1: Integer;
        Dbit: Code[2];
        SalesIVH: Record "Sales Header";
        SalesIVL: Record "Sales Line";
    begin
        Row1 := 0;
        SalesH.Reset();
        SalesH.SetRange("No.", SaleH."No.");
        SalesH.SetRange("Document Type", SalesH."Document Type"::Order);
        if SalesH.Find('-') then begin
            salesL.Reset();
            salesL.SetRange("Document Type", salesL."Document Type"::Order);
            salesL.SetRange("Document No.", SalesH."No.");
            salesL.SetAutoCalcFields("Invoice No.");
            if salesL.Find('-') then begin
                repeat
                    if salesL."Invoice No." = '' then begin
                        SalesIVH.Reset();
                        SalesIVH.SetRange("No.", Docx);
                        if SalesIVH.Find('-') then begin
                            SalesIVL.Reset();
                            SalesIVL.SetRange("Document No.", Docx);
                            SalesIVL.SetRange("Document Type", SalesIVL."Document Type"::Invoice);
                            if SalesIVL.FindLast() then
                                Row1 := SalesIVL."Line No.";
                            //Insert//
                            Row1 := Row1 + 10000;
                            SalesIVL.Reset();
                            SalesIVL.Init();
                            SalesIVL.TransferFields(salesL);
                            SalesIVL."Line No." := Row1;
                            SalesIVL."Document No." := Docx;
                            SalesIVL."Document Type" := SalesIVL."Document Type"::Invoice;
                            SalesIVL.Type := SalesIVL.Type::Item;
                            SalesIVL."Order No." := salesL."Document No.";
                            SalesIVL."Order Line No." := salesL."Line No.";
                            SalesIVL.Insert();
                        end;
                    end;
                until salesL.Next = 0;
            end;
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