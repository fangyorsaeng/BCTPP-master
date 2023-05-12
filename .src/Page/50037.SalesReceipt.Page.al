
Page 50037 "Sales Receipt"
{

    PageType = Document;
    SourceTable = "Sales Billing Header";
    SourceTableView = sorting("Document Type", "No.")
                      order(ascending)
                      where("Document Type" = const("Sales Receipt"));
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                }
                // field("Bill-to Name 2"; Rec."Bill-to Name 2")
                // {
                //     ApplicationArea = Basic;
                // }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Address 3"; "Bill-to Address 3")
                {
                    ApplicationArea = all;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = all;
                }
                // field("Bill-to City"; Rec."Bill-to City")
                // {
                //     ApplicationArea = Basic;
                // }
                // field("Bill-to Post Code"; Rec."Bill-to Post Code")
                // {
                //     ApplicationArea = Basic;
                // }
                // field("Bill-to County"; Rec."Bill-to County")
                // {
                //     ApplicationArea = Basic;
                // }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = Basic;
                    Caption = 'Remark';
                    CaptionClass = 'Remark';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                // field("External Document No."; Rec."External Document No.")
                // {
                //     ApplicationArea = Basic;
                // }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        UpdateDueDate;
                    end;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Issue By"; "Issue By")
                {
                    ApplicationArea = all;
                }

            }
            part(ReceiptLine; "Sales Receipt Subform")
            {
                Caption = 'Receipt Line';
                ApplicationArea = all;
                SubPageView = sorting("Document Type", "Document No.", "Line No.")
                              order(ascending);
                SubPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
            group(Invoice)
            {
                field("Total Amount"; TotalAmount)
                {
                    ApplicationArea = Basic;
                }
                field("VAT Amount"; VATAmount)
                {
                    ApplicationArea = Basic;
                }
                field("Total Amoutn Including VAT"; TotalAmountIncVAT)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        // area(factboxes)
        // {
        //     part(Control23; "Sales Hist. Sell-to FactBox")
        //     {
        //         SubPageLink = "No." = field("Bill-to Customer No.");
        //     }
        //     part(Control24; "Customer Statistics FactBox")
        //     {
        //         SubPageLink = "No." = field("Bill-to Customer No.");
        //     }
        //     part(Control25; "Customer Details FactBox")
        //     {
        //         SubPageLink = "No." = field("Bill-to Customer No.");
        //     }
        //     systempart(Control22; Notes)
        //     {
        //     }
        //     systempart(Control21; Links)
        //     {
        //     }
        // }
    }

    actions
    {
        area(navigation)
        {
        }
        area(processing)
        {
            group("Function")
            {
                action("Get Cust. Ledger")
                {
                    Caption = 'Get Sale Invoice';
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        getSalesInv: Page "Get Sales Invoice";
                        SalesH: Record "Sales Header";
                    begin
                        Clear(getSalesInv);
                        SalesH.Reset();
                        SalesH.SetAutoCalcFields("Receipt No.");
                        SalesH.SetRange("Document Type", SalesH."Document Type"::Invoice);
                        SalesH.SetRange(Status, SalesH.Status::Released);
                        SalesH.SetRange("Sell-to Customer No.", Rec."Bill-to Customer No.");
                        SalesH.SetFilter("Receipt No.", '=%1', '');
                        if SalesH.Find('-') then;
                        getSalesInv.setDocNo(Rec."No.", 'Receipt');
                        getSalesInv.SetTableView(SalesH);
                        getSalesInv.RunModal();
                        //   GetCustLedger;
                    end;
                }
                separator(Action33)
                {
                }
                action(Released)
                {
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                    //ReleasedBilling: Codeunit "Release Sales Billing Doc.";
                    begin
                        // ReleasedBilling.Run(Rec);
                        // Clear(ReleasedBilling);
                        // UpdateCustLedgerBillingNo(Rec);
                        if Confirm('Do you want Set Status Release?') then begin
                            Rec.Status := Rec.Status::Released;

                        end;
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                    // ReleasedBilling: Codeunit "Release Sales Billing Doc.";
                    begin
                        // ReleasedBilling.Reopen(Rec);
                        //Clear(ReleasedBilling);
                        if Confirm('Do you want Set Status Open?') then begin
                            Rec.Status := Rec.Status::Open;
                        end;
                    end;
                }
                separator(Action29)
                {
                }
            }
            group(Print)
            {
                action("Billing Note")
                {
                    Caption = 'Print Receipt';
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesBillingHeader: Record "Sales Billing Header";
                        ReceiptRPT: Report "Sales Receipt";
                    begin
                        SalesBillingHeader.Copy(Rec);
                        CurrPage.SetSelectionFilter(SalesBillingHeader);
                        ReceiptRPT.SetTableView(SalesBillingHeader);
                        ReceiptRPT.Run();

                    end;
                }

            }
            group(Receipt)
            {
                action("<Action61>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = filter(10),
                                  "No." = field("No."),
                                  "Document Line No." = const(0);
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Rec.SetRange("Document Type");
        // SalesBillingLine.CalcVATAmountLines(Rec, SalesBillingLine, TotalAmount, VATAmount, TotalAmountIncVAT, VATText);
    end;

    var
        TotalAmount: Decimal;
        VATAmount: Decimal;
        TotalAmountIncVAT: Decimal;
        VATText: Text[30];
        SalesBillingLine: Record "Sales Billing Line";

    procedure LastEntryNo(): Integer
    var
        BillingLedg: Record "Billing Ledger Entries";
    begin

        BillingLedg.Reset;
        BillingLedg.SetCurrentkey("Entry No.");
        if BillingLedg.Find('+') then
            exit(BillingLedg."Entry No." + 1);
        exit(1);
    end;

    procedure GetCustLedger()
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        BillingLedg: Record "Billing Ledger Entries";
        GetCustEntries: Page "Get Sales Invoice";
    begin
        Rec.TestField("Bill-to Customer No.");
        // GetCustEntries.SetRecord(CustLedgEntry);
        // GetCustEntries.SetTableview(CustLedgEntry);
        // GetCustEntries.SetProperties(Rec."Document Type", Rec."No.");

        // // Use RUNMODAL for wait the results, after that refresh the page
        // //show the selected items in the Lines page.
        // Commit;
        // GetCustEntries.RunModal;
        // CurrPage.Update();
        // Clear(GetCustEntries);
    end;

    local procedure UpdateCustLedgerBillingNo(BillingHeader: Record "Sales Billing Header")
    var
        BillingLine: Record "Sales Billing Line";
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        BillingLine.Reset;
        BillingLine.SetRange("Document No.", BillingHeader."No.");
        BillingLine.FindSet;
        repeat
        // CustLedgerEntry.Get(BillingLine."Cust. Ledger Entry No.");
        // CustLedgerEntry."Released Biling No." := BillingLine."Document No.";
        //  CustLedgerEntry.Modify;
        until BillingLine.Next = 0;
    end;

    procedure CheckSalesBillLine(SalesBillingHeader: Record "Sales Billing Header")
    var
        SalesBillLineLocal: Record "Sales Billing Line";
    begin
        SalesBillLineLocal.SetRange("Document No.", SalesBillingHeader."No.");
        SalesBillLineLocal.SetRange("Document Type", SalesBillingHeader."Document Type"::"Sales Billing");
        if not SalesBillLineLocal.FindSet() then
            Error('Can not find data in Sales Billing Line');
    end;

    procedure UpdateDueDate()
    var
        BillingLine: Record "Sales Billing Line";
        CustLedger: Record "Cust. Ledger Entry";
    begin
        BillingLine.SetRange("Document No.", Rec."No.");
        if BillingLine.FindSet then
            repeat
                BillingLine."Cust. Due Date" := Rec."Due Date";
                CustLedger.SetRange("Customer No.", BillingLine."Bill-to Customer No.");
                CustLedger.SetRange("Document No.", BillingLine."Cust. Document No.");
                if CustLedger.FindFirst then begin
                    CustLedger."Due Date" := Rec."Due Date";
                    CustLedger.Modify;
                end;
                BillingLine.Modify;
            until BillingLine.Next = 0;
        CurrPage.Update(true);
    end;
}



