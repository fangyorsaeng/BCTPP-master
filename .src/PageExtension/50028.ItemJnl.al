pageextension 50028 "Item Jnl Ext" extends "Item Journal"
{
    layout
    {
        modify("Reason Code")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Item No.")
        {
            CaptionClass = 'Part No.';

        }
        modify(Description)
        {
            CaptionClass = 'Part Name';
        }
    }
}