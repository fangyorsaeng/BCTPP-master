pageextension 50030 "Sales Invoice List Ex" extends "Sales Invoice List"
{
    layout
    {
        modify("No.")
        {
            CaptionClass = 'Invoice No.';
        }
        modify("External Document No.")
        {
            CaptionClass = 'Customer PO';
        }
        modify("Posting Date")
        {
            CaptionClass = 'Invoice Date';
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
            field("BOI Code"; "BOI Code")
            {
                ApplicationArea = all;
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