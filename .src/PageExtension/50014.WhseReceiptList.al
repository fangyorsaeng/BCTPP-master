pageextension 50014 "Whse. Receipt List" extends "Warehouse Receipts"
{
    layout
    {
        addafter("Location Code")
        {
            field("Create Date"; "Create Date")
            {
                ApplicationArea = all;
            }
            field("Create By"; "Create By")
            { ApplicationArea = all; }
            field("Invoice No"; "Invoice No") { ApplicationArea = all; }
            field("Invoice Date"; "Invoice Date") { ApplicationArea = all; }
        }
        modify("Assigned User ID") { Visible = false; }
        addafter("Assigned User ID")
        {
            field("Receipt By"; "Receipt By") { ApplicationArea = all; }

        }
    }
    actions
    {
        addbefore("Co&mments")
        {
            action("ReceiptList")
            {
                ApplicationArea = Warehouse;
                Caption = 'Receipt Lists';
                Image = ViewComments;
                RunObject = Page "Receipt Lists";
                // RunPageLink = "Table Name" = CONST("Whse. Receipt"),
                //                   Type = CONST(" "),
                //                   "No." = FIELD("No.");
                //ToolTip = 'View or add comments for the record.';
            }
        }
    }
}