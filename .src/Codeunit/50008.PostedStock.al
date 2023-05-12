codeunit 50008 "Posted Stock"
{
    Permissions = tabledata "Item Ledger Entry" = ridm,
    tabledata "Sales Line" = ridm,
    tabledata "Sales Header" = ridm,
    tabledata "Invt. Document Header" = ridm,
    tabledata "Invt. Receipt Line" = ridm,
    tabledata "Material Delivery Header" = ridm,
    tabledata "Transfer Production Header" = ridm,
    tabledata "Assembly Header" = ridm,
    tabledata "Assembly Line" = ridm,
    tabledata "Value Entry" = ridm,
    tabledata "Item Application Entry" = ridm;
    LOCAL procedure PostItemJnlLine(VAR ItemJnlLine: Record "Item Journal Line"; VAR ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
    var
        OrigItemJnlLine: Record "Item Journal Line";
        ItemShptEntry: Integer;
    begin
        OrigItemJnlLine := ItemJnlLine;
        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
        ItemShptEntry := ItemJnlLine."Item Shpt. Entry No.";
        ItemJnlLine := OrigItemJnlLine;
        ItemJnlLine."Item Shpt. Entry No." := ItemShptEntry;
    end;

    procedure ProductionRecordPosted_NG(ProRecH: Record "Production Record Header"; ProRecL: Record "Production Record Line")
    var
        ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        UQty: Decimal;
        PostedStock: Codeunit "Posted Stock";
    begin
        UQty := ProRecL."NG Qty";
        if (UQty <= 0) then
            exit;
        ItemS.Reset();
        ItemS.SetRange("No.", ProRecL."Part No.");
        if ItemS.Find('-') then begin
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-AUTO');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);

            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-AUTO';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Posted Assembly";
            ItemJnlLine."Document No." := ProRecH."Req. No.";
            ItemJnlLine."Document Date" := ProRecH."Req. Date";
            ItemJnlLine."Document Line No." := ProRecL."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := ProRecL."Part No.";
            ItemJnlLine."External Document No." := ProRecH."Ref. Document";
            ItemJnlLine."Posting Date" := ProRecH."Req. Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := ProRecL."Part No.";
            ItemJnlLine.VALIDATE("Location Code", 'NG');
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";

            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := UQty;
            ItemJnlLine."Invoiced Quantity" := UQty;
            ItemJnlLine."Quantity (Base)" := UQty;
            ItemJnlLine."Invoiced Qty. (Base)" := UQty;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;

            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'PROD.REC';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine.Insert();

            if ItemS."Item Tracking Code" <> '' then
                if ProRecL."Lot No." <> '' then begin
                    ItemTacking.Reset();
                    ItemTacking.SetRange("Source ID", 'ITEM');
                    ItemTacking.SetRange("Source Batch Name", 'Z-AUTO');
                    ItemTacking.SetRange("Item No.", ProRecL."Part No.");
                    if ItemTacking.Find('-') then
                        ItemTacking.DeleteAll(true);

                    ItemTacking.RESET;
                    IF (ItemTacking.FINDLAST) THEN
                        ItemEntryNo := ItemTacking."Entry No." + 1;

                    ItemTacking.INIT;
                    ItemTacking."Entry No." := ItemEntryNo;
                    ItemTacking."Item No." := ItemS."No.";
                    ItemTacking."Source ID" := 'ITEM';
                    ItemTacking."Source Batch Name" := 'Z-AUTO';
                    ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"2";
                    ItemTacking."Source Type" := 83;

                    ItemTacking."Source Prod. Order Line" := 0;
                    ItemTacking."Source Ref. No." := 10000;
                    ItemTacking.Positive := true;
                    ItemTacking."Location Code" := 'NG';
                    ItemTacking."Qty. to Handle (Base)" := UQty;
                    ItemTacking."Qty. to Invoice (Base)" := UQty;
                    ItemTacking.Validate(Quantity, UQty);
                    ItemTacking.Validate("Quantity (Base)", UQty);

                    ItemTacking."Lot No." := ProRecL."Lot No.";

                    ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
                    ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                    ItemTacking."Creation Date" := WORKDATE;
                    ItemTacking."Created By" := USERID;
                    ItemTacking."Expected Receipt Date" := ProRecH."Req. Date";
                    ItemTacking.INSERT();
                end;
            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);
        end;
    end;

    //Re-Open
    procedure ProductionRecordPostedReOpen_NG(ProRecH: Record "Production Record Header"; ProRecL: Record "Production Record Line")
    var
        ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        PostedStock: Codeunit "Posted Stock";
        UQty: Decimal;
    begin
        UQty := ProRecL."NG Qty";
        if UQty <= 0 then
            exit;

        ItemS.Reset();
        ItemS.SetRange("No.", ProRecL."Part No.");
        if ItemS.Find('-') then begin
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-AUTO');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);
            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-AUTO';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Posted Assembly";
            ItemJnlLine."Document No." := ProRecH."Req. No.";
            ItemJnlLine."Document Date" := ProRecH."Req. Date";
            ItemJnlLine."Document Line No." := ProRecL."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := ProRecL."Part No.";

            ItemJnlLine."Posting Date" := ProRecH."Req. Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := ProRecL."Part No.";
            ItemJnlLine.VALIDATE("Location Code", 'NG');
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";
            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := UQty;
            ItemJnlLine."Invoiced Quantity" := UQty;
            ItemJnlLine."Quantity (Base)" := UQty;
            ItemJnlLine."Invoiced Qty. (Base)" := UQty;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;

            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'PROD.REC';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine.Insert();

            if ItemS."Item Tracking Code" <> '' then
                if ProRecL."Lot No." <> '' then begin
                    ItemTacking.Reset();
                    ItemTacking.SetRange("Source ID", 'ITEM');
                    ItemTacking.SetRange("Source Batch Name", 'Z-AUTO');
                    ItemTacking.SetRange("Item No.", ProRecL."Part No.");
                    if ItemTacking.Find('-') then
                        ItemTacking.DeleteAll(true);

                    ItemTacking.RESET;
                    IF (ItemTacking.FINDLAST) THEN
                        ItemEntryNo := ItemTacking."Entry No." + 1;
                    ItemTacking.INIT;
                    ItemTacking."Entry No." := ItemEntryNo;
                    ItemTacking."Item No." := ItemS."No.";
                    ItemTacking."Source ID" := 'ITEM';
                    ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"3";
                    ItemTacking."Source Type" := 83;
                    ItemTacking."Source Batch Name" := 'Z-AUTO';
                    ItemTacking."Source Prod. Order Line" := 0;
                    ItemTacking."Source Ref. No." := 10000;
                    ItemTacking.Positive := false;
                    ItemTacking."Location Code" := 'NG';
                    ItemTacking."Qty. to Handle (Base)" := UQty * -1;
                    ItemTacking."Qty. to Invoice (Base)" := UQty * -1;

                    ItemTacking.Validate("Quantity (Base)", UQty * -1);
                    ItemTacking.Validate(Quantity, UQty * -1);
                    ItemTacking."Lot No." := ProRecL."Lot No.";
                    ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
                    ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                    ItemTacking."Creation Date" := WORKDATE;
                    ItemTacking."Created By" := USERID;
                    ItemTacking."Shipment Date" := ProRecH."Req. Date";
                    ItemTacking.INSERT();
                end;

            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);

        end;
    end;

    procedure CustStockWashing(var TempDLL: Record "Temporary DL Req. Line")
    var
        TempDLH: Record "Temporary DL Req.";
        ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        PostedStock: Codeunit "Posted Stock";
        UQty: Decimal;
        PartNo: Code[20];

    begin
        UQty := TempDLL.Quantity;
        PartNo := TempDLL."Transfer From Item No.";
        if UQty <= 0 then
            exit;
        if TempDLL."Transfer From Item No." = '' then
            exit;

        TempDLH.Reset();
        TempDLH.SetRange(DLNo, TempDLL."Document No.");
        if TempDLH.Find('-') then;

        ItemS.Reset();
        ItemS.SetFilter(Location, '<>%1', '');
        ItemS.SetRange("No.", PartNo);
        if ItemS.Find('-') then begin
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-AUTO');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);
            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-AUTO';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Transfer Shipment";
            ItemJnlLine."Document No." := TempDLL."Document No.";
            ItemJnlLine."Document Date" := TempDLH."Document Date";
            ItemJnlLine."Document Line No." := TempDLL."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := PartNo;

            ItemJnlLine."Posting Date" := TempDLH."Document Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := PartNo;
            ItemJnlLine.VALIDATE("Location Code", ItemS.Location);
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";
            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := UQty;
            ItemJnlLine."Invoiced Quantity" := UQty;
            ItemJnlLine."Quantity (Base)" := UQty;
            ItemJnlLine."Invoiced Qty. (Base)" := UQty;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;

            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'TEMP DL';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine.Insert();
            if TempDLL."Lot No." <> '' then begin


                if ItemS."Item Tracking Code" <> '' then
                    if TempDLL."Lot No." <> '' then begin
                        ItemTacking.Reset();
                        ItemTacking.SetRange("Source ID", 'ITEM');
                        ItemTacking.SetRange("Source Batch Name", 'Z-AUTO');
                        ItemTacking.SetRange("Item No.", PartNo);
                        if ItemTacking.Find('-') then
                            ItemTacking.DeleteAll(true);

                        ItemTacking.RESET;
                        IF (ItemTacking.FINDLAST) THEN
                            ItemEntryNo := ItemTacking."Entry No." + 1;
                        ItemTacking.INIT;
                        ItemTacking."Entry No." := ItemEntryNo;
                        ItemTacking."Item No." := PartNo;
                        ItemTacking."Source ID" := 'ITEM';
                        ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"3";
                        ItemTacking."Source Type" := 83;
                        ItemTacking."Source Batch Name" := 'Z-AUTO';
                        ItemTacking."Source Prod. Order Line" := 0;
                        ItemTacking."Source Ref. No." := 10000;
                        ItemTacking.Positive := false;
                        ItemTacking."Location Code" := ItemS.Location;
                        ItemTacking."Qty. to Handle (Base)" := UQty * -1;
                        ItemTacking."Qty. to Invoice (Base)" := UQty * -1;

                        ItemTacking.Validate("Quantity (Base)", UQty * -1);
                        ItemTacking.Validate(Quantity, UQty * -1);
                        ItemTacking."Lot No." := TempDLL."Lot No.";
                        ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
                        ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                        ItemTacking."Creation Date" := WORKDATE;
                        ItemTacking."Created By" := USERID;
                        ItemTacking."Shipment Date" := TempDLH."Document Date";
                        ItemTacking.INSERT();
                    end;
            end;

            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);
            TempDLL."Cut from Stock" := true;
            TempDLL."Remain Qty" := TempDLL.Quantity - TempDLL."Receipt Qty";
        end;
    end;

    procedure CustStockWashingUNDO(var TempDLL: Record "Temporary DL Req. Line")
    var
        TempDLH: Record "Temporary DL Req.";
        ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        PostedStock: Codeunit "Posted Stock";
        UQty: Decimal;

    begin
        UQty := TempDLL.Quantity;
        if UQty <= 0 then
            exit;
        if TempDLL."Transfer From Item No." = '' then
            exit;

        TempDLH.Reset();
        TempDLH.SetRange(DLNo, TempDLL."Document No.");
        if TempDLH.Find('-') then;

        ItemS.Reset();
        ItemS.SetFilter(Location, '<>%1', '');
        ItemS.SetRange("No.", TempDLL."Transfer From Item No.");
        if ItemS.Find('-') then begin
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-AUTO');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);
            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-AUTO';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Transfer Receipt";
            ItemJnlLine."Document No." := TempDLL."Document No.";
            ItemJnlLine."Document Date" := TempDLH."Document Date";
            ItemJnlLine."Document Line No." := TempDLL."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := ItemS."No.";

            ItemJnlLine."Posting Date" := TempDLH."Document Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := ItemS."No.";
            ItemJnlLine.VALIDATE("Location Code", ItemS.Location);
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";
            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := UQty;
            ItemJnlLine."Invoiced Quantity" := UQty;
            ItemJnlLine."Quantity (Base)" := UQty;
            ItemJnlLine."Invoiced Qty. (Base)" := UQty;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;

            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'TEMP DL';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine."External Document No." := 'UNDO ' + TempDLL."Document No.";
            ItemJnlLine.Insert();
            if TempDLL."Lot No." <> '' then begin


                if ItemS."Item Tracking Code" <> '' then
                    if TempDLL."Lot No." <> '' then begin
                        ItemTacking.Reset();
                        ItemTacking.SetRange("Source ID", 'ITEM');
                        ItemTacking.SetRange("Source Batch Name", 'Z-AUTO');
                        ItemTacking.SetRange("Item No.", ItemS."No.");
                        if ItemTacking.Find('-') then
                            ItemTacking.DeleteAll(true);

                        ItemTacking.RESET;
                        IF (ItemTacking.FINDLAST) THEN
                            ItemEntryNo := ItemTacking."Entry No." + 1;
                        ItemTacking.INIT;
                        ItemTacking."Entry No." := ItemEntryNo;
                        ItemTacking."Item No." := ItemS."No.";
                        ItemTacking."Source ID" := 'ITEM';
                        ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"2";
                        ItemTacking."Source Type" := 83;
                        ItemTacking."Source Batch Name" := 'Z-AUTO';
                        ItemTacking."Source Prod. Order Line" := 0;
                        ItemTacking."Source Ref. No." := 10000;
                        ItemTacking.Positive := false;
                        ItemTacking."Location Code" := ItemS.Location;
                        ItemTacking."Qty. to Handle (Base)" := UQty;
                        ItemTacking."Qty. to Invoice (Base)" := UQty;

                        ItemTacking.Validate("Quantity (Base)", UQty);
                        ItemTacking.Validate(Quantity, UQty);
                        ItemTacking."Lot No." := TempDLL."Lot No.";
                        ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
                        ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                        ItemTacking."Creation Date" := WORKDATE;
                        ItemTacking."Created By" := USERID;
                        ItemTacking."Expected Receipt Date" := TempDLH."Document Date";
                        ItemTacking.INSERT();
                    end;
            end;

            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);
            TempDLL."Cut from Stock" := false;
        end;
    end;

    procedure ProductionRecordPosted_Before(ProRecH: Record "Production Record Header"; ProRecL: Record "Production Record Line"; ItemC: Code[20])
    var
        ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        UQty: Decimal;
        SQty: Decimal;
        PostedStock: Codeunit "Posted Stock";
        ItemSCut: Record Item;
    begin
        UQty := ProRecL.Quantity + ProRecL."NG Qty";
        SQty := UQty;
        if (UQty <= 0) then
            exit;

        ItemS.Reset();
        ItemS.SetRange("No.", ItemC);
        if ItemS.Find('-') then begin
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-AUTO');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);

            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-AUTO';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Posted Assembly";
            ItemJnlLine."Document No." := ProRecH."Req. No.";
            ItemJnlLine."Document Date" := ProRecH."Req. Date";
            ItemJnlLine."Document Line No." := ProRecL."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := ItemS."No.";
            ItemJnlLine."External Document No." := 'Cut from ' + ProRecH."Req. No.";
            ItemJnlLine."Posting Date" := ProRecH."Req. Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := ItemS."No.";
            ItemJnlLine.VALIDATE("Location Code", ItemS.Location);
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";

            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := UQty;
            ItemJnlLine."Invoiced Quantity" := UQty;
            ItemJnlLine."Quantity (Base)" := UQty;
            ItemJnlLine."Invoiced Qty. (Base)" := UQty;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;

            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'BEFORE';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine.Insert();
            if ItemS."Item Tracking Code" <> '' then
                FindLotNo_Nagative(ItemS, SQty, ProRecH."Req. Date", ItemS.Location);
            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);
        end;
    end;

    procedure ProductionRecordPostedReOpen_Before(ProRecH: Record "Production Record Header"; ProRecL: Record "Production Record Line"; ItemC: Code[20])
    var
        ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        UQty: Decimal;
        SQty: Decimal;
        PostedStock: Codeunit "Posted Stock";
        ItemSCut: Record Item;
    begin
        UQty := ProRecL.Quantity + ProRecL."NG Qty";
        SQty := UQty;
        if (UQty <= 0) then
            exit;

        ItemS.Reset();
        ItemS.SetRange("No.", ItemC);
        if ItemS.Find('-') then begin
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-AUTO');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);

            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-AUTO';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Posted Assembly";
            ItemJnlLine."Document No." := ProRecH."Req. No.";
            ItemJnlLine."Document Date" := ProRecH."Req. Date";
            ItemJnlLine."Document Line No." := ProRecL."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := ItemS."No.";
            ItemJnlLine."External Document No." := 'Undo from ' + ProRecH."Req. No.";
            ItemJnlLine."Posting Date" := ProRecH."Req. Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := ItemS."No.";
            ItemJnlLine.VALIDATE("Location Code", ItemS.Location);
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";

            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := UQty;
            ItemJnlLine."Invoiced Quantity" := UQty;
            ItemJnlLine."Quantity (Base)" := UQty;
            ItemJnlLine."Invoiced Qty. (Base)" := UQty;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;

            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'BEFORE';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine.Insert();
            if ItemS."Item Tracking Code" <> '' then
                FindLotNo_Positive(ProRecH."Req. No.", ProRecL."Line No.", ItemS, SQty, ProRecH."Req. Date", ItemS.Location);
            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);
        end;
    end;

    procedure FindLotNo_Nagative(ItemS: Record Item; SQty: Decimal; ShipDate: Date; Loc: Code[20])
    var
        ItemLedger: Record "Item Ledger Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        UQty: Decimal;
    begin


        if ItemS."Item Tracking Code" <> '' then begin

            ItemTacking.Reset();
            ItemTacking.SetRange("Source ID", 'ITEM');
            ItemTacking.SetRange("Source Batch Name", 'Z-AUTO');
            ItemTacking.SetRange("Item No.", ItemS."No.");
            if ItemTacking.Find('-') then
                ItemTacking.DeleteAll(true);

            ItemLedger.Reset();
            ItemLedger.SetCurrentKey("Posting Date", "Lot No.", "Entry No.");
            ItemLedger.SetRange("Item No.", ItemS."No.");
            ItemLedger.SetRange("Location Code", Loc);
            ItemLedger.SetFilter("Remaining Quantity", '>%1', 0);
            if ItemLedger.Find('-') then begin
                repeat
                    UQty := 0;
                    if SQty > 0 then begin
                        if ItemLedger."Remaining Quantity" >= SQty then begin
                            UQty := SQty;
                            SQty := 0;
                        end
                        else begin
                            UQty := ItemLedger."Remaining Quantity";
                            SQty := SQty - ItemLedger."Remaining Quantity";
                        end;

                        ItemTacking.RESET;
                        IF (ItemTacking.FINDLAST) THEN
                            ItemEntryNo := ItemTacking."Entry No." + 1;

                        ItemTacking.INIT;
                        ItemTacking."Entry No." := ItemEntryNo;
                        ItemTacking."Item No." := ItemS."No.";
                        ItemTacking."Source ID" := 'ITEM';
                        ItemTacking."Source Batch Name" := 'Z-AUTO';
                        ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"3";
                        ItemTacking."Source Type" := 83;
                        ItemTacking."Source Prod. Order Line" := 0;
                        ItemTacking."Source Ref. No." := 10000;
                        ItemTacking.Positive := false;
                        ItemTacking."Location Code" := Loc;
                        ItemTacking."Qty. to Handle (Base)" := UQty * -1;
                        ItemTacking."Qty. to Invoice (Base)" := UQty * -1;
                        ItemTacking.Validate(Quantity, UQty * -1);
                        ItemTacking.Validate("Quantity (Base)", UQty * -1);
                        ItemTacking."Lot No." := ItemLedger."Lot No.";
                        ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
                        ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                        ItemTacking."Creation Date" := WORKDATE;
                        ItemTacking."Created By" := USERID;
                        ItemTacking."Shipment Date" := ShipDate;
                        ItemTacking.INSERT();
                        //Calculate//
                    end;
                until ItemLedger.Next = 0;
            end;
        end;
    end;

    procedure FindLotNo_Positive(DocNo: Code[20]; Line: Integer; ItemS: Record Item; SQty: Decimal; ReceiptD: Date; Loc: Code[20])
    var
        ItemLedger: Record "Item Ledger Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        UQty: Decimal;
    begin


        if ItemS."Item Tracking Code" <> '' then begin

            ItemTacking.Reset();
            ItemTacking.SetRange("Source ID", 'ITEM');
            ItemTacking.SetRange("Source Batch Name", 'Z-AUTO');
            ItemTacking.SetRange("Item No.", ItemS."No.");
            if ItemTacking.Find('-') then
                ItemTacking.DeleteAll(true);

            ItemLedger.Reset();
            ItemLedger.SetRange("Item No.", ItemS."No.");
            ItemLedger.SetRange("Location Code", Loc);
            ItemLedger.SetRange("Document No.", DocNo);
            ItemLedger.SetRange("Document Line No.", Line);
            if ItemLedger.Find('-') then begin
                repeat
                    UQty := abs(ItemLedger.Quantity);
                    ItemTacking.RESET;
                    IF (ItemTacking.FINDLAST) THEN
                        ItemEntryNo := ItemTacking."Entry No." + 1;

                    ItemTacking.INIT;
                    ItemTacking."Entry No." := ItemEntryNo;
                    ItemTacking."Item No." := ItemS."No.";
                    ItemTacking."Source ID" := 'ITEM';
                    ItemTacking."Source Batch Name" := 'Z-AUTO';
                    ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"2";
                    ItemTacking."Source Type" := 83;
                    ItemTacking."Source Prod. Order Line" := 0;
                    ItemTacking."Source Ref. No." := 10000;
                    ItemTacking.Positive := true;
                    ItemTacking."Location Code" := Loc;
                    ItemTacking."Qty. to Handle (Base)" := UQty;
                    ItemTacking."Qty. to Invoice (Base)" := UQty;
                    ItemTacking.Validate(Quantity, UQty);
                    ItemTacking.Validate("Quantity (Base)", UQty);
                    ItemTacking."Lot No." := ItemLedger."Lot No.";
                    ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
                    ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                    ItemTacking."Creation Date" := WORKDATE;
                    ItemTacking."Created By" := USERID;
                    ItemTacking."Expiration Date" := ReceiptD;
                    ItemTacking.INSERT();
                //Calculate//
                until ItemLedger.Next = 0;
            end;
        end;
    end;




    procedure ProductionRecordPosted_Onprocess(ProRecH: Record "Production Record Header"; ProRecL: Record "Production Record Line"; ItemC: Code[20]; Loc: Code[20])
    var
        ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        UQty: Decimal;
        SQty: Decimal;
        PostedStock: Codeunit "Posted Stock";
        ItemSCut: Record Item;
    begin
        UQty := ProRecL.Quantity + ProRecL."NG Qty";
        SQty := UQty;
        if (UQty <= 0) then
            exit;

        ItemS.Reset();
        ItemS.SetRange("No.", ItemC);
        if ItemS.Find('-') then begin
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-AUTO');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);

            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-AUTO';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Direct Transfer";
            ItemJnlLine."Document No." := ProRecH."Req. No.";
            ItemJnlLine."Document Date" := ProRecH."Req. Date";
            ItemJnlLine."Document Line No." := ProRecL."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := ItemS."No.";
            ItemJnlLine."External Document No." := 'Cut from ' + ProRecH."Req. No.";
            ItemJnlLine."Posting Date" := ProRecH."Req. Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := ItemS."No.";
            ItemJnlLine.VALIDATE("Location Code", Loc);
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";

            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := UQty;
            ItemJnlLine."Invoiced Quantity" := UQty;
            ItemJnlLine."Quantity (Base)" := UQty;
            ItemJnlLine."Invoiced Qty. (Base)" := UQty;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;

            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'ONPROCESS';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine.Insert();
            if ItemS."Item Tracking Code" <> '' then
                FindLotNo_Nagative(ItemS, SQty, ProRecH."Req. Date", 'PROCESS');
            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);
        end;
    end;

    procedure ProductionRecordPostedReOpen_Onprocess(ProRecH: Record "Production Record Header"; ProRecL: Record "Production Record Line"; ItemC: Code[20])
    var
        ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        UQty: Decimal;
        SQty: Decimal;
        PostedStock: Codeunit "Posted Stock";
        ItemSCut: Record Item;
    begin
        UQty := ProRecL.Quantity + ProRecL."NG Qty";
        SQty := UQty;
        if (UQty <= 0) then
            exit;

        ItemS.Reset();
        ItemS.SetRange("No.", ItemC);
        if ItemS.Find('-') then begin
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-AUTO');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);

            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-AUTO';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Direct Transfer";
            ItemJnlLine."Document No." := ProRecH."Req. No.";
            ItemJnlLine."Document Date" := ProRecH."Req. Date";
            ItemJnlLine."Document Line No." := ProRecL."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := ItemS."No.";
            ItemJnlLine."External Document No." := 'Undo from ' + ProRecH."Req. No.";
            ItemJnlLine."Posting Date" := ProRecH."Req. Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := ItemS."No.";
            ItemJnlLine.VALIDATE("Location Code", 'PROCESS');
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";

            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := UQty;
            ItemJnlLine."Invoiced Quantity" := UQty;
            ItemJnlLine."Quantity (Base)" := UQty;
            ItemJnlLine."Invoiced Qty. (Base)" := UQty;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;

            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'ONPROCESS';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine.Insert();
            if ItemS."Item Tracking Code" <> '' then
                FindLotNo_Positive(ProRecH."Req. No.", ProRecL."Line No.", ItemS, SQty, ProRecH."Req. Date", 'PROCESS');
            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);
        end;
    end;

    procedure PostedStockToBefore_OnProcess(ProRecH: Record "Material Delivery Header"; ProRecL: Record "Material Delivery Line"; ItemC: Code[20])
    var
        ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        UQty: Decimal;
        SQty: Decimal;
        PostedStock: Codeunit "Posted Stock";
        ItemSCut: Record Item;
    begin
        UQty := ProRecL.Quantity;
        SQty := UQty;
        if (UQty <= 0) then
            exit;

        ItemS.Reset();
        ItemS.SetRange("No.", ItemC);
        if ItemS.Find('-') then begin
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-AUTO');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);

            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-AUTO';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Inventory Shipment";
            ItemJnlLine."Document No." := ProRecH."Req. No.";
            ItemJnlLine."Document Date" := ProRecH."Req. Date";
            ItemJnlLine."Document Line No." := ProRecL."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := ItemS."No.";
            ItemJnlLine."External Document No." := ProRecH."Req. No.";
            ItemJnlLine."Posting Date" := ProRecH."Req. Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := ItemS."No.";
            ItemJnlLine.VALIDATE("Location Code", ItemS.Location);
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";

            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := UQty;
            ItemJnlLine."Invoiced Quantity" := UQty;
            ItemJnlLine."Quantity (Base)" := UQty;
            ItemJnlLine."Invoiced Qty. (Base)" := UQty;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;

            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'PROCESS';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine.Insert();
            if ItemS."Item Tracking Code" <> '' then
                FindLotNo_Nagative(ItemS, SQty, ProRecH."Req. Date", ItemS.Location);
            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);
        end;
    end;

    procedure PostedStockToOnProcessApprov(Docu: Code[20])
    var
        DLMH: Record "Material Delivery Header";
        DLML: Record "Material Delivery Line";
        InvtL: Record "Invt. Document Line";
        ItemLedger: Record "Item Ledger Entry";
        ItemS: Record Item;
        ItemNext: Record Item;
    begin

        DLMH.Reset();
        DLMH.SetRange("Req. No.", Docu);
        DLMH.SetRange("From Washing", true);
        if DLMH.Find('-') then begin
            DLML.Reset();
            DLML.SetRange("Document No.", DLMH."Req. No.");
            if DLML.Find('-') then begin
                repeat
                    ItemS.Reset();
                    ItemS.SetRange("No.", DLML."Part No.");
                    if ItemS.Find('-') then;

                    ItemNext.Reset();
                    ItemNext.SetRange("No.", ItemS."To Material Item");
                    if ItemNext.Find('-') then;

                    ItemLedger.Reset();
                    ItemLedger.SetRange("Item No.", DLML."Part No.");
                    ItemLedger.SetRange("Document No.", DLML."Document No.");
                    ItemLedger.SetRange("Document Line No.", DLML."Line No.");
                    //ItemLedger.SetRange("Lot No.", DLML."Lot No.");
                    ItemLedger.SetRange("Location Code", ItemS.Location);
                    ItemLedger.SetFilter("Return Reason Code", '%1', 'PROCESS');
                    ItemLedger.SetFilter(Quantity, '<%1', 0);
                    if ItemLedger.Find('-') then begin
                        repeat
                            //Move To New Part for Process//
                            DeliveryMaterialToOnprocess(ItemLedger, ItemNext."No.", 'PROCESS', DLML);
                        until ItemLedger.Next = 0;
                    end;
                until DLML.Next = 0;
            end;

        end;
    end;

    procedure PostedStockToOnProcess(Docu: Code[20])
    var
        DLMH: Record "Material Delivery Header";
        DLML: Record "Material Delivery Line";
        InvtL: Record "Invt. Document Line";
        ItemLedger: Record "Item Ledger Entry";
        ItemS: Record Item;
        ItemNext: Record Item;
    begin

        DLMH.Reset();
        DLMH.SetRange("Req. No.", Docu);
        DLMH.SetRange("From Washing", true);
        if DLMH.Find('-') then begin
            DLML.Reset();
            DLML.SetRange("Document No.", DLMH."Req. No.");
            if DLML.Find('-') then begin
                repeat
                    ItemS.Reset();
                    ItemS.SetRange("No.", DLML."Part No.");
                    if ItemS.Find('-') then;

                    ItemNext.Reset();
                    ItemNext.SetRange("No.", ItemS."To Material Item");
                    if ItemNext.Find('-') then;

                    ItemLedger.Reset();
                    ItemLedger.SetRange("Item No.", DLML."Part No.");
                    ItemLedger.SetRange("External Document No.", DLML."Document No.");
                    // ItemLedger.SetRange("Lot No.", DLML."Lot No.");
                    ItemLedger.SetRange("Location Code", ItemS.Location);
                    ItemLedger.SetFilter("Return Reason Code", '%1', 'PROCESS');
                    ItemLedger.SetFilter(Quantity, '<%1', 0);
                    if ItemLedger.Find('-') then begin
                        repeat
                            //Move To New Part for Process//
                            DeliveryMaterialToOnprocess(ItemLedger, ItemNext."No.", 'PROCESS', DLML);
                        until ItemLedger.Next = 0;
                    end;
                until DLML.Next = 0;
            end;

        end;
    end;

    procedure DeliveryMaterialToOnprocess(ItemLed: Record "Item Ledger Entry"; ItemC: Code[20]; Loc: Code[20]; DML: Record "Material Delivery Line")
    var
        //  ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        UQty: Decimal;
        SQty: Decimal;
        PostedStock: Codeunit "Posted Stock";
        ItemSCut: Record Item;
    begin
        UQty := abs(ItemLed.Quantity);
        SQty := UQty;
        if (UQty <= 0) then
            exit;

        ItemS.Reset();
        ItemS.SetRange("No.", ItemC);
        if ItemS.Find('-') then begin
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-AUTO');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);

            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-AUTO';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Direct Transfer";
            ItemJnlLine."Document No." := DML."Document No.";
            ItemJnlLine."Document Date" := ItemLed."Posting Date";
            ItemJnlLine."Document Line No." := DML."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := ItemS."No.";
            ItemJnlLine."External Document No." := 'Move from ' + ItemLed."Document No.";
            ItemJnlLine."Posting Date" := ItemLed."Posting Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := ItemS."No.";
            ItemJnlLine.VALIDATE("Location Code", 'PROCESS');
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";

            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := UQty;
            ItemJnlLine."Invoiced Quantity" := UQty;
            ItemJnlLine."Quantity (Base)" := UQty;
            ItemJnlLine."Invoiced Qty. (Base)" := UQty;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;

            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'ONPROCESS';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine.Insert();
            if ItemS."Item Tracking Code" <> '' then begin
                ItemTacking.Reset();
                ItemTacking.SetRange("Source ID", 'ITEM');
                ItemTacking.SetRange("Source Batch Name", 'Z-AUTO');
                ItemTacking.SetRange("Item No.", ItemS."No.");
                if ItemTacking.Find('-') then
                    ItemTacking.DeleteAll(true);

                UQty := abs(ItemLed.Quantity);
                ItemTacking.RESET;
                IF (ItemTacking.FINDLAST) THEN
                    ItemEntryNo := ItemTacking."Entry No." + 1;

                ItemTacking.INIT;
                ItemTacking."Entry No." := ItemEntryNo;
                ItemTacking."Item No." := ItemS."No.";
                ItemTacking."Source ID" := 'ITEM';
                ItemTacking."Source Batch Name" := 'Z-AUTO';
                ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"2";
                ItemTacking."Source Type" := 83;
                ItemTacking."Source Prod. Order Line" := 0;
                ItemTacking."Source Ref. No." := 10000;
                ItemTacking.Positive := true;
                ItemTacking."Location Code" := Loc;
                ItemTacking."Qty. to Handle (Base)" := UQty;
                ItemTacking."Qty. to Invoice (Base)" := UQty;
                ItemTacking.Validate(Quantity, UQty);
                ItemTacking.Validate("Quantity (Base)", UQty);
                ItemTacking."Lot No." := ItemLed."Lot No.";
                ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
                ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                ItemTacking."Creation Date" := WORKDATE;
                ItemTacking."Created By" := USERID;
                ItemTacking."Expiration Date" := ItemLed."Posting Date";
                ItemTacking.INSERT();
            end;
            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);
        end;
    end;

    procedure TempDLReceipt(TempRL: Record "Temp. Receipt Line"; TempRH: Record "Temp. Receipt Header"; Qty: Decimal; Loc: Code[20])
    var
        //  ItemLedger: Record "Item Ledger Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemS: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntryNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        OldReservEntry: Record "Reservation Entry";
        ItemTacking: Record "Reservation Entry";
        ItemEntryNo: Integer;
        UQty: Decimal;
        SQty: Decimal;
        PostedStock: Codeunit "Posted Stock";
        ItemSCut: Record Item;
    begin
        UQty := Qty;
        SQty := UQty;
        if (UQty <= 0) then
            exit;



        ItemS.Reset();
        ItemS.SetRange("No.", TempRL."Part No.");
        if ItemS.Find('-') then begin
            if Loc = '' then
                Loc := ItemS.Location;
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Batch Name", 'Z-AUTO');
            ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
            if ItemJnlLine.Find('-') then
                ItemJnlLine.DeleteAll(true);

            ItemJnlLine.INIT;
            ItemJnlLine."Journal Batch Name" := 'Z-AUTO';
            ItemJnlLine."Journal Template Name" := 'ITEM';
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
            ItemJnlLine."Source Code" := 'ITEMJNL';// SourceCodeSetup.Assembly;
            ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Transfer Receipt";
            ItemJnlLine."Document No." := TempRL."Document No.";
            ItemJnlLine."Document Date" := TempRH."Receipt Date";
            ItemJnlLine."Document Line No." := TempRL."Line No.";
            ItemJnlLine."Order No." := '';//ProRecL."Document No.";
            ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::" ";
            ItemJnlLine."Dimension Set ID" := 0;//ProRecH."Dimension Set ID";
            ItemJnlLine."Shortcut Dimension 1 Code" := '';// "Shortcut Dimension 1 Code";
            ItemJnlLine."Shortcut Dimension 2 Code" := '';// "Shortcut Dimension 2 Code";
            ItemJnlLine."Order Line No." := 0;
            ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
            ItemJnlLine."Source No." := ItemS."No.";
            ItemJnlLine."External Document No." := TempRH."Ref. No.";
            ItemJnlLine."Posting Date" := TempRH."Receipt Date";
            ItemJnlLine."Posting No. Series" := '';
            ItemJnlLine.Type := ItemJnlLine.Type::" ";
            ItemJnlLine."Item No." := ItemS."No.";
            ItemJnlLine.VALIDATE("Location Code", Loc);
            ItemJnlLine."Gen. Prod. Posting Group" := ItemS."Gen. Prod. Posting Group";
            ItemJnlLine."Inventory Posting Group" := ItemS."Inventory Posting Group";

            ItemJnlLine."Unit of Measure Code" := ItemS."Base Unit of Measure";
            ItemJnlLine."Qty. per Unit of Measure" := 1;// ItemS."Qty. per Unit of Measure";
            ItemJnlLine.Quantity := UQty;
            ItemJnlLine."Invoiced Quantity" := UQty;
            ItemJnlLine."Quantity (Base)" := UQty;
            ItemJnlLine."Invoiced Qty. (Base)" := UQty;
            ItemJnlLine."Variant Code" := '';
            ItemJnlLine.Description := ItemS.Description;

            ItemJnlLine."Bin Code" := '';
            ItemJnlLine."Indirect Cost %" := 0;// "Indirect Cost %";
            ItemJnlLine."Overhead Rate" := 0;//"Overhead Rate";
            ItemJnlLine."Unit Cost" := 0;//"Unit Cost";
            ItemJnlLine.VALIDATE("Unit Amount", 0);
            ItemJnlLine.Correction := false;
            ItemJnlLine."Item Category Code" := ItemS."Item Category Code";
            ItemJnlLine."Return Reason Code" := 'TEMPRC';
            ItemJnlLine."Line No." := 10000;
            ItemJnlLine.Insert();
            if ItemS."Item Tracking Code" <> '' then begin
                ItemTacking.Reset();
                ItemTacking.SetRange("Source ID", 'ITEM');
                ItemTacking.SetRange("Source Batch Name", 'Z-AUTO');
                ItemTacking.SetRange("Item No.", ItemS."No.");
                if ItemTacking.Find('-') then
                    ItemTacking.DeleteAll(true);


                ItemTacking.RESET;
                IF (ItemTacking.FINDLAST) THEN
                    ItemEntryNo := ItemTacking."Entry No." + 1;

                ItemTacking.INIT;
                ItemTacking."Entry No." := ItemEntryNo;
                ItemTacking."Item No." := ItemS."No.";
                ItemTacking."Source ID" := 'ITEM';
                ItemTacking."Source Batch Name" := 'Z-AUTO';
                ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"2";
                ItemTacking."Source Type" := 83;
                ItemTacking."Source Prod. Order Line" := 0;
                ItemTacking."Source Ref. No." := 10000;
                ItemTacking.Positive := true;
                ItemTacking."Location Code" := Loc;
                ItemTacking."Qty. to Handle (Base)" := UQty;
                ItemTacking."Qty. to Invoice (Base)" := UQty;
                ItemTacking.Validate(Quantity, UQty);
                ItemTacking.Validate("Quantity (Base)", UQty);
                ItemTacking."Lot No." := TempRL."Lot No.";
                ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
                ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
                ItemTacking."Creation Date" := WORKDATE;
                ItemTacking."Created By" := USERID;
                ItemTacking."Expiration Date" := TempRH."Receipt Date";
                ItemTacking.INSERT();
            end;
            PostItemJnlLine(ItemJnlLine, ItemJnlPostLine);
        end;
    end;


}