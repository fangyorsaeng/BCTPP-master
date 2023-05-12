pageextension 50000 "Purchase Lists Ext" extends "Purchase Order List"
{
    layout
    {
        modify("Vendor Authorization No.")
        {
            Visible = false;
        }
        modify("Posting Date")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Location Code") { Visible = false; }
        addafter("Vendor Authorization No.")
        {
            field("Create Date"; "Create Date")
            {
                ApplicationArea = all;
            }
            field("Create By"; "Create By")
            {
                ApplicationArea = all;
            }
            field("Send Email to Vendor"; "Send Email to Vendor")
            {
                ApplicationArea = all;
                Caption = 'Send Email';
            }


        }
        movebefore("Create Date"; "Document Date")
        modify("Shortcut Dimension 1 Code") { Visible = true; }
        modify("Shortcut Dimension 2 Code") { Visible = true; }

    }
}