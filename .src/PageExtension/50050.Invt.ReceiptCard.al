pageextension 50050 "Invt.ReceiptCard Ex" extends "Invt. Receipt"
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
            Caption = 'Receipt No.';
            trigger OnAfterValidate()
            begin
                "Gen. Bus. Posting Group" := 'DOMESTIC';
                "Posting Description" := '';
                "Create Date" := CurrentDateTime;
                "Create By" := utility.UserFullName(UserId);
                Validate("Location Code", 'WHS');
            end;
        }
        modify("Posting Date")
        {
            Visible = true;
            CaptionClass = 'Receipt Date';
        }
        modify("Document Date")
        {
            CaptionClass = 'Plan Receipt Date';

        }
        modify("Posting Description")
        {
            Visible = true;
            CaptionClass = 'Remark';
        }
        modify("External Document No.")
        {
            CaptionClass = 'Ref. Document No';
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        addafter(Status)
        {
            field("Create By"; "Create By")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Create Date"; "Create Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addbefore(ReceiptLines)
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
        modify("P&ost")
        {
            Visible = false;
        }
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
                //RunObject = Codeunit "Invt. Doc.-Post (Yes/No)";
                ShortCutKey = 'F9';
                ToolTip = 'Record the related transaction in your books.';
                trigger OnAction()
                var
                    ConfirmPostQst: Label 'Do you want to post Inventory Document?';
                    InvtDocPostReceipt: Codeunit "Invt. Doc.-Post Receipt XTH";
                begin
                    if not Confirm(ConfirmPostQst, false) then
                        exit;
                    InvtDocPostReceipt.Run(Rec);
                end;

            }
        }
        addafter(CopyDocument)
        {
            action(getMDL)
            {
                Caption = 'Get Transfer Order';
                ApplicationArea = all;
                Image = List;
                trigger OnAction()
                var
                    MaterialH: Record "Transfer Production Header";
                    getMDLPage: Page "Transfer Production List";
                    InvtL: Record "Invt. Document Line";
                begin
                    // utility.InvtDocumentUpdateRec();
                    if Rec."Location Code" = '' then
                        Error('Location Code Empty!');

                    InvtL.Reset();
                    InvtL.SetRange("Document No.", Rec."No.");
                    if NOT InvtL.Find('-') then begin
                        MaterialH.Reset();
                        // MaterialH.SetRange(Status, MaterialH.Status::Open);
                        MaterialH.SetAutoCalcFields("Receipt No.");
                        MaterialH.SetFilter("Receipt No.", '%1', '');
                        if MaterialH.Find('-') then begin
                            getMDLPage.SetTableView(MaterialH);
                            getMDLPage.Editable := false;
                            getMDLPage.setDoc(Rec."No.");
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
            InvtL."Document Type" := InvtL."Document Type"::Receipt;
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
        ItemTacking.Positive := true;
        ItemTacking."Location Code" := InvtL."Location Code";
        ItemTacking."Quantity (Base)" := QtyS;
        ItemTacking.Quantity := QtyS;
        ItemTacking."Qty. to Handle (Base)" := QtyS;
        ItemTacking."Qty. to Invoice (Base)" := QtyS;
        ItemTacking."Lot No." := LotNo;
        //ItemTacking."New Lot No." := QueryReclass.LotNo;
        ItemTacking."Source Subtype" := ItemTacking."Source Subtype"::"0";
        ItemTacking."Reservation Status" := Enum::"Reservation Status".FromInteger(3);
        ItemTacking."Item Tracking" := ItemTacking."Item Tracking"::"Lot No.";
        ItemTacking."Creation Date" := WORKDATE;
        ItemTacking."Created By" := USERID;
        ItemTacking."Expected Receipt Date" := InvtL."Document Date";
        ItemTacking.INSERT;
    end;

    procedure getInsertMDL(var MDLH: Record "Transfer Production Header"; DocNo: Code[20])
    var
        InvtH: Record "Invt. Document Header";
        InvtL: Record "Invt. Document Line";
        MDH: Record "Transfer Production Header";
        MDL: Record "Transfer Production Line";
        RowS: Integer;
        ItemS: Record Item;
    begin
        RowS := 10000;
        InvtH.Reset();
        InvtH.SetRange("No.", DocNo);
        InvtH.SetRange("Document Type", InvtH."Document Type"::Receipt);
        if InvtH.Find('-') then begin

            MDL.Reset();
            MDL.SetRange("Document No.", MDLH."Req. No.");
            if MDL.Find('-') then begin
                repeat
                    ItemS.Reset();
                    ItemS.SetRange("No.", MDL."Part No.");
                    if ItemS.Find('-') then;
                    InvtL.Init();
                    InvtL."Document No." := InvtH."No.";
                    InvtL."Line No." := RowS;
                    InvtL."Document Type" := InvtL."Document Type"::Receipt;
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
                    InvtL."Reason Code" := 'PRODUCTION';
                    InvtL."MDLH Line No." := MDL."Line No.";
                    InvtL."MDLH No." := MDL."Document No.";
                    if InvtL."Qty. per Unit of Measure" = 0 then
                        InvtL."Qty. per Unit of Measure" := 1;
                    InvtL.Insert();

                    InsertAutoLot(InvtL, MDL.Quantity, MDL."Lot No.");
                    RowS := RowS + 10000;

                until MDL.Next = 0;
                MDLH."Receipt No." := InvtH."No.";
                MDLH.Status := MDLH.Status::Completed;
                MDLH.Modify(false);
                InvtH."External Document No." := MDLH."Req. No.";
                InvtH."Ref.Doc" := MDLH."Req. No.";
                InvtH.Modify(false);
            end;
        end;
    end;


}