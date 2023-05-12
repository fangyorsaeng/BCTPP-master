pageextension 50010 "Purchase Order Ext" extends "Purchase Order"
{
    layout
    {
        modify("Shortcut Dimension 1 Code") { Visible = true; ApplicationArea = all; Importance = Promoted; }
        modify("Shortcut Dimension 2 Code") { Visible = true; ApplicationArea = all; Importance = Promoted; }
        moveafter("Document Date"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")
        addafter(Status)
        {
            field("BOI Code"; "BOI Code")
            {
                ApplicationArea = all;
                Importance = Promoted;
            }
            field("Cancel Date"; "Cancel Date")
            {
                ApplicationArea = all;
                Importance = Promoted;
            }
            field("Cancel Reason"; "Cancel Reason") { ApplicationArea = all; Importance = Promoted; }
            field(Rev; Rev)
            {
                ApplicationArea = all;
            }
        }
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("Payment Method Code")
        {
            Visible = true;
            Importance = Promoted;
        }
        addafter("Shipment Method Code")
        {
            field("FOB Point"; "FOB Point") { ApplicationArea = all; Importance = Promoted; }
        }
        modify("Quote No.")
        {
            Importance = Promoted;
            Editable = true;
            Visible = false;
        }
        modify("Purchaser Code") { Importance = Promoted; Visible = true; }
        movebefore("Shortcut Dimension 1 Code"; "Purchaser Code")
        modify("Vendor Invoice No.") { Visible = false; }
        modify("Vendor Shipment No.") { Visible = false; }



    }
    actions
    {
        addafter("&Print")
        {
            action("&Print2")
            {
                ApplicationArea = Suite;
                Caption = '&Purchase Order';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category10;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    ReportPO: Report "Purchase Order";
                begin
                    PurchaseHeader := Rec;
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    ReportPO.SetTableView(PurchaseHeader);
                    ReportPO.RunModal();
                end;
            }

        }
        addafter(CopyDocument)
        {
            action(CopyLine)
            {
                ApplicationArea = Suite;
                Caption = 'Copy Line PR';
                Ellipsis = true;
                Enabled = "No." <> '';
                Image = CopyDocument;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    CopyPurchaseDocument: Report "Copy Purchase Document";
                    PRCopy: Page "PR Copy Line";
                begin
                    PRCopy.Setdoc(Rec."No.");
                    PRCopy.RunModal();
                end;
            }

        }
        modify(CopyDocument)
        {
            Visible = false;
        }
        modify("Archive Document")
        {
            Visible = false;
        }
        addafter(Reopen)
        {
            action("Archive Document2")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                //  Caption = 'Archi&ve Document';
                Caption = 'Save as Revision';
                Image = Archive;
                ToolTip = 'Save Document to Revision.(Archive Document)';

                trigger OnAction()
                var
                    ArchiveManagement: Codeunit ArchiveManagement;
                begin
                    ArchiveManagement.ArchivePurchDocument(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
        //moveafter(Reopen; "Archive Document2")
    }
}