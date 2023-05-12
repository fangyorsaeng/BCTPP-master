pageextension 50036 "Sales Cr.Memo List Ex" extends "Sales Credit Memos"
{
    layout
    {
        modify("No.")
        {
            CaptionClass = 'Doc. No.';
        }
        modify("External Document No.")
        {
            CaptionClass = 'Ref. Doc.';
        }
        modify("Posting Date")
        {
            CaptionClass = 'Doc. Date';
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        addbefore(Amount)
        {
            field(Comercial; Comercial)
            {
                ApplicationArea = all;
            }
        }
        moveafter("No."; "Posting Date")
        modify(Status)
        {
            Visible = true;
        }
        addafter(Amount)
        {
            field(VatAmount; "Amount Including VAT" - Amount)
            {
                Caption = 'Vat Amount';
                ApplicationArea = all;
                Editable = false;
            }
            field("Amount Including VAT"; "Amount Including VAT")
            {
                Caption = 'Total Amount';
                ApplicationArea = all;
                Editable = false;
            }
            field("Billing No."; "Billing No.")
            {
                ApplicationArea = ALL;
            }
            field("Receipt No."; "Receipt No.")
            {
                ApplicationArea = all;
            }
            // field("BOI Code"; "BOI Code")
            // {
            //     ApplicationArea = all;
            // }
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
        modify("Post &Batch")
        {
            Visible = false;
        }
        modify(PostAndSend)
        {
            Visible = false;
        }
    }
    trigger OnAfterGetRecord()
    begin
        CalcFields("Billing No.");
        CalcFields("Receipt No.");
    end;
}