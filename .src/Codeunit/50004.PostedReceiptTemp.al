codeunit 50004 "Posted Receipt Temp."
{
    TableNo = "Temp. Receipt Header";
    Permissions = tabledata "Item Journal Line" = ridm,
    tabledata "Item Ledger Entry" = ridm,
    tabledata "Item Application Entry" = ridm,
    tabledata "Reservation Entry" = ridm;

    trigger OnRun()
    begin

    end;

    var
        ItemJnlB: Record "Item Journal Batch";
        ItemJnlL: Record "Item Journal Line";
        ItemLedger: Record "Item Ledger Entry";
        ItemTracking: Record "Reservation Entry";
        PostedStock: Codeunit "Posted Stock";

    procedure Code(var TempH: Record "Temp. Receipt Header")
    var
        TempLC: Record "Temp. Receipt Line";
    begin
        //Check//
        // if TempH."Skip Check" then
        CheckStatus(TempH);
        //Posted Jnl//
        ClearItemJnl();
        //Posted Qty//
        TempLC.Reset();
        TempLC.SetRange("Document No.", TempH."Receipt No.");
        TempLC.SetFilter("Part No.", '<>%1', '');
        TempLC.SetFilter(Quantity, '<>%1', 0);
        if TempLC.Find('-') then begin
            repeat
                //  ItemJnlPost(TempLC, TempH);
                PostedStock.TempDLReceipt(TempLC, TempH, TempLC.Quantity, '');
                TempLC.Status := TempLC.Status::Completed;
                TempLC.Modify();
            until TempLC.Next = 0;

        end;
        //Posted NG//
        ClearItemJnl();
        TempLC.Reset();
        TempLC.SetRange("Document No.", TempH."Receipt No.");
        TempLC.SetFilter("Part No.", '<>%1', '');
        TempLC.SetFilter(NGQ, '<>%1', 0);
        if TempLC.Find('-') then begin
            repeat
                PostedStock.TempDLReceipt(TempLC, TempH, TempLC.NGQ, 'NG');
            until TempLC.Next = 0;
            //JnlPosted();
        end;
        //Posted Status Update//
        TempLC.Reset();
        TempLC.SetRange("Document No.", TempH."Receipt No.");
        TempLC.SetFilter("Part No.", '<>%1', '');
        TempLC.SetFilter(Quantity, '<>%1', 0);
        TempLC.SetRange(Status, TempLC.Status::Completed);
        if TempLC.Find('-') then begin
            repeat
                UpdateReceipt(TempLC, TempH);
            until TempLC.Next = 0;
        end;
    end;

    procedure JnlPosted()
    var
        ItemJnlLine: Record "Item Journal Line";
    begin
        ItemJnlLine.RESET;
        ItemJnlLine.SETRANGE("Reason Code", 'BYAUTO');
        ItemJnlLine.SETRANGE("Journal Batch Name", 'Z-AUTO');
        ItemJnlLine.SETRANGE("Journal Template Name", 'ITEM');
        IF ItemJnlLine.FIND('-') THEN BEGIN
            //ProdMgt
            CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post Batch", ItemJnlLine);
        end;
    end;

    procedure CheckStatus(TempHC: Record "Temp. Receipt Header")
    var
        TempLC: Record "Temp. Receipt Line";
        TempLO: Record "Temporary DL Req. Line";
        SumQ: Decimal;
        ItemS: Record Item;
    begin

        TempLC.Reset();
        TempLC.SetRange("Document No.", TempHC."Receipt No.");
        TempLC.SetFilter("Part No.", '<>%1', '');
        if TempLC.Find('-') then begin
            repeat
                TempLC."Line Total" := TempLC.Quantity + TempLC.NGQ;
                TempLC.Modify();
            until TempLC.Next = 0;
        end;

        TempLC.Reset();
        TempLC.SetRange("Document No.", TempHC."Receipt No.");
        TempLC.SetFilter("Part No.", '<>%1', '');
        TempLC.SetFilter(Quantity, '<>%1', 0);
        if TempLC.Find('-') then begin
            repeat
                SumQ := 0;
                TempLO.Reset();
                TempLO.SetRange("Part No.", TempLC."Part No.");
                TempLO.SetRange("Lot No.", TempLC."Lot No.");
                TempLO.SetFilter("Remain Qty", '>%1', 0);
                if TempLO.Find('-') then begin
                    repeat
                        SumQ += TempLO."Remain Qty";
                    until TempLO.Next = 0;
                end;
                if SumQ < (TempLC.Quantity + TempLC.NGQ) then begin
                    Error(TempLC."Part No." + ' Quantity not enough! with Lot No. ' + TempLC."Lot No.");
                end;
                ItemS.Get(TempLC."Part No.");
                if ItemS.Location = '' then begin
                    Error(TempLC."Part No." + ' Location Empty! ');
                end;
                if TempLC."Lot No." = '' then
                    Error(TempLC."Part No." + ' Lot No. Empty! ');
            until TempLC.Next = 0;
        end;
    end;

    procedure ItemJnlPost(TempLC: Record "Temp. Receipt Line"; TempH: Record "Temp. Receipt Header")
    var
        ItemJnl: Record "Item Journal Line";
        LOC: Code[20];
        ItemS: Record Item;
        ItemJnlTemplate: Record "Item Journal Template";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
    begin
        //Create Detail
        ItemJnlTemplate.GET('ITEM');
        ItemS.Reset();
        ItemS.SetRange("No.", TempLC."Part No.");
        if ItemS.Find('-') then;

        LOC := ItemS.Location;
        if CheckLedgerEntry(TempLC."Document No.", TempLC."Part No.", TempLC."Lot No.", LOC) then begin
            ItemJnl.Init();
            ItemJnl."Journal Batch Name" := 'Z-AUTO';
            ItemJnl."Journal Template Name" := 'ITEM';
            ItemJnl."Entry Type" := ItemJnl."Entry Type"::"Positive Adjmt.";
            ItemJnl."Document Type" := ItemJnl."Document Type"::"Transfer Receipt";
            ItemJnl."Document No." := TempH."Receipt No.";
            ItemJnl."Line No." := TempLC."Line No.";
            ItemJnl."Document Date" := WORKDATE;
            ItemJnl."Posting Date" := TempH."Receipt Date";
            ItemJnl."Document Line No." := TempLC."Line No.";
            ItemJnl.Validate("Item No.", TempLC."Part No.");
            ItemJnl.Validate("Location Code", ItemS.Location);
            ItemJnl."Gen. Bus. Posting Group" := 'DOMESTIC';
            ItemJnl."Source Code" := ItemJnlTemplate."Source Code";
            ItemJnl."External Document No." := TempH."Ref. No.";
            // ItemJnl."Order Line No." := TempLC."Line No.";
            ItemJnl."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnl."Qty. per Unit of Measure" := 1;
            ItemJnl.VALIDATE(Quantity, TempLC.Quantity);
            ItemJnl.VALIDATE("Quantity (Base)", TempLC.Quantity);
            ItemJnl.Validate("Unit Amount", 0);
            ItemJnl."Reason Code" := 'TEMPRC';
            // if TempH.Group = 'PD1' then
            //     ItemJnl."Shortcut Dimension 1 Code" := 'PD1'
            // else
            //     if TempH.Group = 'PD3' then
            //         ItemJnl."Shortcut Dimension 1 Code" := 'PD3'
            //     else
            //         if (TempH.Group = 'PD2_W1') or (TempH.Group = 'PD2_W2') then
            //             ItemJnl."Shortcut Dimension 1 Code" := 'PD2'
            //         else
            //             ItemJnl."Shortcut Dimension 1 Code" := 'INV';

            ItemJnl."Shortcut Dimension 2 Code" := TempH."Receipt By";
            ItemJnl.INSERT;
            //////Insert Item Tracking//
            if ItemS."Item Category Code" <> '' then begin
                DeleteItemTracking(ItemJnl);

                ItemTacking.RESET;
                IF (ItemTacking.FINDLAST) THEN
                    ItemEntryNo := ItemTacking."Entry No." + 1;
                ItemTacking.INIT;
                ItemTacking."Entry No." := ItemEntryNo;
                ItemTacking."Item No." := ItemJnl."Item No.";
                ItemTacking."Source ID" := 'ITEM';
                ItemTacking."Source Batch Name" := 'Z-AUTO';
                ItemTacking."Source Prod. Order Line" := 0;
                ItemTacking."Source Ref. No." := ItemJnl."Line No.";
                ItemTacking."Location Code" := ItemJnl."Location Code";
                ItemTacking.Positive := TRUE;
                ItemTacking."Qty. to Handle (Base)" := ItemJnl."Quantity (Base)";
                ItemTacking."Qty. to Invoice (Base)" := ItemJnl."Quantity (Base)";
                ItemTacking."Quantity (Base)" := ItemJnl."Quantity (Base)";
                ItemTacking.Validate("Quantity", ItemJnl.Quantity);
                ItemTacking."Expected Receipt Date" := Today;
                ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"2";
                ItemTacking."Lot No." := TempLC."Lot No.";
                // ItemTacking."New Lot No." := QueryReclass.LotNo;
                ItemTacking."Reservation Status" := ItemTacking."Reservation Status"::Prospect;
                ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                ItemTacking."Creation Date" := WORKDATE;
                ItemTacking."Created By" := USERID;
                ItemTacking."Source Type" := 83;
                ItemTacking.INSERT;
            end;

        end;

    end;

    procedure ItemJnlPost_NG(TempLC: Record "Temp. Receipt Line"; TempH: Record "Temp. Receipt Header")
    var
        ItemJnl: Record "Item Journal Line";
        LOC: Code[20];
        ItemS: Record Item;
        ItemJnlTemplate: Record "Item Journal Template";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        UQTY: Decimal;
    begin
        UQTY := TempLC.NGQ;
        if UQTY <= 0 then
            exit;
        //Create Detail
        ItemJnlTemplate.GET('ITEM');

        ItemS.Reset();
        ItemS.SetRange("No.", TempLC."Part No.");
        if ItemS.Find('-') then;

        LOC := 'NG';
        if CheckLedgerEntry(TempLC."Document No.", TempLC."Part No.", TempLC."Lot No.", LOC) then begin
            ItemJnl.Init();
            ItemJnl."Journal Batch Name" := 'Z-AUTO';
            ItemJnl."Journal Template Name" := 'ITEM';
            ItemJnl."Entry Type" := ItemJnl."Entry Type"::"Positive Adjmt.";
            ItemJnl."Document Type" := ItemJnl."Document Type"::"Transfer Receipt";
            ItemJnl."Document No." := TempH."Receipt No.";
            ItemJnl."Line No." := TempLC."Line No.";
            ItemJnl."Document Date" := WORKDATE;
            ItemJnl."Posting Date" := TempH."Receipt Date";
            ItemJnl."Document Line No." := TempLC."Line No.";
            ItemJnl.Validate("Item No.", TempLC."Part No.");
            ItemJnl.Validate("Location Code", LOC);
            ItemJnl."Gen. Bus. Posting Group" := 'DOMESTIC';
            ItemJnl."Source Code" := ItemJnlTemplate."Source Code";
            ItemJnl."External Document No." := TempH."Ref. No.";
            // ItemJnl."Order Line No." := TempLC."Line No.";
            ItemJnl."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnl."Qty. per Unit of Measure" := 1;
            ItemJnl.VALIDATE(Quantity, UQTY);
            ItemJnl.VALIDATE("Quantity (Base)", UQTY);
            ItemJnl.Validate("Unit Amount", 0);
            ItemJnl."Reason Code" := 'TEMPRC';
            // if TempH.Group = 'PD1' then
            //     ItemJnl."Shortcut Dimension 1 Code" := 'PD1'
            // else
            //     if TempH.Group = 'PD3' then
            //         ItemJnl."Shortcut Dimension 1 Code" := 'PD3'
            //     else
            //         if (TempH.Group = 'PD2_W1') or (TempH.Group = 'PD2_W2') then
            //             ItemJnl."Shortcut Dimension 1 Code" := 'PD2'
            //         else
            //             ItemJnl."Shortcut Dimension 1 Code" := 'INV';

            ItemJnl."Shortcut Dimension 2 Code" := TempH."Receipt By";
            ItemJnl.INSERT;
            //////Insert Item Tracking//
            if ItemS."Item Category Code" <> '' then begin
                DeleteItemTracking(ItemJnl);
                ItemTacking.RESET;
                IF (ItemTacking.FINDLAST) THEN
                    ItemEntryNo := ItemTacking."Entry No." + 1;
                ItemTacking.INIT;
                ItemTacking."Entry No." := ItemEntryNo;
                ItemTacking."Item No." := ItemJnl."Item No.";
                ItemTacking."Source ID" := 'ITEM';
                ItemTacking."Source Batch Name" := 'Z-AUTO';
                ItemTacking."Source Prod. Order Line" := 0;
                ItemTacking."Source Ref. No." := ItemJnl."Line No.";
                ItemTacking."Location Code" := LOC;
                ItemTacking.Positive := TRUE;
                ItemTacking."Qty. to Handle (Base)" := ItemJnl."Quantity (Base)";
                ItemTacking."Qty. to Invoice (Base)" := ItemJnl."Quantity (Base)";
                ItemTacking."Quantity (Base)" := ItemJnl."Quantity (Base)";
                ItemTacking.Validate("Quantity", ItemJnl.Quantity);
                ItemTacking."Expected Receipt Date" := Today;
                ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"2";
                ItemTacking."Lot No." := TempLC."Lot No.";
                // ItemTacking."New Lot No." := QueryReclass.LotNo;
                ItemTacking."Reservation Status" := ItemTacking."Reservation Status"::Prospect;
                ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                ItemTacking."Creation Date" := WORKDATE;
                ItemTacking."Created By" := USERID;
                ItemTacking."Source Type" := 83;
                ItemTacking.INSERT;
            end;
        end;

    end;

    procedure UpdateReceipt(TempLC: Record "Temp. Receipt Line"; TempH: Record "Temp. Receipt Header")
    var
        TempReqL: Record "Temporary DL Req. Line";
        TempReqH: Record "Temporary DL Req.";
        RMQ: Decimal;
        UMQ: Decimal;
    begin
        RMQ := 0;
        UMQ := TempLC.Quantity + TempLC.NGQ;
        TempReqL.Reset();
        TempReqL.SetCurrentKey("Document No.");
        TempReqL.SetRange("Part No.", TempLC."Part No.");
        TempReqL.SetRange("Lot No.", TempLC."Lot No.");
        TempReqL.SetFilter("Remain Qty", '>%1', 0);
        if TempReqL.Find('-') then begin
            repeat
                if UMQ > 0 then begin
                    if TempReqL."Remain Qty" <= UMQ then begin
                        UMQ := UMQ - TempReqL."Remain Qty";
                        TempReqL.setSkip(true);
                        TempReqL.Validate("Receipt Qty", TempReqL."Receipt Qty" + TempReqL."Remain Qty");
                        TempReqL.Status := TempReqL.Status::Completed;
                        TempReqL.Modify();
                        UpdateHeader(TempReqL."Document No.");
                    end
                    else begin
                        TempReqL.setSkip(true);
                        TempReqL.Validate("Receipt Qty", TempReqL."Receipt Qty" + UMQ);
                        TempReqL.Status := TempReqL.Status::Patial;
                        TempReqL.Modify();
                        UMQ := 0;
                        UpdateHeader(TempReqL."Document No.");
                    end;
                end;
            until TempReqL.Next = 0;
        end;
        //Update Header//      
    end;

    local procedure UpdateHeader(DocNo: Code[20])
    var
        TempReqH: Record "Temporary DL Req.";
        TempReqL: Record "Temporary DL Req. Line";
        RMQ: Decimal;
    begin
        RMQ := 0;
        TempReqL.Reset();
        TempReqL.SetRange("Document No.", DocNo);
        if TempReqL.Find('-') then begin
            repeat
                RMQ += TempReqL."Remain Qty";
            until TempReqL.Next = 0;
        end;
        TempReqH.Reset();
        TempReqH.SetRange(DLNo, DocNo);
        if TempReqH.Find('-') then begin
            if RMQ > 0 then
                TempReqH.Status := TempReqH.Status::Patial
            else
                TempReqH.Status := TempReqH.Status::Completed;
            TempReqH.Modify();
        end;
    end;

    local procedure ClearItemJnl()
    var
        ItemJnlLineChk: Record "Item Journal Line";
    begin
        //Delete Template
        ItemJnlLineChk.RESET;
        ItemJnlLineChk.SETRANGE("Journal Batch Name", 'Z-AUTO');
        ItemJnlLineChk.SETRANGE("Journal Template Name", 'ITEM');
        IF ItemJnlLineChk.FIND('-') THEN BEGIN
            ItemJnlLineChk.DELETEALL(true);
        END;
    end;

    LOCAL procedure CheckLedgerEntry(DocNo: Code[20]; PartNo: Code[50]; LotNo: Code[50]; WH: Code[30]): Boolean
    var
        ItemLedgerEntry2: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry2.RESET;
        ItemLedgerEntry2.SETRANGE("Item No.", PartNo);
        ItemLedgerEntry2.SETRANGE("Document No.", DocNo);
        ItemLedgerEntry2.SETRANGE("Lot No.", LotNo);
        ItemLedgerEntry2.SETRANGE("Location Code", WH);
        IF NOT ItemLedgerEntry2.FIND('-') THEN BEGIN
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;

    local procedure DeleteItemTracking(ItemJnlLine: Record "Item Journal Line")
    var
        ItemTacking: Record "Reservation Entry";
    begin
        ItemTacking.RESET;
        ItemTacking.SETRANGE("Item No.", ItemJnlLine."Item No.");
        ItemTacking.SETRANGE("Source Type", 83);
        ItemTacking.SETRANGE("Source ID", 'ITEM');
        ItemTacking.SETRANGE("Source Batch Name", 'Z-AUTO');
        ItemTacking.SETRANGE("Location Code", ItemJnlLine."Location Code");
        IF ItemTacking.FIND('-') THEN BEGIN
            ItemTacking.DELETEALL(true);
        END;
    end;



}

