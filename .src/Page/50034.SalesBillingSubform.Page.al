Page 50034 "Sales Billing Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = ListPart;
    SourceTable = "Sales Billing Line";
    SourceTableView = sorting("Document Type", "Document No.", "Line No.") order(ascending);
    MultipleNewLines = true;
    UsageCategory = History;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cust. Ledger Entry No."; Rec."Cust. Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Cust. Document Type"; Rec."Cust. Document Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                    Caption = 'Line No.';
                }
                field("Sale Invoice No."; "Sale Invoice No.")
                {
                    Caption = 'Invoice No.';
                    ApplicationArea = all;
                    //Editable = false;
                }

                field("Cust. Description"; Rec."Cust. Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Cust. Posting Date"; Rec."Cust. Posting Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoice Date';
                    Editable = true;
                }
                field("Cust. Document No."; Rec."Cust. Document No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer PO';
                }
                field("Cust. Due Date"; Rec."Cust. Due Date")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Caption = 'Due Date';

                }
                field("Cust. External Due Date"; Rec."Cust. External Due Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Cust. Original Amount (LCY)"; Rec."Cust. Original Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount';
                    trigger OnValidate()
                    begin
                        // "Cust. Remaining Amt. (LCY)" := "Cust. Original Amount (LCY)" + "Cust. VAT Amount";
                        // "Amount (LCY)" := "Cust. Original Amount (LCY)" + "Cust. VAT Amount";
                        //calAmount(Rec);
                    end;
                }
                field("Cust. Remaining Amt. (LCY)"; Rec."Cust. Remaining Amt. (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        // calAmount(Rec);
                    end;
                }
                field("Cust. VAT Amount"; "Cust. VAT Amount")
                {
                    ApplicationArea = all;
                    Caption = 'VAT Amount';
                    trigger OnValidate()
                    begin
                        //"Cust. Remaining Amt. (LCY)" := "Cust. Original Amount (LCY)" + "Cust. VAT Amount";
                        //"Amount (LCY)" := "Cust. Original Amount (LCY)" + "Cust. VAT Amount";
                        //  calAmount(Rec);
                    end;
                }
                field(WHT; WHT)
                {
                    Caption = 'WHT 1%';
                    ApplicationArea = all;
                    Visible = true;
                    trigger OnValidate()
                    begin
                        // calAmount(Rec);
                    end;
                }
                field(WHT3; WHT3)
                {
                    Caption = 'WHT 3%';
                    ApplicationArea = all;
                    Visible = true;
                    trigger OnValidate()
                    begin
                        //  calAmount(Rec);
                    end;
                }
                field(WHT5; WHT5)
                {
                    Caption = 'WHT 5%';
                    ApplicationArea = all;
                    Visible = true;
                    trigger OnValidate()
                    begin
                        //  calAmount(Rec);
                    end;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Amount';
                    Editable = false;

                }
                field(Collected; Collected) { ApplicationArea = all; }
                field("Receipt No."; "Receipt No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(AddInvoice)
            {
                Caption = 'Add Invoice';
                ApplicationArea = all;
                Image = Add;
                Visible = false;
                trigger OnAction()
                var
                    SalesH: Record "Sales Billing Header";
                    SalesL: Record "Sales Billing Line";
                    Row1: Integer;
                    I: Integer;
                    SalesHH: Record "Sales Header";
                    Page50035: Page "Get Sales Invoice";
                begin
                    if UserId.ToUpper() = 'ADMIN' then begin
                        SalesHH.Reset();
                        SalesHH.SetRange("Document Type", SalesHH."Document Type"::Invoice);
                        SalesHH.SetRange("No.", 'IO2302001');
                        if SalesHH.Find('-') then
                            if Confirm('Do you want add 1-66?') then begin
                                for I := 1 to 60 do begin
                                    Page50035.setDocNo(Rec."Document No.", 'Sales');
                                    Page50035.setSkip('None');
                                    Page50035.GetSaleInvoiceToBilling(SalesHH);
                                end;
                            end;
                    end;
                end;
            }
            action(DeleteInvoice)
            {
                Caption = 'Delete Invoice';
                ApplicationArea = all;
                Image = Delete;
                Visible = false;
                trigger OnAction()
                var
                    SalesH: Record "Sales Billing Header";
                    SalesL: Record "Sales Billing Line";
                begin
                    if UserId.ToUpper() = 'ADMIN' then begin
                        SalesL.Reset();
                        SalesL.SetRange("Document No.", Rec."Document No.");
                        SalesL.SetFilter("Line No.", '>%1', 0);
                        if SalesL.Find('-') then begin
                            repeat
                                SalesL.Delete();
                            until SalesL.Next = 0;
                        end;
                    end;
                end;
            }
        }
    }
    procedure calAmount1(var SalB: Record "Sales Billing Line")
    begin
        SalB."Amount (LCY)" := (SalB."Cust. Original Amount (LCY)" + SalB."Cust. VAT Amount") - (SalB.WHT + SalB.WHT3 + SalB.WHT5);
        SalB."Cust. Remaining Amt. (LCY)" := SalB."Cust. Original Amount (LCY)" + SalB."Cust. VAT Amount" - (SalB.WHT + SalB.WHT3 + SalB.WHT5);
    end;
}


