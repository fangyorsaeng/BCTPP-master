
Page 50032 "Sales Billing List"
{
    CardPageID = "Sales Billing";
    DataCaptionFields = "No.", "Bill-to Customer No.", "Bill-to Name", "Posting Date";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Billing Header";
    SourceTableView = sorting("Document Type", "No.")
                      order(ascending)
                      where("Document Type" = const("Sales Billing"));

    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                }
                field("Total Remaing Amount"; xTotalRemainingAmount)
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount"; TotalAmount)
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount Including VAT"; TotalAmtInclVAT)
                {
                    ApplicationArea = Basic;
                }
                field("Create By"; "Create By")
                {
                    ApplicationArea = all;
                }
                field("Create Date"; "Create Date")
                {
                    ApplicationArea = all;
                }

            }
        }
        // area(factboxes)
        // {
        //     systempart(Control15; Notes)
        //     {
        //     }
        //     systempart(Control14; Links)
        //     {
        //     }
        // }
    }

    actions
    {
        area(navigation)
        {
            group(Billing)
            {
                action("<Action61>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = filter(10),
                                  "Document Line No." = const(0);
                }
            }
        }
        area(processing)
        {
            group("Function")
            {
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
                    // ReleasedBilling: Codeunit "Release Sales Billing Doc.";
                    begin
                        // ReleasedBilling.Run(Rec);
                        // Clear(ReleasedBilling);
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
                        //   ReleasedBilling.Reopen(Rec);
                        //   Clear(ReleasedBilling);
                    end;
                }
            }
            group(Print)
            {
                action("Billing Note")
                {
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesBillingHeader: Record "Sales Billing Header";
                        BillingNote1: Report "Billing Note 1";
                    begin
                        SalesBillingHeader.Copy(Rec);
                        CurrPage.SetSelectionFilter(SalesBillingHeader);
                        BillingNote1.SetTableView(SalesBillingHeader);
                        BillingNote1.Run();
                        //CheckSalesBillLine(SalesBillingHeader);
                        //Report.Run(Report::"Sales Billing Note", true, true, SalesBillingHeader);
                    end;
                }
                action("Billing Note 2")
                {
                    Caption = 'Billing JATH';
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesBillingHeader: Record "Sales Billing Header";
                        BillingNote2: Report "Billing Note 2";
                    begin
                        SalesBillingHeader.Copy(Rec);
                        CurrPage.SetSelectionFilter(SalesBillingHeader);
                        BillingNote2.SetTableView(SalesBillingHeader);
                        BillingNote2.Run();
                    end;
                }
                action("Billing Note 3")
                {
                    Caption = 'Billing JTC';
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesBillingHeader: Record "Sales Billing Header";
                        BillingNote2: Report "Billing Note 3";
                    begin
                        SalesBillingHeader.Copy(Rec);
                        CurrPage.SetSelectionFilter(SalesBillingHeader);
                        BillingNote2.SetTableView(SalesBillingHeader);
                        BillingNote2.Run();
                    end;
                }

            }
            // group(Create)
            // {
            //     // action("Auto Billing")
            //     // {
            //     //     ApplicationArea = Basic;
            //     //     Image = MakeOrder;
            //     //     Promoted = true;
            //     //     Visible = false;

            //     //     trigger OnAction()
            //     //     var
            //     //         tblSalesBillingHeader: Record "Sales Billing Header";
            //     //     begin
            //     //         Report.Run(Report::Report50131);
            //     //     end;
            //     // }
            // }
        }
    }

    trigger OnAfterGetRecord()
    var
        SalesBillingLine: Record "Sales Billing Line";
    begin
        //SalesBillingLine.CalcVATAmountLines(Rec, SalesBillingLine, TotalAmount, VATAmount, TotalAmtInclVAT, VATText);
        //SalesBillingLine.CalcRemainingAmountLines(Rec, SalesBillingLine, xTotalRemainingAmount);
    end;

    trigger OnOpenPage()
    begin
        // Rec.SetFilter(Status, '%1', Rec.Status::Open);
    end;

    var
        TotalAmount: Decimal;
        VATAmount: Decimal;
        TotalAmtInclVAT: Decimal;
        VATText: Text[30];
        xTotalRemainingAmount: Decimal;
}



