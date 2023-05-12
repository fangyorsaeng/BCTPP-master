pageextension 50012 "Whse. Receipt Ex" extends "Warehouse Receipt"
{
    layout
    {
        modify("Zone Code")
        {
            Visible = false;
        }
        modify("Bin Code")
        {
            Visible = false;
        }
        addafter("Posting Date")
        {
            field("Invoice No"; "Invoice No") { ApplicationArea = all; Importance = Promoted; Caption = 'Ref. Invoice No.'; }
            field("Invoice Date"; "Invoice Date") { ApplicationArea = all; Importance = Promoted; Caption = 'Ref. Invoice Date'; }

        }
        addafter("Sorting Method")
        {
            field("Create By"; "Create By") { ApplicationArea = all; Editable = false; }
            field("Create Date"; "Create Date") { ApplicationArea = all; Editable = false; }
        }
        modify("Assigned User ID") { Visible = false; }
        addafter("Assigned User ID")
        {
            field("Receipt By"; "Receipt By") { ApplicationArea = all; }

        }
    }
    actions
    {
        addafter("Get Source Documents")
        {
            action(GetPO)
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Image = GetLines;
                Caption = 'Get Purchase Line';
                trigger OnAction()
                var
                    POList: Page "Get Purchase Line";
                begin

                    ///////////POList///////////
                    Clear(POList);
                    POList.setDocNo(Rec."No.");
                    POList.RunModal();
                    CurrPage.Update();
                    ////////////////////////////


                end;
            }
        }
        modify("Get Source Documents")
        {
            Visible = false;
        }
        addafter(CalculateCrossDock)
        {
            action("Get Source Documents2")
            {
                ApplicationArea = Warehouse;
                Caption = 'Get Source Documents';
                Ellipsis = true;
                Image = GetSourceDoc;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+F11';
                ToolTip = 'Open the list of released source documents, such as purchase orders, to select the document to receive items for. ';

                trigger OnAction()
                var
                    GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                begin
                    GetSourceDocInbound.GetSingleInboundDoc(Rec);
                end;
            }
        }
        modify("Post and &Print")
        {
            Visible = false;
        }
        modify("Post Receipt")
        {
            Visible = false;
        }
        addafter("Post Receipt")
        {
            action("Post Receipt2")
            {
                ApplicationArea = Warehouse;
                Caption = 'P&ost Receipt';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ShortCutKey = 'F9';
                ToolTip = 'Post the items as received. A put-away document is created automatically.';

                trigger OnAction()
                var
                    whseRecipt: Record "Warehouse Receipt Header";
                begin
                    //WhsePostRcptYesNo;
                    //CurrPage.WhseReceiptLines.PAGE.WhsePostRcptPrintPostedRcpt();
                    CurrPage.WhseReceiptLines.PAGE.WhsePostRcptYesNo();
                    //Delete Rec. if no Empty//


                end;
            }
        }
    }
    var
        WhseRc: Codeunit "Whse.-Post Receipt";
        WhseReL: Codeunit "Whse.-Post Receipt + Pr. Pos.";
}