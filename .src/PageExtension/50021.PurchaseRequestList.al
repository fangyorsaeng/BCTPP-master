pageextension 50021 "Purchase Request List Ex" extends "Purchase Quotes"
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
        modify("Document Date") { Visible = true; }

        //   modify("Location Code") { Visible = false; }
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
            // field("Send Email to Vendor"; "Send Email to Vendor")
            // {
            //     ApplicationArea = all;
            //     Caption = 'Send Email';
            // }


        }
        movebefore("Create Date"; "Document Date")
        modify("Shortcut Dimension 1 Code") { Visible = true; }
        modify("Shortcut Dimension 2 Code") { Visible = true; }

    }
    actions
    {
        addafter(MakeOrder)
        {
            action(PRList)
            {
                ApplicationArea = Suite;
                Caption = 'Purchase Request List';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    PagePRList: Page "Purchase Request List";
                begin
                    PagePRList.Run();
                end;
            }
        }
    }
}