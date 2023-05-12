pageextension 50049 "Invt. Receipt List Ex" extends "Invt. Receipts"
{
    layout
    {
        modify("No.")
        {
            Caption = 'Receipt No.';
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
        addafter("External Document No.")
        {
            field("Salesperson/Purchaser Code"; "Salesperson/Purchaser Code")
            {
                CaptionClass = 'Ship By';
            }
        }
    }
}

