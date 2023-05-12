pageextension 50020 "Purchase Quote Card Ex" extends "Purchase Quote"
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
        modify("Vendor Order No.") { Visible = false; }
        modify("Vendor Shipment No.") { Visible = false; }
        modify("Shortcut Dimension 1 Code") { Visible = true; ApplicationArea = all; Importance = Promoted; }
        modify("Shortcut Dimension 2 Code") { Visible = true; ApplicationArea = all; Importance = Promoted; CaptionML = ENA = 'Req. By'; }
        moveafter("Document Date"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")
        modify("Purchaser Code") { Importance = Promoted; Visible = false; }
        movebefore("Shortcut Dimension 1 Code"; "Purchaser Code")
        addafter(Status)
        {
            field("BOI Code"; "BOI Code")
            {
                ApplicationArea = all;
                Importance = Promoted;
            }
        }
        modify("Order Date")
        {
            Visible = false;
            trigger OnAfterValidate()
            begin

            end;
        }
        modify("Document Date") { Visible = true; }

        addbefore(PurchLines)
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
                            Addkanban(Scaner);
                            Rec.Validate("Invoice Discount Amount", 0);
                            /////////////////////
                        end;
                        Scaner := '';
                        CurrPage.SetFieldFocus.SetFocusOnField('Scaner');

                    end;
                }
            }
        }

    }
    actions
    {
        modify(Print)
        {
            Visible = false;
        }
        addafter(Print)
        {
            action(Print2)
            {
                ApplicationArea = Suite;
                Caption = '&Print PR';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category6;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    ReportPO: Report "Purchase Request";
                begin
                    CurrPage.Update(true);
                    Clear(PurchaseHeader);
                    PurchaseHeader := Rec;
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    ReportPO.SetTableView(PurchaseHeader);
                    ReportPO.RunModal();
                end;
            }
        }
        addafter(CopyDocument)
        {
            action(ReOrder)
            {
                ApplicationArea = Suite;
                Caption = 'Item-ReOrder';
                Ellipsis = true;
                Enabled = "No." <> '';
                Image = CopyDocument;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ItemRe: Page "Item Re-Ordering";
                    PRCopy: Page "PR Copy Line";
                begin
                    ItemRe.Setdoc(Rec."No.");
                    ItemRe.RunModal();
                    // PRCopy.Setdoc(Rec."No.");
                    // PRCopy.RunModal();
                end;
            }
        }
    }
    var
        utility: Codeunit Utility;

    procedure Addkanban(ScanID: Code[100])
    var
        KanTB: Record "Kanban List";
        PRLine: Record "Purchase Line";
        PRLine2: Record "Purchase Line";
        PRHD: Record "Purchase Header";
        rows1: Integer;
        ItemS: Record Item;
    begin
        if (ScanID = '') then
            exit;
        CheckKanban(ScanID);

        rows1 := 0;
        KanTB.Reset();
        KanTB.SetRange(Status, KanTB.Status::Active);
        KanTB.SetRange("Master No.", ScanID);
        if KanTB.Find('-') then begin
            ItemS.Get(KanTB."Part No.");
            // KanTB.CalcFields("Vendor No.");
            KanTB.CalcFields(Vendor);
            PRLine2.Reset();
            PRLine2.SetRange("Document No.", Rec."No.");
            PRLine2.SetRange("Document Type", PRLine2."Document Type"::Quote);
            if PRLine2.FindLast() then
                rows1 := PRLine2."Line No.";
            rows1 := rows1 + 10000;
            PRLine.Init;
            PRLine."Document No." := Rec."No.";
            PRLine."Line No." := rows1;
            PRLine."Document Type" := PRLine."Document Type"::Quote;
            PRLine.Type := PRLine.Type::Item;
            PRLine.Validate("No.", KanTB."Part No.");
            PRLine.Validate("Unit of Measure Code", ItemS."Base Unit of Measure");
            PRLine.Validate(Quantity, KanTB.Qty);
            PRLine.Validate("Location Code", KanTB.Location);
            PRLine.Validate("Direct Unit Cost", ItemS."Unit Cost");
            // PRLine."Expected Receipt Date" := PRLine."Expected Receipt Date";
            // PRLine."Quote Line" := PRLine."Line No.";
            // PRLine."Quote No." := PRLine."Document No.";
            PRLine.Description := ItemS.Description;
            PRLine."Description 2" := ItemS."Description 2";
            PRLine."Ref Quote No." := ItemS."Ref. Quotation";
            PRLine."Supplier Name" := KanTB.Vendor;
            PRLine.Maker := ItemS.Maker;
            PRLine.LeadTime := ItemS."Lead Time";
            PRLine."PO Status" := PRLine."PO Status"::Open;
            PRLine."Create Date" := CurrentDateTime;
            PRLine."Create By" := utility.UserFullName(UserId);
            PRLine.Classification := PRLine.Classification;
            PRLine."Kanban No." := KanTB."Master No.";
            PRLine.Insert(true);
            // CurrPage.Update(true);
        end;

    end;

    procedure CheckKanban(CodeK: Code[20])
    var
        PRLine: Record "Purchase Line";
        QQ: Integer;
    begin
        QQ := 0;
        PRLine.Reset();
        //PRLine.CalcFields(RMQty);
        PRLine.SetRange("Kanban No.", CodeK);
        // PRLine.SetFilter(RMQty, '>%1', 0);
        //PRLine.SetFilter("PO No.", '<>%1', '');
        if PRLine.Find('-') then begin
            repeat
                PRLine.CalcFields("PO No.");
                PRLine.CalcFields(RMQty);
                if (PRLine."PO No." <> '') and (PRLine.RMQty > 0) then
                    QQ += PRLine.RMQty;
                if PRLine."PO No." = '' then
                    QQ += PRLine.Quantity;
            until PRLine.Next = 0;

            //  
            if QQ > 0 then begin
                Error('The Kanban has not yet been received.!');
                exit;
            end;
            //
        end;

    end;
}