report 50022 "Sales Shipment Avail.2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/SalesShipmentAvail2.rdl';
    ApplicationArea = all;
    Caption = 'Sales Shipment Avail.';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = where("Document Type" = filter(Order), Type = filter(Item));
            RequestFilterFields = "Document No.", "No.";
            column(PlanDate; "Sales Line".GetFilter("Planned Delivery Date")) { }
            column(Document_No_; "Document No.") { }
            column(Planned_Delivery_Date; "Planned Delivery Date") { }
            column(No_; "No.") { }
            column(Description; Description) { }
            column(Quantity; Quantity) { }
            column(Quantity_Shipped; "Quantity Shipped") { }
            column(Outstanding_Qty___Base_; "Outstanding Qty. (Base)") { }
            column(LineStatus; LineStatus) { }
            column(CustPO; SalesHeader."External Document No.") { }
            column(CustName; CustS.Name) { }
            trigger OnAfterGetRecord()
            begin
                LineStatus := LineStatus::"No Shipment";
                if "Quantity Shipped" > 0 then
                    LineStatus := LineStatus::"Partial Shipment";
                if "Outstanding Qty. (Base)" = 0 then
                    LineStatus := LineStatus::"Full Shipment";

                SalesHeader.Reset();
                SalesHeader.SetRange("No.", "Document No.");
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                if SalesHeader.Find('-') then;

                CustS.Reset();
                CustS.SetRange("No.", "Sell-to Customer No.");
                if CustS.Find('-') then;


            end;

            trigger OnPreDataItem()
            begin
                SetRange("Planned Delivery Date", PDate, PDate2);
                //if "Sales Line".GetFilter("Planned Delivery Date") = '' then
                //   Error('Please.. Insert Planed Delivery Date.');
            end;

        }


    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(option)
                {
                    field(PDate; PDate)
                    {
                        ApplicationArea = all;
                        Caption = 'Plan from Date';
                        Visible = true;
                    }
                    field(PDate2; PDate2)
                    {
                        ApplicationArea = all;
                        Caption = 'Plan to Date';
                        Visible = true;
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        PDate := Today;
        PDate2 := Today;
    end;

    var
        PDate: Date;
        PDate2: Date;
        Text000: Label 'Sales lines must be shown.';
        SalesHeader: Record "Sales Header";
        ReservEntry: Record "Reservation Entry";
        ReservEntryFrom: Record "Reservation Entry";
        TempSalesLines: Record "Sales Line";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        UOMMgt: Codeunit "Unit of Measure Management";
        OldDocumentNo: Code[20];
        OldDocumentType: Enum "Sales Line Type";
        ShowSalesLineGrHeader2: Boolean;
        ShowSalesLines: Boolean;
        ShowReservationEntries: Boolean;
        ModifyQtyToShip: Boolean;
        ClearDocumentStatus: Boolean;
        ReservText: Text[80];
        ShowReservDate: Date;
        LineReceiptDate: Date;
        DocumentReceiptDate: Date;
        LineStatus: Option " ",Shipped,"Full Shipment","Partial Shipment","No Shipment";
        DocumentStatus: Option " ",Shipped,"Full Shipment","Partial Shipment","No Shipment";
        LineQuantityOnHand: Decimal;
        EntryQuantityOnHand: Decimal;
        SalesResrvtnAvalbtyCaptionLbl: Label 'Sales Shipment Availability';
        CurrRepPageNoCaptionLbl: Label 'Page';
        SalesLineShpmtDtCaptionLbl: Label 'Shipment Date';
        LineReceiptDateCaptionLbl: Label 'Status Overdue';
        LineStatusCaptionLbl: Label 'Shipment Status';
        LineQuantityOnHandCaptionLbl: Label 'Quantity on Hand';
        OverDueStatus: Text[30];
        CustS: Record Customer;
        SalesH: Record "Sales Header";
        ItemS: Record Item;
        OnHandQty: Decimal;

}