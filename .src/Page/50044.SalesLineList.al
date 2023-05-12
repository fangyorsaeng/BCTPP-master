page 50044 "Sales Line List"
{
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = sorting("Document Type", "Document No.", "Line No.") where("Document Type" = filter(Order));
    ModifyAllowed = false;
    InsertAllowed = false;
    DelayedInsert = false;
    DeleteAllowed = false;
    ApplicationArea = all;
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Status; Status) { ApplicationArea = all; StyleExpr = StyleTex; }
                field("Short Name"; "Short Name") { ApplicationArea = all; }
                field("Planned Delivery Date"; "Planned Delivery Date") { ApplicationArea = all; }
                field("Document No."; "Document No.") { ApplicationArea = all; Caption = 'Order No.'; }
                field("Line No."; "Line No.") { ApplicationArea = all; }
                field("No."; "No.") { ApplicationArea = all; Caption = 'Part No.'; }
                field(Description; Description) { ApplicationArea = all; Caption = 'Part Name'; }
                field(Quantity; Quantity) { ApplicationArea = all; Caption = 'Order Qty'; StyleExpr = 'StandardAccent'; }
                field("Quantity Shipped"; "Quantity Shipped") { ApplicationArea = all; }
                field("Outstanding Quantity"; "Outstanding Quantity") { ApplicationArea = all; Caption = 'Remain Qty'; StyleExpr = StyleTex; }
                field("Unit of Measure Code"; "Unit of Measure Code") { ApplicationArea = all; }
                field("Unit Price"; "Unit Price") { ApplicationArea = all; }
                field("Line Amount"; "Line Amount") { ApplicationArea = all; }
                field("Invoice No."; "Invoice No.") { ApplicationArea = all; }
            }

        }

    }
    actions
    {
        area(Processing)
        {
            action("Sales Reservation Avail.2")
            {
                ApplicationArea = Reservation;
                Caption = 'Sales Shipment Avail.';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
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
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var

                    SalesReport1: Report "SALES DELIVERY SCHEDULE";
                begin
                    Clear(SalesReport1);
                    SalesReport1.RunModal();
                end;
            }
            action(Postedship)
            {
                ApplicationArea = all;
                Caption = 'Posted Shipment';
                Image = PostedShipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PostedShpt: page "Posted Invt. Shipment Line";
                    ItemLedger: Record "Item Ledger Entry";
                begin
                    Clear(PostedShpt);
                    ItemLedger.Reset();
                    ItemLedger.SetRange("Order No.", Rec."Document No.");
                    if ItemLedger.Find('-') then;
                    PostedShpt.SetTableView(ItemLedger);
                    PostedShpt.Run();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SalesH.Reset();
        SalesH.SetRange("No.", "Document No.");
        CalcFields("Invoice No.");
        if "Outstanding Qty. (Base)" = 0 then begin
            Status := Status::Completed;
            StyleTex := 'Favorable';
        end
        else
            if "Quantity Shipped" > 0 then begin
                Status := Status::Partial;
                StyleTex := 'Attention';
            end else begin
                StyleTex := 'Standard';
                Status := Status::Waiting;
            end;
    end;

    trigger OnOpenPage()
    begin
        SetFilter("Planned Delivery Date", '%1..', CalcDate('<-1Y>', Today));
    end;

    var
        CustomerPO: Text[100];
        SalesH: Record "Sales Header";
        Status: Option Completed,Partial,Waiting;
        StyleTex: Text[20];
}