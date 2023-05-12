pageextension 50035 "Sales Order List Ext" extends "Sales Order List"
{
    layout
    {
        modify("No.")
        {
            CaptionClass = 'Order No.';
        }

        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Salesperson Code")
        {
            Visible = true;
        }
        modify("Location Code") { Visible = false; }
        addafter("Location Code")
        {
            field("Create Date"; "Create Date")
            {
                ApplicationArea = all;
            }
            field("Create By"; "Create By")
            {
                ApplicationArea = all;
            }

        }
        modify("External Document No.")
        {
            Caption = 'Customer PO';
            CaptionClass = 'Customer PO';
        }
        modify("Requested Delivery Date")
        {
            Visible = true;
        }
        modify("Document Date") { Visible = false; }
        modify("Posting Date") { Visible = true; CaptionClass = 'Doc. Date'; }
        moveafter("No."; "Posting Date", "Requested Delivery Date")
        addafter("External Document No.")
        {
            field("Your Reference"; "Your Reference")
            { ApplicationArea = all; }
        }

    }
    actions
    {
        modify(Post)
        {
            Visible = false;
        }
        modify("Post &Batch")
        {
            Visible = false;
        }
        modify(PostAndSend)
        {
            Visible = false;
        }
        modify("Sales Reservation Avail.") { Visible = false; }
        addafter("Sales Reservation Avail.")
        {

            action("Sales Reservation Avail.2")
            {
                ApplicationArea = Reservation;
                Caption = 'Sales Shipment Avail.';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                trigger OnAction()
                var
                    SalesH: Record "Sales Header";
                    SalesReport1: Report "Sales Shipment Avail.2";
                    salesL: Record "Sales Line";
                begin
                    Clear(SalesReport1);
                    salesL.Reset();
                    salesL.SetRange("Document Type", salesL."Document Type"::Order);
                    salesL.SetFilter("Planned Delivery Date", '%1..%2', WorkDate(), CalcDate('<CM>', WorkDate()));
                    // SalesReport1.SetTableView(salesL);
                    SalesReport1.RunModal();
                    // Report.Run(Report::"Sales Shipment Avail.2", true, false, salesL);

                end;
            }
            action("DeliverySc")
            {
                ApplicationArea = Reservation;
                Caption = 'Delivery schedule';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                trigger OnAction()
                var

                    SalesReport1: Report "SALES DELIVERY SCHEDULE";
                begin
                    Clear(SalesReport1);
                    SalesReport1.RunModal();
                end;
            }
            action(ShipList)
            {
                ApplicationArea = all;
                Image = TestDatabase;
                Visible = true;
                Caption = 'Posted Shipment';
                Promoted = true;
                PromotedCategory = "Report";
                trigger OnAction()
                var
                    PostedShpt: page "Posted Invt. Shipment Line";
                    ItemLedger: Record "Item Ledger Entry";
                begin
                    Clear(PostedShpt);
                    ItemLedger.Reset();
                    ItemLedger.SetRange("Order No.", Rec."No.");
                    if ItemLedger.Find('-') then;
                    PostedShpt.SetTableView(ItemLedger);
                    PostedShpt.Run();
                end;
            }
            action("TESTShip")
            {
                ApplicationArea = all;
                Image = TestDatabase;
                Visible = false;
                Caption = 'TEST Ship';
                Promoted = true;
                PromotedCategory = "Report";
                trigger OnAction()
                var
                    SalesL: Record "Sales Line";
                    ItemLedger: Record "Item Ledger Entry";
                begin
                    SalesL.Reset();
                    SalesL.SetRange("Document No.", 'SO2303002x');
                    SalesL.SetRange("Line No.", 10000);
                    if SalesL.Find('-') then begin
                        SalesL.Validate("Qty. Shipped (Base)", 0);
                        SalesL.Validate("Quantity Shipped", 0);
                        SalesL.InitOutstanding();
                        SalesL.InitOutstandingAmount();
                        SalesL.Modify(false);
                        ItemLedger.Reset();
                        ItemLedger.SetRange("Order No.", SalesL."Document No.");
                        ItemLedger.SetRange("Order Line No.", SalesL."Line No.");
                        if ItemLedger.Find('-') then begin
                            ItemLedger."Use Sales Order" := false;
                            ItemLedger.Modify(false);
                        end;
                    end;
                    utility.UpdateSalesOrderLine();
                    Message('Completed.');
                    CurrPage.Update();
                end;
            }

        }
        addbefore(Dimensions)
        {
            action(DemandForcast)
            {
                // AccessByPermission = TableData Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Demand Forecasts';
                Image = Forecast;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    DemandP: page "Demand Forecast Names";
                begin
                    Clear(DemandP);
                    DemandP.Run();
                end;
            }
            action(OrderList)
            {
                // AccessByPermission = TableData Dimension = R;
                ApplicationArea = all;
                Caption = 'Remaining Order';
                Image = Line;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    DemandP: page "Whs. Sales Order List";
                begin
                    Clear(DemandP);
                    DemandP.Run();
                end;
            }
        }
    }
    var
        utility: Codeunit Utility;
}