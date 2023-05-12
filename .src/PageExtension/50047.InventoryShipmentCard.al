pageextension 50047 "Inventory Shipment Card" extends "Invt. Shipment"
{

    layout
    {
        addlast(content)
        {
            usercontrol(SetFieldFocus; SetFieldFocus)
            {
                ApplicationArea = All;
                trigger Ready()
                begin
                    CurrPage.SetFieldFocus.SetFocusOnField('No.');
                end;
            }
        }
        modify("No.")
        {
            CaptionClass = 'Shipment No.';
            trigger OnAfterValidate()

            begin
                "Gen. Bus. Posting Group" := 'DOMESTIC';
                "Create Date" := CurrentDateTime;
                "Create By" := utility.UserFullName(UserId);
                Validate("Location Code", 'WHS');

            end;

        }
        modify("External Document No.")
        {
            Caption = 'Ref. Doc No.';
            trigger OnAfterValidate()
            var
                DMDH: Record "Material Delivery Header";
            begin
                if "External Document No." = '' then begin
                    if "Ref.Doc" <> '' then begin
                        DMDH.Reset();
                        DMDH.SetRange("Req. No.", "Ref.Doc");
                        if DMDH.Find('-') then begin
                            DMDH.Status := DMDH.Status::Completed;
                            DMDH.Modify();
                        end;
                        "Ref.Doc" := '';
                    end;
                end;
            end;
        }
        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                if "No." <> '' then begin
                    "Gen. Bus. Posting Group" := 'DOMESTIC';
                    "Create Date" := CurrentDateTime;
                    "Create By" := utility.UserFullName(UserId);
                end;

            end;
        }

        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Document Date") { Visible = true; ShowMandatory = true; }

        modify("Posting Date")
        {
            Caption = 'Shipment Date';
            ShowMandatory = true;
            trigger OnAfterValidate()
            begin
                "Document Date" := "Posting Date";
            end;
        }
        modify("Salesperson/Purchaser Code") { CaptionClass = 'Ship by'; }
        modify(Correction) { Visible = false; }
        modify("Posting Description")
        {
            CaptionClass = 'Remark';
        }
        addafter(Status)
        {
            field("Create Date"; "Create Date")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("Create By"; "Create By")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("Ref.Doc"; "Ref.Doc")
            {
                Caption = 'Ref. Doc DL';
                ApplicationArea = all;
                Visible = true;
                Editable = false;
            }
            field(Customer; Customer)
            {
                ApplicationArea = all;
                ToolTip = 'if you Shipping for Sales please.. Select Customer';
            }
        }
        addbefore(ShipmentLines)
        {

            group(ScanKanban)
            {
                Caption = 'Scan Kanban';
                field(Scaner; Scaner)
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        if Scaner <> '' then begin
                            //Insert to PurLine//
                            AddItemOrKanban(Scaner, format("Scan Item"));
                            //  Rec.Validate("Invoice Discount Amount", 0);
                            /////////////////////
                        end;
                        Scaner := '';
                        CurrPage.SetFieldFocus.SetFocusOnField('Scaner');

                    end;
                }
                field("Scan Item"; "Scan Item")
                {
                    ApplicationArea = all;
                }
            }

        }
    }
    actions
    {
        modify("P&ost") { Visible = false; }
        modify("Post and &Print") { Visible = false; }

        addafter("P&ost")
        {
            action("P&ost2")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost';
                Ellipsis = true;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                // RunObject = Codeunit "Invt. Doc.-Post (Yes/No)";
                ShortCutKey = 'F9';
                ToolTip = 'Record the related transaction in your books.';
                trigger OnAction()
                var
                    ConfirmPostQst: Label 'Do you want to post Inventory Document?';
                    InvtYesNo: Codeunit "Invt. Doc.-Post (Yes/No)";
                    InvtDocPostShipment: Codeunit "Invt. Doc.-Post Shipment XTH";
                    PostedH: Codeunit "Posted Stock";
                    Docx: Code[20];
                    DLMH: Record "Material Delivery Header";
                    Cust: Code[20];
                begin
                    Cust := Rec.Customer;
                    CheckDelivery();
                    if not Confirm(ConfirmPostQst, false) then
                        exit;
                    Docx := Rec."Ref.Doc";
                    GetnLot(Rec."No.");

                    InvtDocPostShipment.Run(Rec);
                    utility.UpdateSalesOrderLine();
                    if Docx <> '' then begin
                        DLMH.Reset();
                        DLMH.SetRange("Req. No.", Docx);
                        if DLMH.Find('-') then begin
                            DLMH.Status := DLMH.Status::Completed;
                            DLMH.Modify();
                        end;
                        PostedH.PostedStockToOnProcess(Docx);
                    end;



                end;
            }

        }
        addafter("Copy Document...")
        {
            action(getMDL)
            {
                Caption = 'Get Material Delivery';
                ApplicationArea = all;
                Image = List;
                trigger OnAction()
                var
                    MaterialH: Record "Material Delivery Header";
                    getMDLPage: Page "Delivery Material List";
                    InvtL: Record "Invt. Document Line";
                    Docx2: Code[20];
                begin

                    Docx2 := Rec."No.";
                    if Rec."Location Code" = '' then
                        Error('Location Code Empty!');
                    if Rec."External Document No." <> '' then
                        Error('Please.. Delete Value in Ref.Doc No.');

                    InvtL.Reset();
                    InvtL.SetRange("Document No.", Docx2);
                    if NOT InvtL.Find('-') then begin
                        //  Rec."External Document No." := '';
                        // Rec."Ref.Doc" := '';

                        MaterialH.Reset();
                        MaterialH.SetAutoCalcFields("Shipment No.");
                        MaterialH.SetFilter("Shipment No.", '%1', '');
                        if MaterialH.Find('-') then begin
                            getMDLPage.SetTableView(MaterialH);
                            getMDLPage.Editable := false;
                            getMDLPage.setDoc(Docx2);
                            getMDLPage.RunModal();
                        end;

                    end
                    else begin
                        Error('Invt. Line Not Empty!');
                    end;
                end;
            }
        }
    }
    var
        utility: Codeunit Utility;

    procedure CheckDelivery()
    var
        Err: Text[20];
        SalesL: Record "Sales Line";
        InvtL: Record "Invt. Document Line";
        ItemS: Record Item;
    begin
        InvtL.Reset();
        InvtL.SetRange("Document No.", Rec."No.");
        InvtL.SetRange("Reason Code", 'DELIVERY');
        InvtL.SetFilter(Quantity, '>%1', 0);
        if InvtL.Find('-') then begin
            if Rec.Customer = '' then
                Error('Please.. Select Customer.');
            repeat
                SalesL.Reset();
                SalesL.SetRange("No.", InvtL."Item No.");
                SalesL.SetRange("Planned Delivery Date", Rec."Document Date");
                SalesL.SetRange("Sell-to Customer No.", Rec.Customer);
                SalesL.SetFilter("Outstanding Quantity", '>%1', 0);
                if NOT SalesL.Find('-') then
                    Error('Can not Ship Plan Delivery Date Not Match!');
            until InvtL.Next = 0;
        end;

        InvtL.Reset();
        InvtL.SetRange("Document No.", Rec."No.");
        InvtL.SetRange("Reason Code", 'PROCESS');
        InvtL.SetFilter(Quantity, '>%1', 0);
        if InvtL.Find('-') then begin
            repeat
                ItemS.Reset();
                ItemS.SetRange("No.", InvtL."Item No.");
                ItemS.SetRange("To Material Item", '');
                if ItemS.Find('-') then
                    Error('To Material Item on Item Card Empty!');
            until InvtL.Next = 0;
        end;


    end;



    procedure AddItemOrKanban(Scaner: Code[100]; ScanItem: Text[20])
    var
        KanbanL: Record "Kanban List";
        ItemS: Record Item;
        PartNo: Code[20];
        InvtL: Record "Invt. Document Line";
        RowNo: Integer;
        QtyK: Decimal;
    begin
        PartNo := Scaner;
        QtyK := 1;
        if ScanItem = 'Kanban' then begin
            KanbanL.Reset();
            KanbanL.SetRange("Master No.", Scaner);
            if KanbanL.Find('-') then begin
                PartNo := KanbanL."Part No.";
                QtyK := KanbanL.Qty;
            end;
        end;
        ItemS.Reset();
        ItemS.SetRange("No.", PartNo);
        if ItemS.Find('-') then begin
            InvtL.Reset();
            InvtL.SetRange("Document No.", Rec."No.");
            if InvtL.FindLast() then
                RowNo := InvtL."Line No.";
            RowNo := RowNo + 10000;

            InvtL.Reset();
            InvtL.Init();
            InvtL."Document No." := Rec."No.";
            InvtL."Line No." := RowNo;
            InvtL."Document Type" := InvtL."Document Type"::Shipment;
            InvtL.Validate("Item No.", ItemS."No.");
            InvtL.Description := ItemS.Description;
            InvtL.Validate("Unit of Measure Code", ItemS."Base Unit of Measure");
            InvtL.Validate("Posting Date", Rec."Posting Date");
            InvtL."Document Date" := Rec."Document Date";
            InvtL."Location Code" := Rec."Location Code";
            InvtL."Inventory Posting Group" := ItemS."Inventory Posting Group";
            InvtL."Gen. Bus. Posting Group" := Rec."Gen. Bus. Posting Group";
            InvtL.Validate(Quantity, QtyK);
            InvtL.Validate("Quantity (Base)", QtyK);
            InvtL."Item Category Code" := ItemS."Item Category Code";
            InvtL."Reason Code" := 'FACTORY';
            if ItemS."Inventory Posting Group" = 'FG' then
                InvtL."Reason Code" := 'DELIVERY';
            if InvtL."Qty. per Unit of Measure" = 0 then
                InvtL."Qty. per Unit of Measure" := 1;
            InvtL.Insert();
        end;

    end;

    procedure GetnLot(DocNo: Code[30])
    var
        ItemTacking: Record "Reservation Entry";
        InvtH: Record "Invt. Document Header";
        InvtL: Record "Invt. Document Line";
        ItemLedger: Record "Item Ledger Entry";
        QtyU: Decimal;
        QtyS: Decimal;
    begin
        InvtH.Reset();
        InvtH.SetRange("No.", DocNo);
        if InvtH.Find('-') then begin
            // ItemTacking.RESET;
            // ItemTacking.SETRANGE("Source Type", 5851);
            // ItemTacking.SETRANGE("Source ID", DocNo);
            // IF ItemTacking.FIND('-') THEN BEGIN
            //     ItemTacking.DELETEALL;
            // END;
            InvtL.Reset();
            InvtL.SetRange("Document No.", InvtH."No.");
            if InvtL.Find('-') then begin
                repeat
                    ItemTacking.Reset();
                    ItemTacking.SetRange("Source ID", InvtH."No.");
                    ItemTacking.SetRange("Source Type", 5851);
                    ItemTacking.SetRange("Item No.", InvtL."Item No.");
                    ItemTacking.SetRange("Location Code", InvtL."Location Code");
                    ItemTacking.SetRange("Source Ref. No.", InvtL."Line No.");
                    if not ItemTacking.Find('-') then begin
                        QtyU := InvtL.Quantity;
                        ItemLedger.RESET;
                        ItemLedger.SetCurrentKey("Posting Date", "Lot No.", "Entry No.");
                        ItemLedger.SETRANGE("Item No.", InvtL."Item No.");
                        ItemLedger.SETRANGE(Open, TRUE);
                        ItemLedger.SETFILTER("Remaining Quantity", '<>%1', 0);
                        ItemLedger.SETRANGE("Location Code", InvtL."Location Code");
                        IF ItemLedger.FIND('-') THEN BEGIN
                            repeat
                                QtyS := 0;
                                if QtyU > 0 then begin
                                    if ItemLedger."Remaining Quantity" <= QtyU then begin
                                        QtyU := QtyU - ItemLedger."Remaining Quantity";
                                        QtyS := ItemLedger."Remaining Quantity";
                                        InsertAutoLot(InvtL, QtyS, ItemLedger."Lot No.");
                                    end
                                    else begin
                                        QtyS := QtyU;
                                        QtyU := 0;
                                        InsertAutoLot(InvtL, QtyS, ItemLedger."Lot No.");
                                    end;
                                end;

                            until ItemLedger.Next = 0;
                        end;

                    end;
                until InvtL.Next = 0;
            end;
        end;

    end;

    procedure InsertAutoLot(var InvtL: Record "Invt. Document Line"; QtyS: Decimal; LotNo: code[30])
    var
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
    begin
        ItemTacking.RESET;
        IF (ItemTacking.FINDLAST) THEN
            ItemEntryNo := ItemTacking."Entry No." + 1;
        ItemTacking.INIT;
        ItemTacking."Entry No." := ItemEntryNo;
        ItemTacking."Item No." := InvtL."Item No.";
        ItemTacking."Source ID" := InvtL."Document No.";
        ItemTacking."Source Type" := 5851;
        ItemTacking."Source Batch Name" := '';
        ItemTacking."Source Prod. Order Line" := 0;
        ItemTacking."Source Ref. No." := InvtL."Line No.";
        ItemTacking.Positive := FALSE;
        ItemTacking."Location Code" := InvtL."Location Code";
        ItemTacking."Quantity (Base)" := QtyS * -1;
        ItemTacking.Quantity := QtyS * -1;
        ItemTacking."Qty. to Handle (Base)" := QtyS * -1;
        ItemTacking."Qty. to Invoice (Base)" := QtyS * -1;
        ItemTacking."Lot No." := LotNo;
        //ItemTacking."New Lot No." := QueryReclass.LotNo;
        ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"1";
        ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
        ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
        ItemTacking."Creation Date" := WORKDATE;
        ItemTacking."Created By" := USERID;
        ItemTacking."Shipment Date" := InvtL."Document Date";
        ItemTacking.INSERT;
    end;

    procedure getInsertMDL(var MDLH: Record "Material Delivery Header"; DocNo: Code[20])
    var
        InvtH: Record "Invt. Document Header";
        InvtL: Record "Invt. Document Line";
        MDH: Record "Material Delivery Header";
        MDL: Record "Material Delivery Line";
        RowS: Integer;
        ItemS: Record Item;
    begin
        RowS := 10000;
        InvtH.Reset();
        InvtH.SetRange("No.", DocNo);
        InvtH.SetRange("Document Type", InvtH."Document Type"::Shipment);
        if InvtH.Find('-') then begin

            MDL.Reset();
            MDL.SetRange("Document No.", MDLH."Req. No.");
            if MDL.Find('-') then begin
                repeat
                    ItemS.Reset();
                    ItemS.Get(MDL."Part No.");
                    InvtL.Init();
                    InvtL."Document No." := InvtH."No.";
                    InvtL."Line No." := RowS;
                    InvtL."Document Type" := InvtL."Document Type"::Shipment;
                    InvtL.Validate("Item No.", ItemS."No.");
                    InvtL.Description := ItemS.Description;
                    InvtL.Validate("Unit of Measure Code", ItemS."Base Unit of Measure");
                    InvtL.Validate("Posting Date", InvtH."Posting Date");
                    InvtL."Document Date" := InvtH."Document Date";
                    InvtL."Location Code" := InvtH."Location Code";
                    InvtL."Inventory Posting Group" := ItemS."Inventory Posting Group";
                    InvtL."Gen. Bus. Posting Group" := InvtH."Gen. Bus. Posting Group";
                    InvtL.Validate(Quantity, MDL.Quantity);
                    InvtL.Validate("Quantity (Base)", MDL.Quantity);
                    InvtL."Item Category Code" := ItemS."Item Category Code";
                    InvtL."Reason Code" := 'FACTORY';
                    InvtL."MDLH Line No." := MDL."Line No.";
                    InvtL."MDLH No." := MDL."Document No.";
                    if ItemS."Inventory Posting Group" = 'FG' then
                        InvtL."Reason Code" := 'DELIVERY';

                    if MDLH."From Washing" then begin
                        InvtL."Reason Code" := 'PROCESS';
                    end;
                    if InvtL."Qty. per Unit of Measure" = 0 then
                        InvtL."Qty. per Unit of Measure" := 1;
                    InvtL.Insert();
                    // MDL."Shipment Line" := 0;
                    //  MDL."Shipment No." := 0;
                    // MDL."Shipment Quantity" := MDL.Quantity;
                    RowS := RowS + 10000;
                until MDL.Next = 0;
                MDLH."Shipment No." := InvtH."No.";
                MDLH.Status := MDLH.Status::Process;
                MDLH.Modify(false);
                InvtH."External Document No." := MDLH."Req. No.";
                InvtH."Ref.Doc" := MDLH."Req. No.";
                if MDLH."From Washing" then
                    InvtH."Posting Description" := 'From Washing to Process';
                InvtH.Modify(false);


            end;
        end;
    end;
}