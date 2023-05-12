pageextension 50034 "Sales Order Card Ex" extends "Sales Order"
{
    layout
    {
        modify("No.") { CaptionClass = 'Order No.'; }
        modify("Sell-to City") { Visible = false; }
        modify("Sell-to Contact No.") { Visible = false; }
        modify("Sell-to Country/Region Code") { Visible = false; }
        modify("Sell-to Post Code") { Visible = false; }
        modify("Sell-to Phone No.") { Visible = false; }
        addafter("Sell-to Phone No.") { field("Phone No."; "Phone No.") { ApplicationArea = all; Importance = Additional; } }
        addafter(Status)
        {
            field("BOI Code"; "BOI Code")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
            field("Filter Customer"; "Filter Customer")
            {
                ApplicationArea = all;
                Importance = Promoted;
                Visible = false;
            }
        }
        addafter("Sell-to Address 2")
        {
            field("Address 3"; "Address 3")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
        }
        modify("External Document No.")
        {
            Caption = 'Customer PO';
            CaptionClass = 'Customer PO';
        }
        modify("Salesperson Code")
        {
            Importance = Promoted;
        }
        modify("Posting Date") { CaptionClass = 'Doc. Date'; }
        modify("Document Date") { Visible = false; }
        modify("Order Date") { Visible = false; }
        modify("Due Date") { Visible = false; }
        modify("Invoice Details") { Visible = false; }
        modify("Foreign Trade") { Visible = false; }
        modify(Control1900201301) { Visible = false; }
        modify(Control114) { Visible = false; }
        modify("Sell-to Contact") { Importance = Additional; }
        modify("Your Reference") { Importance = Promoted; }


    }
    actions
    {
        modify(Post)
        {
            Visible = false;
        }
        modify(PostAndNew) { Visible = false; }
        modify(PostAndSend) { Visible = false; }
        modify("Create Inventor&y Put-away/Pick") { Visible = false; }
        addafter("Create Inventor&y Put-away/Pick")
        {
            action("ImportExcel")
            {
                ApplicationArea = all;
                Caption = 'Import Part No.';
                Ellipsis = true;
                Image = CreateInventoryPickup;
                Promoted = true;
                PromotedCategory = Process;
                //  ToolTip = 'Create an inventory put-away or inventory pick to handle items on the document according to a basic warehouse configuration that does not require warehouse receipt or shipment documents.';

                trigger OnAction()
                var
                    ImportExcel: Report "Import Excel SalesOrder";
                begin
                    Clear(ImportExcel);
                    ImportExcel.setDoc(Rec."No.");
                    ImportExcel.RunModal();

                    CurrPage.Update();
                end;
            }
        }
    }
}