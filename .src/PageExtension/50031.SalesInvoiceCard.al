pageextension 50031 "Sales Invoice Card Ex" extends "Sales Invoice"
{
    layout
    {
        addafter("Sell-to Address 2")
        {
            field("Address 3"; "Address 3")
            {
                ApplicationArea = all;
                Importance = Promoted;
            }
        }
        modify("Sell-to Post Code")
        {
            Visible = false;
        }
        modify("Sell-to City") { Visible = false; }
        modify("Sell-to Country/Region Code") { Visible = false; }
        modify("Sell-to Contact No.") { Visible = false; }
        modify("Assigned User ID") { Visible = false; }
        modify("Responsibility Center") { Visible = false; }
        modify("Campaign No.") { Visible = false; }
        modify("Sell-to Address") { Importance = Promoted; }
        modify("Sell-to Address 2") { Importance = Promoted; }
        addafter(Status)
        {
            field(Comercial; Comercial)
            {
                ApplicationArea = all;
            }
            field("BOI Code"; "BOI Code")
            {
                ApplicationArea = all;
            }
        }
        modify("No.")
        {
            CaptionClass = 'Invoice No.';
        }
        modify("Posting Date")
        {
            CaptionClass = 'Invoice Date';
        }
        modify("External Document No.")
        {
            CaptionClass = 'Customer PO';
            Importance = Promoted;
        }
        modify(SellToEmail)
        {
            Visible = false;
        }
        modify(SellToPhoneNo)
        {
            Editable = true;
            Visible = false;
        }
        modify(SellToMobilePhoneNo)
        {
            Visible = false;
        }
        addbefore(SellToPhoneNo)
        {
            field("Phone No."; "Phone No.")
            {
                ApplicationArea = all;
            }
            field("Fax No."; "Fax No.")
            { ApplicationArea = all; }
        }
        modify("Payment Method Code")
        {
            Visible = true;
        }
        modify("Company Bank Account Code")
        {
            Visible = false;
        }
        movebefore("Document Date"; "Posting Date")
        moveafter("Document Date"; "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        movebefore("Shortcut Dimension 1 Code"; "Salesperson Code")
        addbefore("Invoice Details")
        {
            group(Static)
            {
                Caption = 'Special Detail';
                // field("SAILING ON"; "SAILING ON")
                // {
                //     ApplicationArea = all;
                // }
                field("FROM Address"; "FROM Address")
                {
                    ApplicationArea = all;
                }
                field("TO Address"; "TO Address")
                {
                    ApplicationArea = all;
                }
                field(FREIGHT; FREIGHT)
                {
                    ApplicationArea = all;
                }
                field(INSURANCE; INSURANCE)
                {
                    ApplicationArea = all;
                }
                field(FOB; FOB)
                {
                    ApplicationArea = all;
                }
                field("Company Bank"; "Company Bank")
                {
                    ApplicationArea = all;
                }
                field(Dimension; Dimension)
                {
                    ApplicationArea = all;
                }
                field("Shiping Mark"; "Shiping Mark")
                {
                    ApplicationArea = all;
                    Caption = 'Shipping Mark';
                }
                field("Total Mark"; "Total Mark")
                {
                    ApplicationArea = all;
                }

            }
        }


        ///
        // movebefore("FROM Address"; "Shipment Method")
        // moveafter("Company Bank"; "Shipment Method Code")

    }
    actions
    {
        modify(Post)
        {
            Visible = false;
        }
        modify(PostAndNew)
        {
            Visible = false;
        }
        modify(PostAndSend)
        {
            Visible = false;
        }

        addbefore("P&osting")
        {
            action(PrintInv1)
            {
                Caption = 'Invoice Export';
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PrintInv: Report "Sales Invoice Export";
                    SalesH: Record "Sales Header";
                begin
                    Clear(PrintInv);
                    SalesH.Reset();
                    CurrPage.SetSelectionFilter(SalesH);
                    PrintInv.SetTableView(SalesH);
                    PrintInv.Run();
                end;
            }
            action(PrintInv2)
            {
                Caption = 'Invoice Dometic';
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PrintInv: Report "Sales Invoice Dometic";
                    SalesH: Record "Sales Header";
                begin
                    Clear(PrintInv);
                    SalesH.Reset();
                    CurrPage.SetSelectionFilter(SalesH);
                    PrintInv.SetTableView(SalesH);
                    PrintInv.Run();
                end;
            }
            action(PackingList)
            {
                Caption = 'Packing List';
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PrintInv: Report "Packing List";
                    SalesH: Record "Sales Header";
                begin
                    Clear(PrintInv);
                    SalesH.Reset();
                    CurrPage.SetSelectionFilter(SalesH);
                    PrintInv.SetTableView(SalesH);
                    PrintInv.Run();
                end;
            }
        }
        addfirst(processing)
        {
            action(getSalesOrder)
            {
                Image = GetOrder;
                ApplicationArea = all;
                Caption = 'Get Sales Order';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PagegetOrder: Page "Get Sales Order";
                begin
                    Clear(PagegetOrder);
                    utility.UpdateSales_Invoiced();
                    PagegetOrder.setDocNo(Rec."No.", 'Invoice');
                    PagegetOrder.RunModal();

                end;
            }
        }


    }
    var
        utility: Codeunit Utility;
}