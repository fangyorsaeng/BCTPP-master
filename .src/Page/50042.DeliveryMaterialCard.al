page 50042 "Delivery Material Card"
{
    PageType = Document;
    SourceTable = "Material Delivery Header";

    layout
    {
        area(Content)
        {
            usercontrol(SetFieldFocus; SetFieldFocus)
            {
                ApplicationArea = All;
                trigger Ready()
                begin
                    CurrPage.SetFieldFocus.SetFocusOnField('No.');
                end;
            }
            group(General)
            {
                field("Req. No."; "Req. No.")
                {
                    ApplicationArea = all;
                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(Rec) then
                            CurrPage.Update;
                    end;
                }
                field("Req. Date"; "Req. Date") { ApplicationArea = all; }
                field("Req. By"; "Req. By") { ApplicationArea = all; }
                field("Ref. Document"; "Ref. Document") { ApplicationArea = all; }
                field(Remark; Remark) { ApplicationArea = all; }
                field(Process; Process) { ApplicationArea = all; Caption = 'Line Name'; }
                field("From Washing"; "From Washing") { ApplicationArea = ALL; }
                field(Status; Status) { ApplicationArea = all; Editable = false; }
                field("Create By"; "Create By") { ApplicationArea = all; Editable = false; }
                field("Create Date"; "Create Date") { ApplicationArea = all; Editable = false; }
                field("Shipment No."; "Shipment No.") { ApplicationArea = all; Editable = false; }

            }
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

            part(Line; "Delivery Material Subform")
            {
                Editable = Status = Status::Open;
                Caption = 'Line';
                ApplicationArea = all;
                SubPageView = sorting("Document No.", "Line No.")
                              order(ascending);
                SubPageLink = "Document No." = field("Req. No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Print1)
            {
                ApplicationArea = all;
                Image = Print;
                Caption = 'Print Voucher';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ReportMDL: Report "Material Delivery";
                    DeliveryMT: Record "Material Delivery Header";
                begin
                    CheckBeforePrint(Rec."Req. No.");
                    Clear(ReportMDL);
                    CurrPage.SetSelectionFilter(DeliveryMT);
                    ReportMDL.SetTableView(DeliveryMT);
                    ReportMDL.Run();

                end;
            }
            action(Reopen)
            {
                ApplicationArea = all;
                Caption = 'ReOpen';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    if Confirm('Do you want Re-Open Document?') then
                        Rec.Status := Rec.Status::Open;
                    CurrPage.Update();
                end;

            }
            action(FixAc)
            {
                Caption = 'Fix Doc.';
                Image = Calculate;
                ApplicationArea = all;
                Visible = false;
                trigger OnAction()
                var
                    PostedStock: Codeunit "Posted Stock";
                begin
                    PostedStock.PostedStockToOnProcess(Rec."Req. No.");
                    Message('Completed.');
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        // Message("Req. No.");
    end;

    trigger OnAfterGetRecord()
    begin
        CalcFields("Shipment No.");
    end;

    var
        utility: Codeunit Utility;
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;


    procedure AssistEdit(var TempOrder: Record "Material Delivery Header"): Boolean
    var
        PurSetup: Record "Purchases & Payables Setup";
        NewCode: Code[20];
    begin
        //  GetPurchSetup();
        SalesSetup.Get();
        SalesSetup.TestField("Material DLNo.");
        if (TempOrder."Req. No." = '') and (SalesSetup."Material DLNo." <> '') then begin
            if NoSeriesMgt.SelectSeries(SalesSetup."Material DLNo.", '', NewCode) then begin
                // TestNoSeries();
                // NoSeriesMgt.SetSeries("No.");
                if NewCode <> '' then
                    TempOrder."Req. No." := NoSeriesMgt.GetNextNo(NewCode, Today, true);
                TempOrder.Status := TempOrder.Status::Open;
                TempOrder."Create By" := utility.UserFullName(UserId);
                TempOrder."Create Date" := CurrentDateTime;
                TempOrder."Req. Date" := WorkDate();
                exit(true);
            end;
        end;

    end;

    procedure AddItemOrKanban(Scaner: Code[100]; ScanItem: Text[20])
    var
        KanbanL: Record "Kanban List";
        ItemS: Record Item;
        PartNo: Code[20];
        InvtL: Record "Material Delivery Line";
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
            InvtL.SetRange("Document No.", Rec."Req. No.");
            if InvtL.FindLast() then
                RowNo := InvtL."Line No.";
            RowNo := RowNo + 1;

            InvtL.Reset();
            InvtL.Init();
            InvtL."Document No." := Rec."Req. No.";
            InvtL."Line No." := RowNo;
            InvtL."Part No." := PartNo;
            InvtL."Part Name" := ItemS.Description;
            InvtL.Validate(Quantity, QtyK);
            InvtL.Validate("Ref. Process", Rec.Process);
            InvtL.Insert();

        end;

    end;

    procedure CheckBeforePrint(DocNo: Code[20])
    var
        DMDL: Record "Material Delivery Line";
        DMDH: Record "Material Delivery Header";
        ItemS: Record Item;
        CKA: Integer;
    begin
        CKA := 0;
        if NOT Rec."From Washing" then begin
            DMDL.Reset();
            DMDL.SetRange("Document No.", DocNo);
            if DMDL.Find('-') then begin
                repeat
                    ItemS.Reset();
                    ItemS.SetRange("No.", DMDL."Part No.");
                    if ItemS.Find('-') then begin
                        if ItemS."For Washing" then begin
                            CKA += 1;
                            if ItemS."To Material Item" = '' then begin
                                Error('Item Card to Material Item is Empty!');
                            end;
                        end;

                    end;
                until DMDL.Next = 0;
            end;
            if (CKA > 0) then
                Error('Please.. Check From Washing');

        end;
    end;
}