pageextension 50037 "Sales Cr.Memo Card Ex" extends "Sales Credit Memo"
{
    layout
    {
        addafter("Sell-to Address 2")
        {
            field("Address 3"; "Address 3")
            {
                ApplicationArea = all;
                Importance = Promoted;
            }
        }
        modify("Sell-to Post Code")
        {
            Visible = false;
        }
        modify("Sell-to City") { Visible = false; }
        modify("Sell-to Country/Region Code") { Visible = false; }
        modify("Sell-to Contact No.") { Visible = false; }
        modify("Assigned User ID") { Visible = false; }
        modify("Responsibility Center") { Visible = false; }
        modify("Campaign No.") { Visible = false; }
        modify("Sell-to Address") { Importance = Promoted; }
        modify("Sell-to Address 2") { Importance = Promoted; }
        addafter(Status)
        {
            field(Comercial; Comercial)
            {
                ApplicationArea = all;
            }
            field("BOI Code"; "BOI Code")
            {
                ApplicationArea = all;
            }
        }
        modify("No.")
        {
            CaptionClass = 'Doc. No.';
        }
        modify("Posting Date")
        {
            CaptionClass = 'Doc. Date';
        }
        modify("External Document No.")
        {
            CaptionClass = 'Ref. Doc.';
            Importance = Promoted;
        }
        modify(SellToEmail)
        {
            Visible = false;
        }
        modify(SellToPhoneNo)
        {
            Editable = true;
            Visible = false;
        }
        modify(SellToMobilePhoneNo)
        {
            Visible = false;
        }
        addbefore(SellToPhoneNo)
        {
            field("Phone No."; "Phone No.")
            {
                ApplicationArea = all;
            }
            field("Fax No."; "Fax No.")
            { ApplicationArea = all; }

        }
        modify("Payment Method Code")
        {
            Visible = true;
        }
        modify("Company Bank Account Code")
        {
            Visible = false;
        }
        modify("Salesperson Code") { Visible = true; Importance = Promoted; }
        movebefore("Document Date"; "Posting Date")
        moveafter("Document Date"; "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        movebefore("Shortcut Dimension 1 Code"; "Salesperson Code")
        addafter(Status)
        {
            field("Remark HD"; "Remark HD")
            {
                ApplicationArea = all;
                Importance = Promoted;
            }
        }

    }
    actions
    {
        modify("P&osting")
        {
            Visible = false;
        }
        modify(Post)
        {
            Visible = false;
        }
        modify(PostAndSend)
        {
            Visible = false;
        }
        addafter("Preview Posting")
        {
            action(PackingList)
            {
                Caption = 'Print DN/CN Report';
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PrintInv: Report "Sales Invoice DN CN";
                    SalesH: Record "Sales Header";
                begin
                    Clear(PrintInv);
                    SalesH.Reset();
                    CurrPage.SetSelectionFilter(SalesH);
                    PrintInv.SetTableView(SalesH);
                    PrintInv.Run();
                end;
            }
        }

    }
}